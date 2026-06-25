import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:get_it/get_it.dart';

import 'package:fumo/data/datasources/auth_remote_datasource.dart';

import 'package:fumo/data/datasources/chat_remote_datasource.dart';

import 'package:fumo/data/datasources/profile_remote_datasource.dart';

import 'package:fumo/data/datasources/search_remote_datasource.dart';

import 'package:fumo/data/repositories/auth_repository_impl.dart';

import 'package:fumo/data/repositories/chat_repository_impl.dart';

import 'package:fumo/data/repositories/profile_repository_impl.dart';

import 'package:fumo/data/repositories/search_repository_impl.dart';

import 'package:fumo/domain/repositories/auth_repository.dart';

import 'package:fumo/domain/repositories/chat_repository.dart';

import 'package:fumo/domain/repositories/profile_repository.dart';

import 'package:fumo/domain/repositories/search_repository.dart';

import 'package:fumo/domain/usecases/auth/get_auth_state.dart';

import 'package:fumo/domain/usecases/auth/sign_in_with_email.dart';

import 'package:fumo/domain/usecases/auth/sign_out.dart';

import 'package:fumo/domain/usecases/auth/sign_up_with_email.dart';

import 'package:fumo/domain/usecases/chat/get_last_message.dart';

import 'package:fumo/domain/usecases/chat/get_messages.dart';

import 'package:fumo/domain/usecases/chat/send_message.dart';

import 'package:fumo/domain/usecases/profile/get_profile.dart';

import 'package:fumo/domain/usecases/profile/update_profile.dart';

import 'package:fumo/domain/usecases/profile/upload_avatar.dart';

import 'package:fumo/domain/usecases/search/search_users.dart';

import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';

import 'package:fumo/presentation/blocs/chat/chat_bloc.dart';

import 'package:fumo/presentation/blocs/home/home_bloc.dart';

import 'package:fumo/presentation/blocs/profile/profile_bloc.dart';

import 'package:fumo/presentation/blocs/settings/settings_bloc.dart';



final sl = GetIt.instance;



Future<void> setupDependencyInjection() async {

  sl

    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)

    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)

    ..registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance)

    ..registerLazySingleton<AuthRemoteDataSource>(

      () => AuthRemoteDataSourceImpl(

        firebaseAuth: sl(),

        firestore: sl(),

      ),

    )

    ..registerLazySingleton<ChatRemoteDataSource>(

      () => ChatRemoteDataSourceImpl(

        firestore: sl(),

        firebaseAuth: sl(),

      ),

    )

    ..registerLazySingleton<SearchRemoteDataSource>(

      () => SearchRemoteDataSourceImpl(firestore: sl()),

    )

    ..registerLazySingleton<ProfileRemoteDataSource>(

      () => ProfileRemoteDataSourceImpl(

        firestore: sl(),

        firebaseAuth: sl(),

        firebaseStorage: sl(),

      ),

    )

    ..registerLazySingleton<AuthRepository>(

      () => AuthRepositoryImpl(remoteDataSource: sl()),

    )

    ..registerLazySingleton<ChatRepository>(

      () => ChatRepositoryImpl(remoteDataSource: sl()),

    )

    ..registerLazySingleton<SearchRepository>(

      () => SearchRepositoryImpl(remoteDataSource: sl()),

    )

    ..registerLazySingleton<ProfileRepository>(

      () => ProfileRepositoryImpl(remoteDataSource: sl()),

    )

    ..registerLazySingleton(() => GetAuthState(sl()))

    ..registerLazySingleton(() => GetCurrentUser(sl()))

    ..registerLazySingleton(() => SignInWithEmail(sl()))

    ..registerLazySingleton(() => SignUpWithEmail(sl()))

    ..registerLazySingleton(() => SignOut(sl()))

    ..registerLazySingleton(() => SendMessage(sl()))

    ..registerLazySingleton(() => GetMessages(sl()))

    ..registerLazySingleton(() => GetLastMessage(sl()))

    ..registerLazySingleton(() => SearchUsers(sl()))

    ..registerLazySingleton(() => GetProfile(sl()))

    ..registerLazySingleton(() => UpdateProfile(sl()))

    ..registerLazySingleton(() => UploadAvatar(sl()))

    ..registerFactory(

      () => AuthBloc(

        getAuthState: sl(),

        signInWithEmail: sl(),

        signUpWithEmail: sl(),

        signOut: sl(),

      ),

    )

    ..registerFactory(

      () => ChatBloc(

        getMessages: sl(),

        sendMessage: sl(),

      ),

    )

    ..registerFactory(

      () => HomeBloc(

        chatRepository: sl(),

        searchUsers: sl(),

        getCurrentUser: sl(),

      ),

    )

    ..registerFactory(

      () => SettingsBloc(initialDarkMode: false),

    )

    ..registerFactory(

      () => ProfileBloc(

        getProfile: sl(),

        updateProfile: sl(),

        uploadAvatar: sl(),

        getCurrentUser: sl(),

      ),

    );

}


