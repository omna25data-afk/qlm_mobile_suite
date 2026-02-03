import 'package:get_it/get_it.dart';
import 'package:qlm_mobile_suite/core/network/api_client.dart';
import 'package:qlm_mobile_suite/core/services/token_service.dart';
import 'package:qlm_mobile_suite/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:qlm_mobile_suite/features/auth/domain/repositories/auth_repository.dart';
import 'package:qlm_mobile_suite/features/auth/domain/usecases/login_usecase.dart';
import 'package:qlm_mobile_suite/features/auth/domain/usecases/logout_usecase.dart';
import 'package:qlm_mobile_suite/core/database/local_database_service.dart';
import 'package:qlm_mobile_suite/features/registry/data/repositories/registry_repository_impl.dart';
import 'package:qlm_mobile_suite/features/registry/domain/repositories/registry_repository.dart';
import 'package:qlm_mobile_suite/features/registry/domain/usecases/get_registry_entries_usecase.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton(() => TokenService());

  // Network
  locator.registerLazySingleton(() => ApiClient(locator<TokenService>()));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<ApiClient>(), locator<TokenService>()),
  );

  // UseCases
  locator.registerLazySingleton(() => LoginUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton(() => LogoutUseCase(locator<AuthRepository>()));

  // Database
  locator.registerLazySingleton(() => LocalDatabaseService());

  // Registry Feature
  locator.registerLazySingleton<RegistryRepository>(
    () => RegistryRepositoryImpl(locator<LocalDatabaseService>(), locator<ApiClient>()),
  );
  locator.registerLazySingleton(() => GetRegistryEntriesUseCase(locator<RegistryRepository>()));
}
