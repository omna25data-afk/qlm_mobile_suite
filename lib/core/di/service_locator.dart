import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../services/token_service.dart';
// import '../services/database_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton(() => TokenService());

  // Network
  locator.registerLazySingleton(() => ApiClient(locator<TokenService>()));

  // Database (Initialized later)
  // locator.registerLazySingleton(() => DatabaseService());

  // Repositories & Services will be added here
}
