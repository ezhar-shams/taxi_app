import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).register(
      _nameCtrl.text.trim(),
      _phoneCtrl.text.trim(),
      _passCtrl.text,
    );
    if (ok && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final lang  = ref.watch(languageProvider);
    final state = ref.watch(authProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppStrings.get(AppStrings.register, lang)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(AppStrings.fullName, lang),
                      prefixIcon: const Icon(Icons.person_outlined),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? AppStrings.get(AppStrings.fieldRequired, lang) : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(AppStrings.phoneNumber, lang),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    validator: (v) => v == null || v.trim().length < 10
                        ? AppStrings.get(AppStrings.invalidPhone, lang) : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(AppStrings.password, lang),
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => v == null || v.length < 6
                        ? AppStrings.get(AppStrings.passwordTooShort, lang) : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confCtrl,
                    obscureText: _obscure,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(AppStrings.confirmPassword, lang),
                      prefixIcon: const Icon(Icons.lock_outlined),
                    ),
                    validator: (v) => v != _passCtrl.text
                        ? AppStrings.get(AppStrings.passwordsNotMatch, lang) : null,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    label: AppStrings.get(AppStrings.register, lang),
                    onPressed: _submit,
                    isLoading: state.isLoading,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.get(AppStrings.alreadyHaveAccount, lang), style: AppTextStyles.bodyMedium),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: Text(AppStrings.get(AppStrings.login, lang)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
