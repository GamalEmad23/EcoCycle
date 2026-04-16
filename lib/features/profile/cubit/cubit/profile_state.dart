part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileLanguageState extends ProfileState {
  final Locale locale;
  final String langCode;

  ProfileLanguageState({required this.locale, required this.langCode});
}
