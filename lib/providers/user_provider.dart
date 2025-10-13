import 'package:flutter/material.dart';

import '../extensions/role_type.dart';

class UserProvider extends ChangeNotifier {
  bool isPremium = false;

  // Currently selected UI locale for the app
  Locale? _locale;

  Locale? get locale => _locale;

  // Set the UI locale and notify listeners
  void setLocale(Locale? value) {
    if (_locale == value) return;
    _locale = value;
    notifyListeners();
  }

  String labelFor(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Português';
      case 'ko':
        return '한국어';
      case 'tr':
        return 'Türkçe';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'ja':
        return '日本語';
      case 'ar':
        return 'العربية';
      case 'zh':
        return '中文';
      case 'nl':
        return 'Nederlands';
      default:
        return locale.languageCode;
    }
  }

  ////////////////////////////////////////////////////////////////////////
  // Selected roles
  final Set<RoleType> _selectedRoles = {};

  Set<RoleType> get selectedRoles => Set.unmodifiable(_selectedRoles);

  /// All roles
  List<RoleType> get freeRoles =>
      RoleType.values.where((r) => !r.isPremium).toList();

  List<RoleType> get premiumRoles =>
      RoleType.values.where((r) => r.isPremium).toList();

  bool isRoleSelected(RoleType role) => _selectedRoles.contains(role);

  bool isRolePremium(RoleType role) => role.isPremium;

  /// Select / Unselect role
  void toggleRole(RoleType role,
      {bool allowPremium = false, bool isPremiumUser = false}) {
    if (role.isPremium && !isPremiumUser && !allowPremium) {
      return;
    }

    if (_selectedRoles.contains(role)) {
      _selectedRoles.remove(role);
    } else {
      _selectedRoles.add(role);
    }
    notifyListeners();
  }

  void restoreRolesFromNames(List<String> names) {
    _selectedRoles
      ..clear()
      ..addAll(RoleType.values.where((r) => names.contains(r.name)));
    notifyListeners();
  }

  void clearRoles() {
    _selectedRoles.clear();
    notifyListeners();
  }

  bool get hasSelectedRoles => _selectedRoles.isNotEmpty;

  /// Theme mode logics
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeFromString(String value) {
    if (value.contains('dark')) {
      _themeMode = ThemeMode.dark;
    } else if (value.contains('light')) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
