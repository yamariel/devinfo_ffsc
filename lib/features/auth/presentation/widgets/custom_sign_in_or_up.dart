import 'package:flutter/material.dart';

class CustomSignInOrUp extends StatelessWidget {
  final bool isSignIn;
  final void Function()? onTap;
  const CustomSignInOrUp({
    super.key,
    required this.isSignIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isSignIn? Text("Pas de compte ?") : Text('Déjà un compte ?'),
        const SizedBox(width: 4),
        InkWell(
          onTap: onTap,
          child: Text(
            isSignIn ? "S'inscrire" : "Se connecter",
            style: TextStyle(
              color: theme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
