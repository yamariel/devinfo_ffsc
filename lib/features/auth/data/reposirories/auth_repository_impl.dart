import 'package:devinfo/core/errors/exceptions.dart';
import 'package:devinfo/core/errors/firebase_auth_error_handler.dart';
import 'package:devinfo/features/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  AuthRepositoryImpl({required this._authRemoteDatasource});

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _authRemoteDatasource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw ServerException(messages: e.toUserFriendlyMessage());
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _authRemoteDatasource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw ServerException(messages: e.toUserFriendlyMessage());
    }
  }

  @override
  Future<void> signOut() async {
    await _authRemoteDatasource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _authRemoteDatasource.getCurrentUser();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _authRemoteDatasource.authStateChanges();
  }

}
