import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  await setupLocator();
  
  runApp(const QlmSuiteApp());
}
