import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class TTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: MyThemeData.twitterBlue,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MyThemeData.twitterBlue,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: MyThemeData.twitterBlue,
    ),
  );
}
