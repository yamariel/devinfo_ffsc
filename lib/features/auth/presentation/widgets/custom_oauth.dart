import 'package:flutter/material.dart';

class CustomOauth extends StatelessWidget {
  final void Function()? onTap;

  const CustomOauth({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.onSurface, thickness: 1)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Ou continuer avec",
              ),
            ),
            Expanded(child: Divider(color: theme.onSurface, thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/google.png', width: 30, height: 30),
                const SizedBox(width: 12),
                const Text(
                  "Google",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}