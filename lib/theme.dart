import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===== Colors & Gradients =====
class AppColors {
  // Light
  static const Color primaryLight = Color(0xFF2563EB);
  static const Color secondaryLight = Color(0xFF60A5FA);
  static const Color backgroundLight = Color(0xFFF9FAFB);

  // white with 40% opacity
  static const Color glassLight = Color(0x66FFFFFF);
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  // Dark
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color secondaryDark = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF0F172A);

  // white with 8% opacity
  static const Color glassDark = Color(0x14FFFFFF);
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Gradients
  static Gradient get heroGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [secondaryLight, primaryLight],
      );

  static Gradient get buttonGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [secondaryLight, primaryLight],
      );
}

TextTheme _textTheme(Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;
  final Color primary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  final Color secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

  // Base using Inter
  final base = GoogleFonts.interTextTheme();

  return base.copyWith(
    // Display (marketing/hero)
    displayLarge: base.displayLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: primary,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      color: primary,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      color: primary,
    ),

    // Headlines
    headlineLarge: base.headlineLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      color: primary,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.1,
      color: primary,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.05,
      color: primary,
    ),

    // Titles
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    titleSmall: base.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: primary,
    ),

    // Body 16–18sp
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 18,
      height: 1.4,
      color: primary,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 16,
      height: 1.45,
      color: primary,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: 14,
      height: 1.4,
      color: secondary,
    ),

    // Labels / Captions
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    labelMedium: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
    labelSmall: base.labelSmall?.copyWith(
      fontSize: 12,
      color: secondary,
    ),
  );
}

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        background: AppColors.backgroundLight,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: AppColors.textPrimaryLight,
        onBackground: AppColors.textPrimaryLight,
        onSurface: AppColors.textPrimaryLight,
        error: Color(0xFFFF3B30),
        onError: Colors.white,
        outline: Color(0xFFCBD5E1),
      ),
      textTheme: _textTheme(Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.1,
          color: AppColors.textPrimaryLight,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: AppColors.primaryLight.withValues(alpha: 0.25),
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        background: AppColors.backgroundDark,
        surface: Color(0xFF0B1220),
        onPrimary: Colors.white,
        onSecondary: AppColors.textPrimaryDark,
        onBackground: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        error: Color(0xFFFF453A),
        onError: Colors.white,
        outline: Color(0xFF475569),
      ),
      textTheme: _textTheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.1,
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: AppColors.primaryDark.withValues(alpha: 0.35),
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );

Color kSoftColorPrimary = const Color(0xFFE6EFFC);
Color kSoftColorSecondary = const Color(0xFFEEF0F2);
Color kSoftColorSuccess = const Color(0xFFE0FAEF);
Color kSoftColorInfo = const Color(0xFFE5F7FF);
Color kSoftColorWarning = const Color(0xFFFEF0E8);
Color kSoftColorDanger = const Color(0xFFF9D1D8);
Color kSoftColorDark = const Color(0xFFC7CBCE);
Color kSoftColorLight = const Color(0xFFFEFEFF);

Color kSoftBadgePrimaryColor = const Color(0xFF1C4F93);
Color kSoftBadgeSecondaryColor = const Color(0xFF7D899B);
Color kSoftBadgeSuccessColor = const Color(0xFF00864E);
Color kSoftBadgeInfoColor = const Color(0xFF1978A2);
Color kSoftBadgeWarningColor = const Color(0xFFC46632);
Color kSoftBadgeDangerColor = const Color(0xFF932338);
Color kSoftBadgeLightColor = const Color(0xFF9FA0A2);
Color kSoftBadgeDarkColor = const Color(0xFF070F19);

Color kGreen500Color = const Color(0xFF018A28);
Color kRed100Color = const Color(0xFFFFE4E3);
Color kRed300Color = const Color(0xFFF31E1C);
Color kRed400Color = const Color(0xFFE80000);
Color kRed500Color = const Color(0xFFE80202);
Color kGrey50Color = const Color(0xFFF8F8F8);
Color kGrey75Color = const Color(0xFFD9D9D9);
Color kGrey100Color = const Color(0xFFB9B9B9);
Color kGrey200Color = const Color(0xFFA3A3A3);
Color kGrey300Color = const Color(0xFF808080);
Color kGrey400Color = const Color(0xFF93AAB5);
Color kGrey700Color = const Color(0xFF556A74);
Color kGrey900Color = const Color(0xFF323F44);

Color kLightBlackColor = const Color(0xFF333333);
Color kLightGrey = const Color(0xFFE4E6F6);
Color kDarkBlue = const Color(0xFF20285A);
Color kBlue = const Color(0xFF324EFF);

Color kButtonInactiveColor = const Color(0xFFF9FAFF);
Color kInputBorderColor = const Color(0xFFEBEBEB);
Color kDividerColor = kLightBlackColor.withValues(alpha: 0.05);

List<BoxShadow> kPrimaryBoxShadow = [
  BoxShadow(
    color: lightTheme.primaryColor.withValues(alpha: 0.12),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(0, 2),
  )
];

List<BoxShadow> kSecondaryBoxShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.25),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(0, 4), // changes position of shadow
  ),
];

List<BoxShadow> kTransactionBoxShadow = [
  BoxShadow(
    color: lightTheme.primaryColor.withValues(alpha: 0.08),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(0, 2),
  )
];
List<BoxShadow> kDangerBoxShadow = [
  BoxShadow(
    color: lightTheme.colorScheme.error.withValues(alpha: 0.08),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(0, 2),
  )
];

OutlineInputBorder kInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kInputBorderColor),
  borderRadius: BorderRadius.circular(36.0),
);
