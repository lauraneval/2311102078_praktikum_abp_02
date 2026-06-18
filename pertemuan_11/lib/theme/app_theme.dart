import 'package:flutter/material.dart';

abstract final class AppColors {
  static const darkAccent = Color(0xFF322B22);
  static const headerBg = Color(0xFFA7BFBD);
  static const heading = Color(0xFF605C57);
  static const bodyText = Color(0xFF85817E);
  static const cardBg = Color(0xFFB7C2BF);
  static const scaffoldBg = Color(0xFFD6DFDD);
  static const divider = Color(0xFF605C57);
}

abstract final class AppTextStyles {
  static const _cormorant = 'CormorantGaramond';
  static const _inter = 'Inter';

  static const appTitle = TextStyle(
    fontFamily: _cormorant,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.darkAccent,
    letterSpacing: 1.2,
  );

  static const screenHeading = TextStyle(
    fontFamily: _cormorant,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.heading,
    letterSpacing: 0.8,
  );

  static const productTitle = TextStyle(
    fontFamily: _cormorant,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkAccent,
    letterSpacing: 0.4,
  );

  static const price = TextStyle(
    fontFamily: _inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.heading,
  );

  static const body = TextStyle(
    fontFamily: _inter,
    fontSize: 13,
    color: AppColors.bodyText,
  );

  static const button = TextStyle(
    fontFamily: _inter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.darkAccent,
    letterSpacing: 0.6,
  );

  static const badge = TextStyle(
    fontFamily: _inter,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const cartTotal = TextStyle(
    fontFamily: _cormorant,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.darkAccent,
  );
}

final appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.scaffoldBg,
  colorScheme: const ColorScheme.light(
    primary: AppColors.headerBg,
    onPrimary: AppColors.darkAccent,
    surface: AppColors.cardBg,
    onSurface: AppColors.darkAccent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.headerBg,
    foregroundColor: AppColors.darkAccent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.appTitle,
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.divider,
    thickness: 0.4,
  ),
);