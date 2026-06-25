import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/core/errors/failures.dart';
import 'package:fumo/data/models/user_model.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/usecases/auth/get_auth_state.dart';
import 'package:fumo/domain/usecases/profile/get_profile.dart';
import 'package:fumo/domain/usecases/profile/update_profile.dart';
import 'package:fumo/domain/usecases/profile/upload_avatar.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    required UploadAvatar uploadAvatar,
    required GetCurrentUser getCurrentUser,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _uploadAvatar = uploadAvatar,
        _getCurrentUser = getCurrentUser,
        super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateNickname>(_onUpdateNickname);
    on<UpdateBio>(_onUpdateBio);
    on<UpdatePhone>(_onUpdatePhone);
    on<UpdateEmail>(_onUpdateEmail);
    on<AvatarUploadRequested>(_onAvatarUploadRequested);
    on<SaveProfile>(_onSaveProfile);
  }

  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final UploadAvatar _uploadAvatar;
  final GetCurrentUser _getCurrentUser;

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentUser = _getCurrentUser();
    if (currentUser == null) {
      emit(const ProfileError('Not authenticated'));
      return;
    }

    emit(const ProfileLoading());
    try {
      final profile = await _getProfile(GetProfileParams(uid: currentUser.uid));
      emit(ProfileLoaded(profile: profile));
    } on ServerFailure catch (e) {
      emit(ProfileError(e.message));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateNickname(
    UpdateNickname event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        profile: UserModel(
          uid: currentState.profile.uid,
          email: currentState.profile.email,
          nickname: event.nickname,
          phone: currentState.profile.phone,
          bio: currentState.profile.bio,
          avatarUrl: currentState.profile.avatarUrl,
          registrationMethod: currentState.profile.registrationMethod,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onUpdateBio(
    UpdateBio event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        profile: UserModel(
          uid: currentState.profile.uid,
          email: currentState.profile.email,
          nickname: currentState.profile.nickname,
          phone: currentState.profile.phone,
          bio: event.bio,
          avatarUrl: currentState.profile.avatarUrl,
          registrationMethod: currentState.profile.registrationMethod,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onUpdatePhone(
    UpdatePhone event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        profile: UserModel(
          uid: currentState.profile.uid,
          email: currentState.profile.email,
          nickname: currentState.profile.nickname,
          phone: event.phone,
          bio: currentState.profile.bio,
          avatarUrl: currentState.profile.avatarUrl,
          registrationMethod: currentState.profile.registrationMethod,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onUpdateEmail(
    UpdateEmail event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        profile: UserModel(
          uid: currentState.profile.uid,
          email: event.email,
          nickname: currentState.profile.nickname,
          phone: currentState.profile.phone,
          bio: currentState.profile.bio,
          avatarUrl: currentState.profile.avatarUrl,
          registrationMethod: currentState.profile.registrationMethod,
        ),
        clearMessage: true,
      ),
    );
  }

  Future<void> _onAvatarUploadRequested(
    AvatarUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      return;
    }

    emit(currentState.copyWith(isUploadingAvatar: true, clearMessage: true));
    try {
      final avatarUrl = await _uploadAvatar(
        UploadAvatarParams(
          uid: currentState.profile.uid,
          filePath: event.filePath,
        ),
      );

      emit(
        currentState.copyWith(
          profile: UserModel(
            uid: currentState.profile.uid,
            email: currentState.profile.email,
            nickname: currentState.profile.nickname,
            phone: currentState.profile.phone,
            bio: currentState.profile.bio,
            avatarUrl: avatarUrl,
            registrationMethod: currentState.profile.registrationMethod,
          ),
          isUploadingAvatar: false,
          message: 'Avatar updated',
        ),
      );
    } on ServerFailure catch (e) {
      emit(
        currentState.copyWith(
          isUploadingAvatar: false,
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isUploadingAvatar: false,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      return;
    }

    emit(currentState.copyWith(isSaving: true, clearMessage: true));
    try {
      final updatedProfile = await _updateProfile(
        UpdateProfileParams(profile: currentState.profile),
      );
      emit(
        currentState.copyWith(
          profile: updatedProfile,
          isSaving: false,
          message: 'Profile saved',
        ),
      );
    } on NicknameTakenFailure catch (e) {
      emit(
        currentState.copyWith(
          isSaving: false,
          message: e.message,
        ),
      );
    } on AuthFailure catch (e) {
      emit(
        currentState.copyWith(
          isSaving: false,
          message: e.message,
        ),
      );
    } on ServerFailure catch (e) {
      emit(
        currentState.copyWith(
          isSaving: false,
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isSaving: false,
          message: e.toString(),
        ),
      );
    }
  }
}
