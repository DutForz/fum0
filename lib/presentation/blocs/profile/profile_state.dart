part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable { const ProfileState(); @override List<Object?> get props => []; }
class ProfileInitial extends ProfileState { const ProfileInitial(); }
class ProfileLoading extends ProfileState { const ProfileLoading(); }
class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.profile, this.isSaving = false, this.isUploadingAvatar = false, this.message});
  final UserEntity profile;
  final bool isSaving;
  final bool isUploadingAvatar;
  final String? message;
  ProfileLoaded copyWith({UserEntity? profile, bool? isSaving, bool? isUploadingAvatar, String? message, bool clearMessage = false}) {
    return ProfileLoaded(profile: profile ?? this.profile, isSaving: isSaving ?? this.isSaving, isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar, message: clearMessage ? null : (message ?? this.message));
  }
  @override List<Object?> get props => [profile, isSaving, isUploadingAvatar, message];
}
class ProfileError extends ProfileState { const ProfileError(this.message); final String message; @override List<Object?> get props => [message]; }
