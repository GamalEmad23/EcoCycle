import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/model/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks ---
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

void main() {
  group('AuthCubit Advanced Tests', () {
    late AuthCubit authCubit;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseFirestore mockFirestore;
    late MockGoogleSignIn mockGoogleSignIn;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;
    late MockCollectionReference mockCollectionReference;
    late MockDocumentReference mockDocumentReference;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirestore = MockFirebaseFirestore();
      mockGoogleSignIn = MockGoogleSignIn();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      mockCollectionReference = MockCollectionReference();
      mockDocumentReference = MockDocumentReference();

      // Fallback registrations for mocktail if needed
      registerFallbackValue(UserData(email: '', password: '', name: ''));

      authCubit = AuthCubit(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
        googleSignIn: mockGoogleSignIn,
      );
    });

    tearDown(() {
      authCubit.close();
    });

    test('initial state is AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    group('LoginUser', () {
      final email = 'test@test.com';
      final password = 'password123';

      blocTest<AuthCubit, AuthState>(
        'emits [LoginLoading, LoginSuccess] with isAdmin = false when login is successful and email verified',
        build: () {
          when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              )).thenAnswer((_) async => mockUserCredential);

          when(() => mockUserCredential.user).thenReturn(mockUser);
          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(() => mockUser.reload()).thenAnswer((_) async => {});
          when(() => mockUser.emailVerified).thenReturn(true);
          when(() => mockUser.email).thenReturn(email);

          return authCubit;
        },
        act: (cubit) => cubit.LoginUser(email, password),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>().having((s) => s.isAdmin, 'isAdmin', false),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [LoginLoading, LoginSuccess] with isAdmin = true when admin logs in',
        build: () {
          final adminEmail = 'emadg6139@gmail.com';
          when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: adminEmail,
                password: password,
              )).thenAnswer((_) async => mockUserCredential);

          when(() => mockUserCredential.user).thenReturn(mockUser);
          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(() => mockUser.reload()).thenAnswer((_) async => {});
          when(() => mockUser.emailVerified).thenReturn(true);
          when(() => mockUser.email).thenReturn(adminEmail);

          return authCubit;
        },
        act: (cubit) => cubit.LoginUser('emadg6139@gmail.com', password),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>().having((s) => s.isAdmin, 'isAdmin', true),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [LoginLoading, LoginFailure] when email is not verified',
        build: () {
          when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              )).thenAnswer((_) async => mockUserCredential);

          when(() => mockUserCredential.user).thenReturn(mockUser);
          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(() => mockUser.reload()).thenAnswer((_) async => {});
          when(() => mockUser.emailVerified).thenReturn(false);

          return authCubit;
        },
        act: (cubit) => cubit.LoginUser(email, password),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginFailure>(), // The message is localized, so just checking type
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [LoginLoading, LoginFailure] when FirebaseAuthException is thrown',
        build: () {
          when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              )).thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'User not found'));

          return authCubit;
        },
        act: (cubit) => cubit.LoginUser(email, password),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginFailure>().having((s) => s.message, 'message', 'User not found'),
        ],
      );
    });

    group('createUser', () {
      final userData = UserData(email: 'test@test.com', password: 'password', name: 'Test User');

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthSuccess] when user creation is successful',
        build: () {
          // Mock signIn throwing error (user doesn't exist)
          when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: userData.email,
                password: userData.password,
              )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

          // Mock createUser
          when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
                email: userData.email,
                password: userData.password,
              )).thenAnswer((_) async => mockUserCredential);

          when(() => mockUserCredential.user).thenReturn(mockUser);
          when(() => mockUser.uid).thenReturn('user_123');

          // Mock Firestore
          when(() => mockFirestore.collection('users')).thenReturn(mockCollectionReference);
          when(() => mockCollectionReference.doc('user_123')).thenReturn(mockDocumentReference);
          when(() => mockDocumentReference.set(any())).thenAnswer((_) async => {});

          // Mock email verification
          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(() => mockUser.sendEmailVerification()).thenAnswer((_) async => {});

          return authCubit;
        },
        act: (cubit) => cubit.createUser(userData),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
        verify: (_) {
          verify(() => mockDocumentReference.set({
                "email": userData.email,
                "name": userData.name,
              })).called(1);
          verify(() => mockUser.sendEmailVerification()).called(1);
        },
      );
    });

    group('Signout', () {
      test('calls signOut on FirebaseAuth and GoogleSignIn', () async {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
        when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

        await authCubit.Signout();

        verify(() => mockFirebaseAuth.signOut()).called(1);
        verify(() => mockGoogleSignIn.signOut()).called(1);
      });
    });
  });
}
