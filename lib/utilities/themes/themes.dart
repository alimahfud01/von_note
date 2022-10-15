import 'package:flutter/material.dart';

enum ThemeKeys { light, dark }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 69, 96, 202),
    primaryColorLight: const Color.fromARGB(255, 83, 116, 245),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 50, 69, 148),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      cursorColor: Color.fromARGB(255, 49, 60, 143),
      selectionHandleColor: Color.fromARGB(255, 73, 101, 216),
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    highlightColor: const Color.fromARGB(153, 158, 158, 158),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
    highlightColor: Colors.white,
    backgroundColor: Colors.black54,
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Colors.grey),
  );

  static ThemeData getThemeFromKey(ThemeKeys themeKey) {
    switch (themeKey) {
      case ThemeKeys.light:
        return lightTheme;
      case ThemeKeys.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
