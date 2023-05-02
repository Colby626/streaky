import 'package:flutter/material.dart';
class MyTheme with ChangeNotifier{
  static bool _isDark = true;

  ThemeMode currentTheme()
  {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchThemes() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void changeTheme(bool value){
    if (value){
      _isDark = true;
    }
    else{
      _isDark = false;
    }
    notifyListeners();
  }
}