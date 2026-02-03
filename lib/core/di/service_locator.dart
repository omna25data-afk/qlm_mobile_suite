import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../services/token_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
// import '../services/database_service.dart';

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

  // Database (Initialized later)
  // locator.registerLazySingleton(() => DatabaseService());

  // Repositories & Services will be added here
}
