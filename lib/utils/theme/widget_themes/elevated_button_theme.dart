import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static ButtonStyle lightElevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: MyThemeData.gray_50,
    backgroundColor: MyThemeData.darkBlue,
    elevation: 0,
    shape: const RoundedRectangleBorder(),
    side: const BorderSide(color: MyThemeData.darkBlue),
    padding: const EdgeInsets.symmetric(vertical: 8.0),
  );

  static ButtonStyle darkElevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: MyThemeData.gray_900,
    backgroundColor: MyThemeData.gray_50,
    elevation: 0,
    shape: const RoundedRectangleBorder(),
    side: const BorderSide(color: Colors.grey),
    padding: const EdgeInsets.symmetric(vertical: 8.0),
  );
}
