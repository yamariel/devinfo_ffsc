import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase({required this.repository});

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}