from pathlib import Path

root = Path(__file__).resolve().parents[1]
config = (root / 'lib/config/supabase_config.dart').read_text(encoding='utf-8')
auth = (root / 'lib/auth/auth_screen.dart').read_text(encoding='utf-8')
gate = (root / 'lib/auth/auth_gate.dart').read_text(encoding='utf-8')
edge = (root / 'supabase/functions/malaak-ai/index.ts').read_text(encoding='utf-8')

assert 'https://puwomvazbzvjmzzmogoj.supabase.co' in config, 'Malaak is not bound to the approved Supabase project URL'
assert 'sb_publishable_dXLjTrrUK7xdAhaWRF5UPg_SMEZvU9z' in config, 'Approved publishable key missing'
assert 'himyddwbgyxohalxlzaz' not in config, 'Old unrelated Supabase project is still referenced'
assert '_showPassword' in auth and 'suffixIcon' in auth, 'Password visibility control missing'
assert 'resetPasswordForEmail' in auth, 'Password reset flow missing'
assert '_friendlyAuthMessage' in auth, 'Friendly Arabic auth error mapping missing'
assert 'enabled: !_busy' in auth, 'Auth inputs are not disabled while submitting'
assert 'onError:' in gate, 'Auth state stream has no error handler'
assert 'deterministicFallback' in edge, 'Cloud function does not use V6.1 deterministic fallback when OpenAI is unavailable'
assert "mode: 'configuration_required'" not in edge, 'Missing OpenAI key still produces configuration_required instead of coaching fallback'
print('PASS approved Supabase binding and resilient auth/AI fallback verification')
