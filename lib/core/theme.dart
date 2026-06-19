import 'package:flutter/material.dart';

/// Bizz brand colors. Dark, nightlife-inspired palette with a red accent.
class BizzColors {
  BizzColors._();

  static const Color primary = Color(0xFFE53935);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF262626);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF999999);
  static const Color border = Color(0xFF2E2E2E);
  static const Color like = Color(0xFF2ECC71);
  static const Color nope = Color(0xFFB0B0B0);
  static const Color danger = Color(0xFFE53935);
}

/// Shared corner radii used across cards, buttons and chips.
class BizzRadius {
  BizzRadius._();

  static const double card = 20;
  static const double button = 12;
  static const double chip = 8;
}

class BizzTheme {
  BizzTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    final colorScheme = base.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: BizzColors.primary,
      onPrimary: Colors.white,
      surface: BizzColors.surface,
      onSurface: BizzColors.textPrimary,
      error: BizzColors.danger,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BizzColors.background,
      primaryColor: BizzColors.primary,
      appBarTheme: const AppBarTheme(
        backgroundColor: BizzColors.background,
        foregroundColor: BizzColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: BizzColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: base.textTheme
          .apply(
            bodyColor: BizzColors.textPrimary,
            displayColor: BizzColors.textPrimary,
          )
          .copyWith(
            headlineMedium: const TextStyle(
              color: BizzColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
            titleLarge: const TextStyle(
              color: BizzColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            bodyMedium: const TextStyle(
              color: BizzColors.textSecondary,
              fontSize: 14,
            ),
          ),
      cardTheme: CardThemeData(
        color: BizzColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BizzRadius.card),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: BizzColors.surfaceVariant,
        selectedColor: BizzColors.primary,
        labelStyle: const TextStyle(color: BizzColors.textPrimary, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BizzRadius.chip),
          side: const BorderSide(color: BizzColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BizzColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BizzRadius.button),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BizzColors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BizzColors.surface,
        hintStyle: const TextStyle(color: BizzColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BizzRadius.button),
          borderSide: const BorderSide(color: BizzColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BizzRadius.button),
          borderSide: const BorderSide(color: BizzColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BizzRadius.button),
          borderSide: const BorderSide(color: BizzColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BizzRadius.button),
          borderSide: const BorderSide(color: BizzColors.danger),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BizzColors.surface,
        selectedItemColor: BizzColors.primary,
        unselectedItemColor: BizzColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      dividerTheme: const DividerThemeData(color: BizzColors.border, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BizzColors.surfaceVariant,
        contentTextStyle: const TextStyle(color: BizzColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BizzRadius.button),
        ),
      ),
    );
  }
}
