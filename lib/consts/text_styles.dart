import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: CustomColors.defaultBlack,
  );

  // use in places for text as filter text sizes of home page
  static const TextStyle headline2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: CustomColors.defaultBlack,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: CustomColors.defaultBlack,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CustomColors.defaultBlack,
  );

  static const TextStyle buttonTextStyle = TextStyle(
      fontSize: 12,
      color: CustomColors.defaultWhite,
      fontWeight: FontWeight.w700);

  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 10,
    color: CustomColors.grey,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: CustomColors.defaultBlack,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CustomColors.defaultBlack,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: CustomColors.defaultBlack,
  );

  // Define other text styles as needed
}
