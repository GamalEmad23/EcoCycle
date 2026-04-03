part of 'recycling_request_cubit.dart';

abstract class RecyclingRequestState {}

class RecyclingRequestInitial extends RecyclingRequestState {}

class RecyclingRequestUpdated extends RecyclingRequestState {}

class RecyclingRequestLoading extends RecyclingRequestState {}

class RecyclingRequestSuccess extends RecyclingRequestState {}

class RecyclingRequestError extends RecyclingRequestState {
  final String message;
  RecyclingRequestError(this.message);
}
