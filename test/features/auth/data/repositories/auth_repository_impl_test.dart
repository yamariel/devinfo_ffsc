import 'package:devinfo/core/errors/exceptions.dart';
import 'package:devinfo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:devinfo/features/auth/data/models/user_model.dart';
import 'package:devinfo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late MockAuthRemoteDatasource datasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    datasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(authRemoteDatasource: datasource);
  });

  test('la connexion renvoie l’utilisateur authentifié', () async {
    final user = UserModel(id: 'user-1', email: 'user@example.com');
    when(
      () => datasource.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'secret',
      ),
    ).thenAnswer((_) async => user);

    final result = await repository.signInWithEmailAndPassword(
      email: 'user@example.com',
      password: 'secret',
    );

    expect(result.id, 'user-1');
    expect(result.email, 'user@example.com');
    verify(
      () => datasource.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'secret',
      ),
    ).called(1);
  });

  test('l’inscription renvoie l’utilisateur créé', () async {
    final user = UserModel(id: 'user-2', email: 'new@example.com');
    when(
      () => datasource.signUpWithEmailAndPassword(
        email: 'new@example.com',
        password: 'secret',
      ),
    ).thenAnswer((_) async => user);

    final result = await repository.signUpWithEmailAndPassword(
      email: 'new@example.com',
      password: 'secret',
    );

    expect(result.id, 'user-2');
    expect(result.email, 'new@example.com');
    verify(
      () => datasource.signUpWithEmailAndPassword(
        email: 'new@example.com',
        password: 'secret',
      ),
    ).called(1);
  });

  test(
    'la connexion convertit une erreur Firebase en ServerException',
    () {
      when(
        () => datasource.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'wrong',
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(
        repository.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'wrong',
        ),
        throwsA(
          isA<ServerException>().having(
            (exception) => exception.messages,
            'messages',
            'Email ou mot de passe incorrect.',
          ),
        ),
      );
    },
  );
}
