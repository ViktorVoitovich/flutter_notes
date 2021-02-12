import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../config/themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(themeData: Themes.themeData[AppTheme.LightTheme]));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (event is LoadTheme) {
      yield* _mapLoadThemeToState(prefs);
    } else if (event is UpdateTheme) {
      yield* _mapUpdateThemeToState(prefs);
    }
  }

  Stream<ThemeState> _mapLoadThemeToState(SharedPreferences prefs) async* {
    yield* _mapSetTheme(
      prefs,
      !prefs.getBool(Constants.sharedPrefIsDarkMode) ?? false,
    );
  }

  Stream<ThemeState> _mapUpdateThemeToState(SharedPreferences prefs) async* {
    yield* _mapSetTheme(
      prefs,
      !prefs.getBool(Constants.sharedPrefIsDarkMode) ?? false,
    );
  }

  Stream<ThemeState> _mapSetTheme(
    SharedPreferences prefs,
    bool isDarkMode,
  ) async* {
    prefs.setBool(Constants.sharedPrefIsDarkMode, isDarkMode);

    yield ThemeState(
      themeData: Themes
          .themeData[isDarkMode ? AppTheme.DarkTheme : AppTheme.LightTheme],
    );
  }
}
