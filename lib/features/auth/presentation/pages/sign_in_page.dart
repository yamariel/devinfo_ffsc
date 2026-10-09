import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_notifier.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_oauth.dart';
import '../widgets/custom_sign_in_or_up.dart';
import '../widgets/custom_text_field_widget.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      ref
          .read(authNotifierProvider.notifier)
          .signIn(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    ref.listen<AsyncValue>(authNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString(),
              style: TextStyle(color: theme.error),
            ),
          ),
        );
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bon retour sur DevInfo",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 30),
                CustomTextFieldWidget(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                CustomTextFieldWidget(
                  isPassword: true,
                  controller: _passwordController,
                  hintText: 'Mot de passe',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 26),
                CustomButton(
                  text: 'Connexion',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _signIn,
                ),
                const SizedBox(height: 30),
                CustomOauth(
                  onTap: () {
                    // TODO: Implémenter la connexion Google
                  },
                ),
                const SizedBox(height: 30),
                CustomSignInOrUp(
                  isSignIn: true,
                  onTap: () => context.go('/sign-up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
