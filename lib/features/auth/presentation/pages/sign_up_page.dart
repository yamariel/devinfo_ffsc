import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_notifier.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_oauth.dart';
import '../widgets/custom_sign_in_or_up.dart';
import '../widgets/custom_text_field_widget.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      ref
          .read(authNotifierProvider.notifier)
          .signUp(email: email, password: password);
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
                  "Bienvenue sur DevInfo",
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
                const SizedBox(height: 18),
                CustomTextFieldWidget(
                  isPassword: true,
                  controller: _passwordConfirmController,
                  hintText: 'Confirmez le mot de passe',
                  labelText: 'Confirmez',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez confirmer le mot de passe';
                    }
                    if (value.trim() != _passwordController.text.trim()) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 26),
                CustomButton(
                  text: 'Inscription',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _signUp,
                ),
                const SizedBox(height: 30),
                CustomOauth(
                  onTap: () {
                    // TODO: Implémenter la connexion Google
                  },
                ),
                const SizedBox(height: 30),
                CustomSignInOrUp(
                  isSignIn: false,
                  onTap: () => context.go('/sign-in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
