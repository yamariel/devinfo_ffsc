import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
}