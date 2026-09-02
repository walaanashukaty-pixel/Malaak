class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://puwomvazbzvjmzzmogoj.supabase.co',
  );

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_dXLjTrrUK7xdAhaWRF5UPg_SMEZvU9z',
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
