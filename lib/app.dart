import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/presentation/app_state_manager.dart';
import 'core/di/service_locator.dart';

class QlmSuiteApp extends StatelessWidget {
  const QlmSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateManager(locator<TokenService>()),
      child: Consumer<AppStateManager>(
        builder: (context, state, child) {
          return MaterialApp(
            title: 'QLM Mobile Suite',
            debugShowCheckedModeBanner: false,
            theme: state.currentTheme,
            home: const Scaffold(
              body: Center(
                child: Text('Welcome to QLM Mobile Suite'),
              ),
            ),
          );
        },
      ),
    );
  }
}
