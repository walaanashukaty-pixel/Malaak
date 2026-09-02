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

assert "password.isEmpty" in auth, 'Login must only require a non-empty password before calling Supabase'
assert "password.length < 6" not in auth, 'Client must not hard-code Supabase password policy'
assert "_friendlyAuthMessage(error, registering: _register)" in auth, 'Auth error mapping must know whether the action is sign-in or sign-up'
assert "weak password" in auth.lower() or "weak_password" in auth.lower(), 'Weak-password errors need a dedicated message'
assert "البريد غير مسجل" in auth or "غير صحيحة" in auth, 'Invalid-login errors need a clear Arabic sign-in message'

print('PASS approved Supabase binding and resilient auth/AI fallback verification')
