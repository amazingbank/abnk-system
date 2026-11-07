import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../core/errors/app_exception.dart';
import '../../core/theme/app_theme.dart';

/// 登录页——简化登录（用户名 + 密码）；指纹 / 安全键盘为纯视觉占位
/// （范围外，POC 演示增量承接）。
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final scope = AppScope.of(context);
    try {
      await scope.state.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppExceptionPresenter.present(e))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AbnkColors.ivory,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ASDM 品牌 logo（assets/brand/asdm-logo.png，SVG 矢量栅格化）
                    Image.asset(
                      'assets/brand/asdm-logo.png',
                      key: const Key('login-logo'),
                      width: 88,
                      height: 88,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AMAZING BANK',
                      textAlign: TextAlign.center,
                      style: AbnkFonts.eyebrow(
                        base: const TextStyle(
                          color: AbnkColors.copper,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Amazing Bank',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: AbnkColors.char,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '手机银行',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AbnkColors.espresso,
                          ),
                    ),
                    const SizedBox(height: 36),
                    TextFormField(
                      key: const Key('login-username'),
                      controller: _usernameController,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '请输入用户名' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('login-password'),
                      controller: _passwordController,
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: '密码',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '请输入密码' : null,
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      key: const Key('login-submit'),
                      onPressed: _submitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('登 录'),
                    ),
                    const SizedBox(height: 20),
                    // 指纹按钮——纯视觉占位（不接入 local_auth，POC 增量承接）。
                    Tooltip(
                      message: '指纹登录（视觉占位）',
                      child: AbsorbPointer(
                        child: IconButton(
                          iconSize: 36,
                          color: scheme.outline,
                          onPressed: () {},
                          icon: const Icon(Icons.fingerprint),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '指纹登录与安全键盘为视觉占位（POC 范围外）',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AbnkColors.taupe500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
