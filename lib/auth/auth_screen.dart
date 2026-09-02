import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/theme/app_colors.dart';
import '../widgets/premium_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _showPassword = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }


  String _friendlyAuthMessage(
    AuthException error, {
    required bool registering,
  }) {
    final message = error.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials') ||
        message.contains('user not found')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة، أو الحساب غير موجود على ملاك.';
    }
    if (message.contains('email not confirmed') || message.contains('email_not_confirmed')) {
      return 'لازم تأكدي بريدك الإلكتروني أولًا، وبعدها جرّبي تسجيل الدخول.';
    }
    if (message.contains('user already registered') ||
        message.contains('already been registered') ||
        message.contains('user_already_exists')) {
      return 'هذا البريد مستخدم من قبل. انتقلي إلى تسجيل الدخول بدل إنشاء حساب جديد.';
    }
    if (message.contains('signup is disabled') ||
        message.contains('signups not allowed') ||
        message.contains('signup_disabled')) {
      return 'إنشاء الحسابات غير مفعّل حاليًا على Supabase. فعّلي Email Signups من إعدادات Authentication.';
    }
    if (message.contains('weak password') ||
        message.contains('weak_password') ||
        message.contains('password should') ||
        message.contains('password is too weak') ||
        message.contains('password must')) {
      if (registering) {
        return 'كلمة المرور لا تطابق متطلبات الأمان الحالية في Supabase. اختاري كلمة مرور أقوى ثم حاولي مرة ثانية.';
      }
      return 'كلمة مرور هذا الحساب لا تطابق سياسة الأمان الحالية. استخدمي «نسيت كلمة المرور؟» لتعيين كلمة مرور جديدة.';
    }
    if (message.contains('email address') &&
        (message.contains('invalid') || message.contains('not valid'))) {
      return 'صيغة البريد الإلكتروني غير صحيحة. تأكدي من البريد وحاولي مرة ثانية.';
    }
    if (message.contains('rate limit') ||
        message.contains('too many') ||
        message.contains('over_email_send_rate_limit')) {
      return 'صار في محاولات كثيرة خلال وقت قصير. انتظري قليلًا ثم حاولي مرة ثانية.';
    }

    return registering
        ? 'تعذر إنشاء الحساب الآن. تأكدي من البريد والاتصال بالإنترنت وحاولي مرة ثانية.'
        : 'تعذر تسجيل الدخول الآن. تأكدي من البريد وكلمة المرور والإنترنت وحاولي مرة ثانية.';
  }

  Future<void> _resetPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _messageIsError = true;
        _message = 'اكتبي بريدك الإلكتروني أولًا حتى نرسل رابط استعادة كلمة المرور.';
      });
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      if (mounted) {
        setState(() {
          _messageIsError = false;
          _message = 'أرسلنا رابط استعادة كلمة المرور إلى بريدك إذا كان الحساب موجودًا.';
        });
      }
    } on AuthException catch (error) {
      if (mounted) {
        setState(() {
          _messageIsError = true;
          _message = _friendlyAuthMessage(error, registering: false);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _messageIsError = true;
          _message = 'تعذر إرسال رابط الاستعادة الآن. تأكدي من الإنترنت وحاولي مرة ثانية.';
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    final name = _name.text.trim();
    if (email.isEmpty || !email.contains('@') || password.isEmpty || (_register && name.isEmpty)) {
      setState(() {
        _messageIsError = true;
        _message = _register
            ? 'اكتبي الاسم والبريد الإلكتروني وكلمة المرور.'
            : 'اكتبي البريد الإلكتروني وكلمة المرور.';
      });
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final auth = Supabase.instance.client.auth;
      if (_register) {
        final response = await auth.signUp(
          email: email,
          password: password,
          data: {'display_name': name},
        );
        if (response.session == null && mounted) {
          setState(() {
            _messageIsError = false;
            _message = 'تم إنشاء الحساب. افتحي بريدك لتأكيد الإيميل، وبعدها سجّلي الدخول.';
          });
        }
      } else {
        await auth.signInWithPassword(email: email, password: password);
      }
    } on AuthException catch (error) {
      if (mounted) {
        setState(() {
          _messageIsError = true;
          _message = _friendlyAuthMessage(error, registering: _register);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _messageIsError = true;
          _message = _register
              ? 'تعذر إنشاء الحساب الآن بسبب مشكلة اتصال. تأكدي من الإنترنت وحاولي مرة ثانية.'
              : 'تعذر تسجيل الدخول الآن بسبب مشكلة اتصال. تأكدي من الإنترنت وحاولي مرة ثانية.';
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 42, 20, 28),
            children: [
              Container(
                width: 78,
                height: 78,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lavender.withOpacity(.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 34),
              ),
              const SizedBox(height: 18),
              const Text(
                'ملاك',
                style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, color: AppColors.plum),
              ),
              const SizedBox(height: 6),
              const Text(
                'مساحتك الشخصية لفهم نفسك، تنظيم مشاعرك، وبناء اتزان يعيش معك بالحياة اليومية.',
                style: TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.softText),
              ),
              const SizedBox(height: 28),
              PremiumCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('تسجيل الدخول'), icon: Icon(Icons.login_rounded)),
                        ButtonSegment(value: true, label: Text('حساب جديد'), icon: Icon(Icons.person_add_alt_1_rounded)),
                      ],
                      selected: {_register},
                      onSelectionChanged: _busy
                          ? null
                          : (value) => setState(() {
                                _register = value.first;
                                _message = null;
                              }),
                    ),
                    const SizedBox(height: 18),
                    if (_register) ...[
                      TextField(
                        enabled: !_busy,
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'الاسم أو اللقب',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      enabled: !_busy,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      enabled: !_busy,
                      controller: _password,
                      obscureText: !_showPassword,
                      onSubmitted: (_) {
                        if (!_busy) _submit();
                      },
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          tooltip: _showPassword ? 'إخفاء كلمة المرور' : 'إظهار كلمة المرور',
                          onPressed: _busy ? null : () => setState(() => _showPassword = !_showPassword),
                          icon: Icon(_showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                        ),
                      ),
                    ),
                    if (!_register) ...[
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: _busy ? null : _resetPassword,
                          child: const Text('نسيت كلمة المرور؟'),
                        ),
                      ),
                    ],
                    if (_message != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _message!,
                        style: TextStyle(
                          height: 1.6,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _messageIsError ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: _busy ? null : _submit,
                      icon: _busy
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(_register ? Icons.favorite_outline_rounded : Icons.arrow_back_rounded),
                      label: Text(_register ? 'إنشاء حسابي' : 'دخول إلى ملاك'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'بياناتك السحابية محمية بصلاحيات حسابك. أسرار مزود الذكاء الاصطناعي لا تُخزن داخل التطبيق.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.5, height: 1.7, color: AppColors.mutedText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
