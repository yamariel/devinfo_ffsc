import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_provider.dart';

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  //vérifie si l'utilisateur est connecté au lancement de l'application
  @override
  Future<UserEntity?> build() async {
    final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
    return getCurrentUserUseCase.call();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(signInUseCaseProvider);
      final user = await useCase.call(email: email, password: password);
      state = AsyncValue.data(user);
    } on ServerException catch (e, stackTrace) {
      state = AsyncValue.error(e.messages, stackTrace);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(signUpUseCaseProvider);
      final user = await useCase.call(email: email, password: password);
      state = AsyncValue.data(user);
    } on ServerException catch (e, stackTrace) {
      state = AsyncValue.error(e.messages, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(signOutUseCaseProvider);
      await useCase.call();
      state = const AsyncValue.data(null);
    } on ServerException catch (e, stackTrace) {
      state = AsyncValue.error(e.messages, stackTrace);
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  AuthNotifier.new,
);
