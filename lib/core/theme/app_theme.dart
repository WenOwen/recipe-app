import 'package:flutter/material.dart';

/// App 主题配置
class AppTheme {
  // 品牌色
  static const Color primaryColor = Color(0xFFFF6B35); // 橙色（食欲感）
  static const Color secondaryColor = Color(0xFF004E64); // 深青色

  // 浅色主题配色
  static const Color lightBackground = Color(0xFFF5F5F5); // 浅灰背景
  static const Color lightSurface = Color(0xFFFFFFFF);    // 白色卡片
  static const Color lightTextPrimary = Color(0xFF1A1A1A);  // 深灰文字
  static const Color lightTextSecondary = Color(0xFF666666); // 中灰文字
  static const Color lightDivider = Color(0xFFE0E0E0);

  // 深色主题配色
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF333333);

  /// 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 1,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: lightTextSecondary.withAlpha(180)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurface,
        selectedColor: primaryColor.withAlpha(40),
        disabledColor: lightDivider,
        labelStyle: const TextStyle(
          color: lightTextPrimary,
          fontSize: 14,
        ),
        secondaryLabelStyle: const TextStyle(
          color: lightTextSecondary,
          fontSize: 14,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lightDivider),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        indicatorColor: primaryColor.withAlpha(40),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: lightTextSecondary,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor, size: 24);
          }
          return const IconThemeData(color: lightTextSecondary, size: 24);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurface,
        contentTextStyle: const TextStyle(color: darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: const TextTheme(
        // 标题 - 更大更粗
        displayLarge: TextStyle(color: lightTextPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: lightTextPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: lightTextPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: lightTextPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: lightTextPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: lightTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        // 列表标题 - 更大更粗
        titleLarge: TextStyle(color: lightTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        // 正文 - 更大更粗
        bodyLarge: TextStyle(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: lightTextPrimary, fontSize: 16, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: lightTextSecondary, fontSize: 14, fontWeight: FontWeight.normal),
        // 标签 - 更大更粗
        labelLarge: TextStyle(color: lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: lightTextSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: lightTextSecondary, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      // 设置全局默认字体
      primaryTextTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: lightTextPrimary, fontSize: 16, fontWeight: FontWeight.normal),
      ),
    );
  }

  /// 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 1,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: darkTextSecondary.withAlpha(180)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurface,
        selectedColor: primaryColor.withAlpha(40),
        disabledColor: darkDivider,
        labelStyle: const TextStyle(
          color: darkTextPrimary,
          fontSize: 14,
        ),
        secondaryLabelStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 14,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkDivider),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: primaryColor.withAlpha(40),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: darkTextSecondary,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor, size: 24);
          }
          return const IconThemeData(color: darkTextSecondary, size: 24);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightSurface,
        contentTextStyle: const TextStyle(color: lightTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: const TextTheme(
        // 标题 - 更大更粗
        displayLarge: TextStyle(color: darkTextPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: darkTextPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: darkTextPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: darkTextPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: darkTextPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: darkTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        // 列表标题 - 更大更粗
        titleLarge: TextStyle(color: darkTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: darkTextPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        // 正文 - 更大更粗
        bodyLarge: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: darkTextPrimary, fontSize: 16, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: darkTextSecondary, fontSize: 14, fontWeight: FontWeight.normal),
        // 标签 - 更大更粗
        labelLarge: TextStyle(color: darkTextPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: darkTextSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: darkTextSecondary, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      // 设置全局默认字体
      primaryTextTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: darkTextPrimary, fontSize: 16, fontWeight: FontWeight.normal),
      ),
    );
  }
}
