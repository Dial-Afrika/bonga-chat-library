import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class TBoxDecorationTheme {
  TBoxDecorationTheme._();

  static ButtonStyle lightBoxDecorationStyle = OutlinedButton.styleFrom(
    foregroundColor: MyThemeData.darkBlue,
    shape: const RoundedRectangleBorder(), // This sets the text (foreground) color
    backgroundColor: Colors.transparent, // This sets the background color
    side: const BorderSide(color: MyThemeData.gray_200), // This sets the border color
    padding: const EdgeInsets.symmetric(vertical: 8.0),
  );

  static ButtonStyle darkBoxDecorationStyle = OutlinedButton.styleFrom(
    foregroundColor: MyThemeData.gray_50,
    shape: const RoundedRectangleBorder(), // Change this to desired dark mode color
    backgroundColor: Colors.transparent, // Change this to desired dark mode color
    side: const BorderSide(color: Colors.grey), // Change this to desired dark mode color
    padding: const EdgeInsets.symmetric(vertical: 8.0),
  );
}