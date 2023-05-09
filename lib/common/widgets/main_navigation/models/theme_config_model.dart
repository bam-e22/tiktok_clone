import 'package:flutter/material.dart';

class ThemeConfigModel {
  ThemeConfigModel({
    required this.themeMode,
  });

  final ThemeMode themeMode;

  ThemeConfigModel copyWith({ThemeMode? themeMode}) {
    return ThemeConfigModel(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
