import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Capital Market Study Group';
  static const String memberRole = 'member';
  static const String adminRole = 'admin';
  static const String pendingRole = 'pending';
}

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  ),
);
