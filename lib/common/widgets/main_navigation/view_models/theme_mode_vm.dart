import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/models/theme_config_model.dart';

class ThemeConfigViewModel extends Notifier<ThemeConfigModel> {
  ThemeConfigViewModel();

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  @override
  ThemeConfigModel build() {
    return ThemeConfigModel(themeMode: ThemeMode.system);
  }
}

final themeConfigProvider =
    NotifierProvider<ThemeConfigViewModel, ThemeConfigModel>(
  () => ThemeConfigViewModel(),
);
