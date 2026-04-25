part of 'admin_cubit.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminSuccess extends AdminState {
  final AdminModel admin;

  AdminSuccess(this.admin);
}

class AdminError extends AdminState {
  final String message;

  AdminError(this.message);
}