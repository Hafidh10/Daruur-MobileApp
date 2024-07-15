import 'package:flutter/material.dart';
import 'package:skiive/utils/theme/constantThemes/appBarTheme.dart';
import 'package:skiive/utils/theme/constantThemes/bottomSheetTheme.dart';
import 'package:skiive/utils/theme/constantThemes/checkBoxTheme.dart';
import 'package:skiive/utils/theme/constantThemes/elevatedButtonTheme.dart';
import 'package:skiive/utils/theme/constantThemes/textFormFieldTheme.dart';
import 'package:skiive/utils/theme/constantThemes/textTheme.dart';

class SkiiveTheme {
  SkiiveTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: SkiiveTextTheme.lightTextTheme,
      elevatedButtonTheme: SkiiveElevatedButtonTheme.lightElevatedButtonTheme,
      appBarTheme: SkiiveAppBarTheme.lightAppBarTheme,
      bottomSheetTheme: SkiiveBottomSheetTheme.lightBottomSheetTheme,
      inputDecorationTheme: SkiiveTextFormFieldTheme.lightInputDecorationTheme,
      checkboxTheme: SkiiveCheckBoxTheme.lightCheckBoxTheme);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: SkiiveTextTheme.darkTextTheme,
      elevatedButtonTheme: SkiiveElevatedButtonTheme.darkElevatedButtonTheme,
      appBarTheme: SkiiveAppBarTheme.darkAppBarTheme,
      bottomSheetTheme: SkiiveBottomSheetTheme.darkBottomSheetTheme,
      inputDecorationTheme: SkiiveTextFormFieldTheme.darkInputDecorationTheme,
      checkboxTheme: SkiiveCheckBoxTheme.darkCheckBoxTheme);
}
