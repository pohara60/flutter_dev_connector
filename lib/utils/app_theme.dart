import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getAppTheme(BuildContext context) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final accentTextTheme = theme.accentTextTheme;
  final accentColor = Colors.cyan[400];

  final themeData = ThemeData(
    primarySwatch: Colors.grey,
    accentColor: accentColor,
    textTheme: GoogleFonts.ralewayTextTheme(textTheme).copyWith(
      headline1: textTheme.headline1.copyWith(color: accentColor),
      headline2: textTheme.headline2.copyWith(color: accentColor),
      headline3: textTheme.headline3.copyWith(color: accentColor),
      headline4: textTheme.headline4.copyWith(color: accentColor),
      headline5: textTheme.headline5.copyWith(color: accentColor),
    ),
    accentTextTheme: GoogleFonts.ralewayTextTheme(accentTextTheme).copyWith(
      button: accentTextTheme.button.copyWith(color: Colors.white),
    ),
  );
  return themeData;
}
