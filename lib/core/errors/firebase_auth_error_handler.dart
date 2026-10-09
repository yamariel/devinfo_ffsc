import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionX on Object {
  String toUserFriendlyMessage() {
    final error = this;
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email ou mot de passe incorrect.';
        case 'email-already-in-use':
          return 'Un compte existe déjà avec cet email.';
        case 'weak-password':
          return 'Mot de passe trop court (6 caractères minimum).';
        case 'invalid-email':
          return 'Adresse email invalide.';
        case 'requires-recent-login':
          return 'Veuillez vous réauthentifier avant de réaliser cette action.';
        default:
          return 'Erreur Firebase (${error.code}) : ${error.message ?? 'Inconnue'}';
      }
    }
    return 'Une erreur inattendue est survenue. Réessayez.';
  }
}