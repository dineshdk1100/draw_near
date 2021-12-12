
import 'package:draw_near/services/user-service.dart';
import 'package:flutter/material.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';
class MyManager implements IThemeModeManager {
  @override
  Future<String> loadThemeMode() async {
    return Future.value(UserService.instance.theme);
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    UserService.instance.theme = value.split('.')[1];
    return Future.value(true);
  }
}