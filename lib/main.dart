import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'app_home.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.dynamic;

  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorImageProvider imageSelected = ColorImageProvider.leaves;

  ColorScheme? imageColorScheme = const ColorScheme.light();

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  ThemeData staticLightThemeData() {
    return ThemeData(
      colorSchemeSeed: colorSelectionMethod == ColorSelectionMethod.colorSeed
          ? colorSelected.color
          : null,
      colorScheme: colorSelectionMethod == ColorSelectionMethod.image
          ? imageColorScheme
          : null,
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
    );
  }

  ThemeData staticDarkThemeData() {
    return ThemeData(
      colorSchemeSeed: colorSelectionMethod == ColorSelectionMethod.colorSeed
          ? colorSelected.color
          : imageColorScheme!.primary,
      useMaterial3: useMaterial3,
      brightness: Brightness.dark,
    );
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelectionMethod = ColorSelectionMethod.colorSeed;
      colorSelected = ColorSeed.values[value];
    });
  }

  void handleImageSelect(int value) {
    final String url = ColorImageProvider.values[value].url;
    ColorScheme.fromImageProvider(provider: NetworkImage(url))
        .then((newScheme) {
      setState(() {
        colorSelectionMethod = ColorSelectionMethod.image;
        imageSelected = ColorImageProvider.values[value];
        imageColorScheme = newScheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material 3',
        themeMode: themeMode,
        theme: colorSelectionMethod == ColorSelectionMethod.dynamic
            ? ThemeData(colorScheme: lightColorScheme, useMaterial3: true)
            : staticLightThemeData(),
        darkTheme: colorSelectionMethod == ColorSelectionMethod.dynamic
            ? ThemeData(colorScheme: darkColorScheme, useMaterial3: true)
            : staticDarkThemeData(),
        home: Home(
          useLightMode: useLightMode,
          useMaterial3: useMaterial3,
          colorSelected: colorSelected,
          imageSelected: imageSelected,
          handleBrightnessChange: handleBrightnessChange,
          handleColorSelect: handleColorSelect,
          handleImageSelect: handleImageSelect,
          colorSelectionMethod: colorSelectionMethod,
        ),
      );
    });
  }
}
