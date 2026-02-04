import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qlm_mobile_suite/core/presentation/app_state_manager.dart';
import 'package:qlm_mobile_suite/core/di/service_locator.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:qlm_mobile_suite/features/auth/presentation/screens/login_screen.dart';
import 'package:qlm_mobile_suite/features/auth/domain/usecases/login_usecase.dart';
import 'package:qlm_mobile_suite/features/auth/domain/usecases/logout_usecase.dart';
import 'package:qlm_mobile_suite/features/registry/presentation/viewmodels/registry_viewmodel.dart';
import 'package:qlm_mobile_suite/core/services/token_service.dart';

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
          create: (_) => AuthViewModel(
            locator<LoginUseCase>(),
            locator<LogoutUseCase>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => locator<RegistryViewModel>(),
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
            darkTheme: ThemeData.dark().copyWith(
              textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
            ),
            themeMode: state.themeMode,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
