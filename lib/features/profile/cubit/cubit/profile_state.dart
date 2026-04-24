part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileLanguageState extends ProfileState {
  final Locale locale;
  final String langCode;

  ProfileLanguageState({required this.locale, required this.langCode});
}

final class profileDataLoading extends ProfileState {}

final class profileDataSuccess extends ProfileState {
  final List profileData;

  profileDataSuccess({required this.profileData});
}

final class profileDataFailuer extends ProfileState {
  final String message;

  profileDataFailuer({required this.message});
}

final class userNameLoading extends ProfileState {}

final class userNameSuccess extends ProfileState {
  final String userName;

  userNameSuccess({required this.userName});
}

final class userNameFailuer extends ProfileState {
  final String message;

  userNameFailuer({required this.message});
}

final class ProfileStatsLoading extends ProfileState {}

final class ProfileStatsSuccess extends ProfileState {
  final double totalWeight;
  final int totalRequests;
  final double points;
  final double co2Saved;
  final double waterSaved;
  final double energySaved;
  final double co2Percentage;
  final String userName;
  final String userImage;

  ProfileStatsSuccess({
    required this.totalWeight,
    required this.totalRequests,
    required this.points,
    required this.co2Saved,
    required this.waterSaved,
    required this.energySaved,
    required this.co2Percentage,
    required this.userName,
    required this.userImage,
  });
}

final class ProfileStatsFailuer extends ProfileState {
  final String message;

  ProfileStatsFailuer({required this.message});
}

// ── Profile image upload states ───────────────────────────────────────────────
final class ProfileImageUploadLoading extends ProfileState {}

final class ProfileImageUploadSuccess extends ProfileState {
  final String imageUrl;
  ProfileImageUploadSuccess({required this.imageUrl});
}

final class ProfileImageUploadFailure extends ProfileState {
  final String message;
  ProfileImageUploadFailure({required this.message});
}
