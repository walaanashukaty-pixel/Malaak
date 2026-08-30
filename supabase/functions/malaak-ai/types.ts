export type CoachingMode = 'coach' | 'safety' | 'fallback' | 'configuration_required';
export type CoachingState = 'high_activation' | 'moderate_activation' | 'reflective' | 'unknown';
export type CoachingNeed =
  | 'safety'
  | 'regulation'
  | 'understanding'
  | 'connection'
  | 'rest'
  | 'respect'
  | 'autonomy'
  | 'clarity'
  | 'decision'
  | 'boundary'
  | 'support'
  | 'unknown';
export type CoachingPattern =
  | 'attachment_alarm'
  | 'reassurance_loop'
  | 'rumination'
  | 'anger_escalation'
  | 'people_pleasing'
  | 'control_overdrive'
  | 'thought_fusion'
  | 'unmet_need'
  | 'conflict_cycle'
  | 'practical_problem'
  | 'unknown';
export type Confidence = 'low' | 'medium' | 'high';

export interface InterventionCard {
  code: string;
  titleAr: string;
  framework: string;
  evidenceTier: 'A' | 'B' | 'C' | 'D' | 'X';
  targets: CoachingNeed[];
  eligibleStates: CoachingState[];
  patterns: CoachingPattern[];
  exclusions: string[];
  durationMinutes: number;
  steps: string[];
  actionTemplate: string;
  fallbackCode: string | null;
  journeyDomainId: string | null;
}



export type CatalogStatus = 'draft' | 'active' | 'paused' | 'retired' | 'prohibited';

export interface CatalogIntervention {
  id: string;
  code: string;
  version: number;
  status: CatalogStatus;
  titleAr: string;
  shortDescriptionAr: string;
  framework: string;
  evidenceTier: 'A' | 'B' | 'C' | 'D' | 'X';
  targetNeeds: string[];
  targetPatterns: string[];
  eligibleStates: CoachingState[];
  journeyDomains: string[];
  exclusions: string[];
  contraindicationNotesAr: string;
  durationMinutes: number;
  steps: string[];
  actionTemplate: string;
  measurementSpec: Record<string, unknown>;
  followUpSpec: Record<string, unknown>;
  fallbackCode: string | null;
  requiresUserConfirmation: boolean;
  requiresHumanSupport: boolean;
}

export interface CatalogContextFlags {
  interpersonalDanger?: boolean;
  highImpact?: boolean;
  catalogUnavailable?: boolean;
}

export interface RoutingResult {
  mode: 'coach' | 'safety';
  state: CoachingState;
  need: CoachingNeed;
  pattern: CoachingPattern;
  patternConfidence: Confidence;
  candidateCodes: string[];
  journeyDomainId: string | null;
}


export interface CandidateObservation {
  sourceType: string;
  sourceId: string | null;
  occurredAt: string | null;
  contextDomain: string;
  trigger: string | null;
  eventFact: string | null;
  automaticThought: string | null;
  emotion: string | null;
  intensityBefore: number | null;
  bodySignals: string[];
  urge: string | null;
  need: string | null;
  behavior: string | null;
  outcome: string | null;
  intensityAfter: number | null;
  recoveryMinutes: number | null;
  interventionHelpfulness: string | null;
}

export interface CoachingFollowUpPayload {
  timing: 'later_today' | 'tomorrow' | 'after_event' | 'none';
  prompt: string;
  journeyDomainId: string | null;
}

export interface CoachingPayload {
  mode: CoachingMode;
  state: CoachingState;
  need: CoachingNeed;
  pattern: CoachingPattern;
  patternConfidence: Confidence;
  goal: string;
  interventionCode: string | null;
  interventionVersion: number | null;
  interventionId: string | null;
  reply: string;
  action: string;
  followUp: CoachingFollowUpPayload;
  observation: CandidateObservation | null;
}
