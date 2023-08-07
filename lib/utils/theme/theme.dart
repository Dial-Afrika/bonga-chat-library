import 'package:bonga_chat_app/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:bonga_chat_app/utils/theme/widget_themes/text_field_theme.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../theme/widget_themes/outlined_button_theme.dart';


class TAppTheme {

  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TElevatedButtonTheme.lightElevatedButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: TOutlinedButtonTheme.lightOutlinedButtonStyle,
    ),
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    // BoxDecorationTheme: TBoxDecorationTheme(
    //   style: TBoxDecorationTheme.lightBoxDecorationStyle,
    // ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black87,
    primaryColor: MyThemeData.darkBlue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TElevatedButtonTheme.darkElevatedButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: TOutlinedButtonTheme.darkOutlinedButtonStyle,
    ),
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}

