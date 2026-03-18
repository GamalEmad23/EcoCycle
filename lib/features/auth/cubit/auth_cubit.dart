// ignore_for_file: empty_catches

import 'package:bloc/bloc.dart';
import 'package:eco_cycle/features/auth/model/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  FirebaseAuth instance = FirebaseAuth.instance;
  FirebaseFirestore fireInstase = FirebaseFirestore.instance;

  Future<void> createUser(UserData userData) async {
    emit(AuthLoading());
    try {
      await instance.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      await fireInstase.collection('users').add({
        "email":userData.email,
        "name":userData.name,
      });
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: e.message ?? "Unknown Firebase error"));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> LoginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(message: e.message ?? "Unknown Firebase error"));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}
