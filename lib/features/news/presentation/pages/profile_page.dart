import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (shouldSignOut != true || !mounted) return;

    setState(() => _isSigningOut = true);
    try {
      await ref.read(signOutUseCaseProvider).call();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La déconnexion a échoué : $error')),
        );
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: SafeArea(
        child: authState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_off_outlined, size: 48),
                  const SizedBox(height: 12),
                  const Text('Impossible de charger votre profil.'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref.invalidate(authStateChangesProvider),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Aucun utilisateur connecté.'));
            }

            final initial = user.email.isNotEmpty
                ? user.email[0].toUpperCase()
                : '?';

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 12),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Text(
                    initial,
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bienvenue sur DevInfo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: colorScheme.primary,
                    ),
                    title: const Text('Adresse e-mail'),
                    subtitle: Text(user.email),
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _isSigningOut ? null : _signOut,
                  icon: _isSigningOut
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(
                    _isSigningOut ? 'Déconnexion…' : 'Se déconnecter',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
