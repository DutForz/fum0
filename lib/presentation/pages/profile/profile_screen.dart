import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/components/MyButton.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/domain/entities/registration_method.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/presentation/blocs/profile/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileLoaded state) {
    if (_nicknameController.text != (state.profile.nickname ?? '')) {
      _nicknameController.text = state.profile.nickname ?? '';
    }
    if (_bioController.text != (state.profile.bio ?? '')) {
      _bioController.text = state.profile.bio ?? '';
    }
    if (_phoneController.text != (state.profile.phone ?? '')) {
      _phoneController.text = state.profile.phone ?? '';
    }
    if (_emailController.text != state.profile.email) {
      _emailController.text = state.profile.email;
    }
  }

  Future<void> _pickAvatar() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (pickedFile != null && mounted) {
      context.read<ProfileBloc>().add(AvatarUploadRequested(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(context.localizations.profile),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _syncControllers(state);
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return Center(child: Text(context.localizations.loading));
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          if (state is! ProfileLoaded) {
            return const SizedBox.shrink();
          }

          final profile = state.profile;
          final isEmailEditable =
              profile.registrationMethod == RegistrationMethod.phone;
          final isPhoneEditable =
              profile.registrationMethod == RegistrationMethod.email;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GestureDetector(
                  onTap: state.isUploadingAvatar ? null : _pickAvatar,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundImage: profile.avatarUrl != null
                            ? NetworkImage(profile.avatarUrl!)
                            : null,
                        child: profile.avatarUrl == null
                            ? Icon(
                                Icons.person,
                                size: 56,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              )
                            : null,
                      ),
                      if (state.isUploadingAvatar)
                        const CircularProgressIndicator(),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.localizations.changeAvatar,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                MyTextField(
                  hintText: context.localizations.nickname,
                  Obscure: false,
                  controller: _nicknameController,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  hintText: context.localizations.bio,
                  Obscure: false,
                  controller: _bioController,
                ),
                const SizedBox(height: 12),
                IgnorePointer(
                  ignoring: !isEmailEditable,
                  child: Opacity(
                    opacity: isEmailEditable ? 1 : 0.6,
                    child: MyTextField(
                      hintText: context.localizations.email,
                      Obscure: false,
                      controller: _emailController,
                    ),
                  ),
                ),
                if (!isEmailEditable)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.localizations.emailNotEditable,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                IgnorePointer(
                  ignoring: !isPhoneEditable,
                  child: Opacity(
                    opacity: isPhoneEditable ? 1 : 0.6,
                    child: MyTextField(
                      hintText: context.localizations.phone,
                      Obscure: false,
                      controller: _phoneController,
                    ),
                  ),
                ),
                if (!isPhoneEditable)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.localizations.phoneNotEditable,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Mybutton(
                  inSideText: state.isSaving
                      ? context.localizations.loading
                      : context.localizations.save,
                  onTap: state.isSaving
                      ? null
                      : () {
                          final bloc = context.read<ProfileBloc>();
                          bloc.add(UpdateNickname(_nicknameController.text));
                          bloc.add(UpdateBio(_bioController.text));
                          if (isPhoneEditable) {
                            bloc.add(UpdatePhone(_phoneController.text));
                          }
                          if (isEmailEditable) {
                            bloc.add(UpdateEmail(_emailController.text));
                          }
                          bloc.add(const SaveProfile());
                        },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
