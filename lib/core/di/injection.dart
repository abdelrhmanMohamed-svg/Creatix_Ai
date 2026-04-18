import 'package:creatix/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:creatix/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:creatix/features/auth/domain/repositories/auth_repository.dart';
import 'package:creatix/features/auth/domain/usecases/get_current_user.dart';
import 'package:creatix/features/auth/domain/usecases/login.dart';
import 'package:creatix/features/auth/domain/usecases/logout.dart';
import 'package:creatix/features/auth/domain/usecases/register.dart';
import 'package:creatix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:creatix/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:creatix/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:creatix/features/profile/domain/repositories/profile_repository.dart';
import 'package:creatix/features/profile/domain/usecases/get_profile.dart';
import 'package:creatix/features/profile/domain/usecases/update_profile.dart';
import 'package:creatix/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDatasource>()),
  );

  getIt.registerFactory<Register>(() => Register(getIt<AuthRepository>()));
  getIt.registerFactory<Login>(() => Login(getIt<AuthRepository>()));
  getIt.registerFactory<Logout>(() => Logout(getIt<AuthRepository>()));
  getIt.registerFactory<GetCurrentUser>(
      () => GetCurrentUser(getIt<AuthRepository>()));

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      register: getIt<Register>(),
      login: getIt<Login>(),
      logout: getIt<Logout>(),
      getCurrentUser: getIt<GetCurrentUser>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDatasource>()),
  );

  getIt.registerFactory<GetProfile>(
    () => GetProfile(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<UpdateProfile>(
    () => UpdateProfile(getIt<ProfileRepository>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfile: getIt<GetProfile>(),
      updateProfile: getIt<UpdateProfile>(),
    ),
  );
}
