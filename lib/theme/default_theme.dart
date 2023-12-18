import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_8/theme/custom_colors.dart';

class DefaultTheme {
  static const primary = Color(0xFF067DFF);
  static const onPrimary = Colors.white;
  static const secondary = Color(0xFFEBEBEB);
  static const onSecondary = Colors.white;
  static const error = Colors.red;
  static const onError = Colors.white;
  static const background = Color(0xFFF2F1F6);
  static const onBackground = Colors.black;
  static const surface = Colors.white;
  static const onSurface = Colors.black;

  static final get = ThemeData(
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(

      centerTitle: true,
      backgroundColor: background,
      elevation: 0,
      titleTextStyle: GoogleFonts.lato(
          fontWeight: FontWeight.w700,
          fontSize: 26.0,
          color: onBackground
        ),
    ),
    textTheme: TextTheme(
        displayLarge: GoogleFonts.lato(
          fontWeight: FontWeight.w700,
          fontSize: 26.0,
        ),
        displayMedium: GoogleFonts.lato(
          fontWeight: FontWeight.w400,
          fontSize: 22.0,
        ),
        titleMedium: GoogleFonts.lato(
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
        ),
        titleSmall: GoogleFonts.lato(
          fontWeight: FontWeight.w600,
          fontSize: 17.0,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.lato(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        )).apply(
      bodyColor: onBackground,
      displayColor: onBackground,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
    ),
    extensions: [CustomColors.customColors
    ]
  );
}
