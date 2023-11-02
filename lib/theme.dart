import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helmoliday/util/color_util.dart';

class HelmolidayTheme {
  static const Color primaryColor = Color(0xff0f70b7);

  static InputDecorationTheme lightInputDecoration = InputDecorationTheme(
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
    ),
    hintStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      color: Color(0xff9f9d9d),
    ),
    filled: true,
    fillColor: const Color(0xffe8e8e8),
    isDense: false,
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  );

  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
      bodyLarge: GoogleFonts.openSans(
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
      ),
      displayLarge: GoogleFonts.openSans(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.openSans(
        fontSize: 21.0,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.openSans(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.openSans(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ));

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    ),
  ).copyWith(
    minimumSize:
        MaterialStateProperty.all<Size>(const Size(double.infinity, 44)),
  );

  static ThemeData light() {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorLight: primaryColor,
      primaryColorDark: primaryColor,
      primarySwatch: ColorUtility.createMaterialColor(primaryColor),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      textTheme: lightTextTheme,
      inputDecorationTheme: lightInputDecoration,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle,
      ),
    );
  }
}
