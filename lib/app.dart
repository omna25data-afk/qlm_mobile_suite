import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/presentation/app_state_manager.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'core/services/token_service.dart';

class QlmSuiteApp extends StatelessWidget {
  const QlmSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppStateManager(locator<TokenService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(locator<LoginUseCase>()),
        ),
      ],
      child: Consumer<AppStateManager>(
        builder: (context, state, child) {
          return MaterialApp(
            title: 'QLM Mobile Suite',
            debugShowCheckedModeBanner: false,
            // Full Arabic Support
            localizationsDelegates: const [
              // GlobalMaterialLocalizations.delegate, // Add if using intl later
            ],
            supportedLocales: const [
              Locale('ar', 'AE'),
            ],
            locale: const Locale('ar', 'AE'),
            theme: state.currentTheme,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
