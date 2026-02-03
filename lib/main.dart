import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/di/service_locator.dart';
import 'package:qlm_mobile_suite/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  await setupLocator();
  
  runApp(const QlmSuiteApp());
}
