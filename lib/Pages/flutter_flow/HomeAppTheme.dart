// TODO Implement this library.

// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class HomeAppTheme {


  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static HomeAppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeTheme()
          : LightModeTheme();

  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;

  late Color primaryBtnText;
  late Color lineColor;
  late Color gray600;
  late Color black600;
  late Color tertiary400;

  TextStyle get title1 => GoogleFonts.getFont(
    'Poppins',
    color: primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );
  TextStyle get title2 => GoogleFonts.getFont(
    'Poppins',
    color: secondaryText,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  );
  TextStyle get title3 => GoogleFonts.getFont(
    'Poppins',
    color: primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );
  TextStyle get subtitle1 => GoogleFonts.getFont(
    'Poppins',
    color: primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  TextStyle get subtitle2 => GoogleFonts.getFont(
    'Poppins',
    color: secondaryText,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  TextStyle get bodyText1 => GoogleFonts.getFont(
    'Poppins',
    color: primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  TextStyle get bodyText2 => GoogleFonts.getFont(
    'Fira Sans',
    color: secondaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
}

class LightModeTheme extends HomeAppTheme {
  late Color primaryColor = Color.fromARGB(255, 211, 232, 196);
  late Color secondaryColor = Color.fromARGB(255, 253, 238, 186);
  late Color tertiaryColor = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFFC1CCF1);
  late Color primaryBackground = const Color(0xFFFFFFFF);
  late Color secondaryBackground = const Color(0xB2FDEEBA);
  late Color primaryText = const Color(0xFF101213);
  late Color secondaryText = const Color(0xFF57636C);

  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFFE0E3E7);
  late Color gray600 = Color(0x262D34);
  late Color black600 = Color(0x090F13);
  late Color tertiary400 = Color(0x39D2C0);
}

class DarkModeTheme extends HomeAppTheme {
  late Color primaryColor = const Color(0xFF4B39EF);
  late Color secondaryColor = const Color(0xFF39D2C0);
  late Color tertiaryColor = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFFFF5963);
  late Color primaryBackground = const Color(0xFF1A1F24);
  late Color secondaryBackground = const Color(0xFF101213);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFF95A1AC);

  late Color primaryBtnText = Color(0xFF766E6E);
  late Color lineColor = Color(0xFF22282F);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
        fontFamily!,
        color: color ?? this.color,
        fontSize: fontSize ?? this.fontSize,
        fontWeight: fontWeight ?? this.fontWeight,
        fontStyle: fontStyle ?? this.fontStyle,
        decoration: decoration,
        height: lineHeight,
      )
          : copyWith(
        fontFamily: fontFamily,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
        height: lineHeight,
      );
}
