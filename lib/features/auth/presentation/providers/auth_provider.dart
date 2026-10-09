import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_datasource_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthDatasourceImpl(firebaseAuth: ref.watch(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authRemoteDatasource: ref.watch(authRemoteDataSourceProvider),
  );
});

final authStateChangesProvider = StreamProvider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
final getCurrentUserUseCaseProvider = Provider((ref) {
  return GetCurrentUserUseCase(repository: ref.watch(authRepositoryProvider));
});

final signInUseCaseProvider = Provider((ref) {
  return SignInUseCase(repository: ref.watch(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider((ref) {
  return SignUpUseCase(repository: ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider((ref) {
  return SignOutUseCase(repository: ref.watch(authRepositoryProvider));
});
