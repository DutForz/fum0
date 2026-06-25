part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateNickname extends ProfileEvent {
  const UpdateNickname(this.nickname);

  final String nickname;

  @override
  List<Object?> get props => [nickname];
}

class UpdateBio extends ProfileEvent {
  const UpdateBio(this.bio);

  final String bio;

  @override
  List<Object?> get props => [bio];
}

class UpdatePhone extends ProfileEvent {
  const UpdatePhone(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

class UpdateEmail extends ProfileEvent {
  const UpdateEmail(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class AvatarUploadRequested extends ProfileEvent {
  const AvatarUploadRequested(this.filePath);

  final String filePath;

  @override
  List<Object?> get props => [filePath];
}

class SaveProfile extends ProfileEvent {
  const SaveProfile();
}
