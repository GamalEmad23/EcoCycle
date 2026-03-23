// ignore_for_file: empty_catches, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/auth/model/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  FirebaseAuth instance = FirebaseAuth.instance;
  FirebaseFirestore fireInstase = FirebaseFirestore.instance;

  /// Sign Up
  Future<void> createUser(UserData userData) async {
    emit(AuthLoading());
    try {
      final credential = await instance.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      await fireInstase.collection('users').doc(credential.user!.uid).set({
        "email": userData.email,
        "name": userData.name,
      });
      await instance.currentUser!.sendEmailVerification();

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: e.message ?? "Unknown Firebase error"));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// Login
  Future<void> LoginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      final credential = await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.reload;
      if (instance.currentUser!.emailVerified) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(message: "verification_message".tr()));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(message: e.message ?? "Unknown Firebase error"));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }

  /// ResetPassword
  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());
    try {
      await instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordFailure(message: e.toString()));
    }
  }
  
  /// Login with google
  Future<void> signInWithGoogle() async {
    emit(googleLoginLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(googleLoginFailure(message: "تم إلغاء العملية"));
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await instance.signInWithCredential(credential);

      await fireInstase.collection('users').doc(userCredential.user!.uid).set({
        "email": userCredential.user!.email,
        "name": userCredential.user!.displayName,
        "image": userCredential.user!.photoURL,
      }, SetOptions(merge: true));

      emit(googleLoginSuccess());
    } catch (e) {
      emit(googleLoginFailure(message: e.toString()));
    }
  }

  /// Log our
  Future<void> Signout() async{
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await fireInstase
        .collection('users')
        .doc(user.uid)
        .delete();
  }

  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}


  
}
