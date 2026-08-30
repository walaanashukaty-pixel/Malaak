class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://himyddwbgyxohalxlzaz.supabase.co',
  );

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_KLCkvgzSCNIbDIHJh68TrA_d7uP-ePv',
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
