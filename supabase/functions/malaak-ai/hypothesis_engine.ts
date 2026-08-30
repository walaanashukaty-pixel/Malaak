export type HypothesisStatus = 'candidate' | 'repeated' | 'user_validated' | 'user_rejected' | 'dormant';
export type HypothesisConfidence = 'low' | 'medium' | 'high';
export type UserValidation = 'yes' | 'partly' | 'no' | null;

export interface EvidenceObservation {
  id: string;
  occurredAt: string;
  contextDomain: string;
}

export interface HypothesisEvidenceInput {
  supporting: EvidenceObservation[];
  contradicting: EvidenceObservation[];
  userValidation?: UserValidation;
  rejectedAt?: string | null;
  strongContradiction?: boolean;
  activeJourneyLinked?: boolean;
  now: string;
}

export interface HypothesisDecision {
  status: HypothesisStatus;
  confidenceLabel: HypothesisConfidence;
  supportCount: number;
  distinctDays: number;
  distinctContexts: number;
  supportingObservationIds: string[];
  contradictingObservationIds: string[];
  firstSeenAt: string | null;
  lastSeenAt: string | null;
  eligibleForRouting: boolean;
  freshAfterRejection: boolean;
}

const NINETY_DAYS_MS = 90 * 24 * 60 * 60 * 1000;

function validTimestamp(value: string): number | null {
  const ms = Date.parse(value);
  return Number.isFinite(ms) ? ms : null;
}

function dedupeObservations(items: EvidenceObservation[]): EvidenceObservation[] {
  const byId = new Map<string, EvidenceObservation>();
  for (const item of items) {
    if (!item || typeof item.id !== 'string' || !item.id.trim()) continue;
    const occurredMs = validTimestamp(item.occurredAt);
    if (occurredMs === null) continue;
    if (!byId.has(item.id)) {
      byId.set(item.id, {
        id: item.id,
        occurredAt: new Date(occurredMs).toISOString(),
        contextDomain: typeof item.contextDomain === 'string' ? item.contextDomain.trim() : '',
      });
    }
  }
  return [...byId.values()].sort((a, b) => Date.parse(a.occurredAt) - Date.parse(b.occurredAt));
}

function distinctUtcDays(items: EvidenceObservation[]): number {
  return new Set(items.map((item) => item.occurredAt.slice(0, 10))).size;
}

function distinctContexts(items: EvidenceObservation[]): number {
  return new Set(items.map((item) => item.contextDomain).filter(Boolean)).size;
}

function baseDecision(
  supporting: EvidenceObservation[],
  contradicting: EvidenceObservation[],
  freshAfterRejection: boolean,
): Omit<HypothesisDecision, 'status' | 'confidenceLabel' | 'eligibleForRouting'> {
  return {
    supportCount: supporting.length,
    distinctDays: distinctUtcDays(supporting),
    distinctContexts: distinctContexts(supporting),
    supportingObservationIds: supporting.map((item) => item.id),
    contradictingObservationIds: contradicting.map((item) => item.id),
    firstSeenAt: supporting[0]?.occurredAt ?? null,
    lastSeenAt: supporting.at(-1)?.occurredAt ?? null,
    freshAfterRejection,
  };
}

function isDormant(lastSeenAt: string | null, now: string, activeJourneyLinked: boolean): boolean {
  if (!lastSeenAt || activeJourneyLinked) return false;
  const lastMs = validTimestamp(lastSeenAt);
  const nowMs = validTimestamp(now);
  if (lastMs === null || nowMs === null || nowMs < lastMs) return false;
  return nowMs - lastMs > NINETY_DAYS_MS;
}

export function evaluateHypothesisEvidence(input: HypothesisEvidenceInput): HypothesisDecision {
  const allSupporting = dedupeObservations(input.supporting ?? []);
  const contradicting = dedupeObservations(input.contradicting ?? []);
  const rejectedMs = input.rejectedAt ? validTimestamp(input.rejectedAt) : null;
  const wasRejected = input.userValidation === 'no' && rejectedMs !== null;

  let supporting = allSupporting;
  let freshAfterRejection = false;
  if (wasRejected) {
    supporting = allSupporting.filter((item) => Date.parse(item.occurredAt) > rejectedMs!);
    freshAfterRejection = supporting.length > 0;
    if (!freshAfterRejection) {
      const base = baseDecision([], contradicting, false);
      return {
        ...base,
        status: 'user_rejected',
        confidenceLabel: 'low',
        eligibleForRouting: false,
      };
    }
  }

  const base = baseDecision(supporting, contradicting, freshAfterRejection);

  // A prior explicit rejection is a user-controlled routing lock. New evidence may
  // reopen the item for review, but it cannot silently reactivate the pattern.
  if (wasRejected && freshAfterRejection) {
    return {
      ...base,
      status: 'candidate',
      confidenceLabel: 'low',
      eligibleForRouting: false,
    };
  }

  if (supporting.length === 0) {
    return {
      ...base,
      status: 'candidate',
      confidenceLabel: 'low',
      eligibleForRouting: false,
    };
  }

  let status: HypothesisStatus = 'candidate';
  let confidenceLabel: HypothesisConfidence = 'low';

  if (!input.strongContradiction) {
    const explicitYes = !wasRejected && input.userValidation === 'yes';
    if (supporting.length >= 5 && base.distinctDays >= 3 && explicitYes) {
      status = 'user_validated';
      confidenceLabel = 'high';
    } else if (supporting.length >= 6 && base.distinctContexts >= 2) {
      status = 'repeated';
      confidenceLabel = 'high';
    } else if (supporting.length >= 3 && base.distinctDays >= 2) {
      status = 'repeated';
      confidenceLabel = 'medium';
    }
  }

  if (isDormant(base.lastSeenAt, input.now, input.activeJourneyLinked === true)) {
    status = 'dormant';
    confidenceLabel = 'low';
  }

  return {
    ...base,
    status,
    confidenceLabel,
    eligibleForRouting: status === 'repeated' || status === 'user_validated',
  };
}
