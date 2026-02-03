import 'package:flutter/material.dart';
import 'package:qlm_mobile_suite/core/theme/app_theme.dart';
import 'package:qlm_mobile_suite/core/services/token_service.dart';

class AppStateManager extends ChangeNotifier {
  final TokenService _tokenService;
  
  ThemeData _currentTheme = AppTheme.guardianTheme;
  String _currentRole = 'guardian';

  AppStateManager(this._tokenService) {
    _loadSettings();
  }

  ThemeData get currentTheme => _currentTheme;
  String get currentRole => _currentRole;

  Future<void> _loadSettings() async {
    final role = await _tokenService.getRole();
    if (role != null) {
      setRole(role);
    }
  }

  void setRole(String role) {
    _currentRole = role;
    switch (role) {
      case 'admin':
        _currentTheme = AppTheme.adminTheme;
        break;
      case 'clerk':
        _currentTheme = AppTheme.clerkTheme;
        break;
      default:
        _currentTheme = AppTheme.guardianTheme;
    }
    notifyListeners();
  }
}
