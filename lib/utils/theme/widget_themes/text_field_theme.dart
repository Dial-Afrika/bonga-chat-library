import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
        border: OutlineInputBorder(),
        prefixIconColor: MyThemeData.darkBlue,
        floatingLabelStyle: TextStyle(color: MyThemeData.darkBlue),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: MyThemeData.darkBlue)
        )
      );

  static InputDecorationTheme darkInputDecorationTheme =
  const InputDecorationTheme(
      border: OutlineInputBorder(),
      prefixIconColor: MyThemeData.gray_200,
      floatingLabelStyle: TextStyle(color: MyThemeData.gray_200),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: MyThemeData.gray_200)
      )
  );
}