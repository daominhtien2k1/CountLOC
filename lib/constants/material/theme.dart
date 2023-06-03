/*
  Ref: https://github.com/material-foundation/pesto_flutter
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

@immutable
class CosmeticTheme extends ThemeExtension<CosmeticTheme> {
  const CosmeticTheme({
    this.seedColor1 = const Color(0xFFE97272),
    this.seedColor2 = const Color(0xFFEFAAAA),
    this.seedColor3 = const Color(0xFF50ACD7)
  });

  final Color seedColor1;
  final Color seedColor2;
  final Color seedColor3;

  ColorScheme _lightColorScheme() {
    // có thể generate màu bằng cách này: CorePalette -> Scheme -> ColorScheme -> ThemeData, nhưng không cần thiết nữa vì mình dùng figma material 3 plugin rồi
    // final base = CorePalette.of(seedColor1.value);
    // final primary = base.primary; // example: Scheme(...,onPrimary: primary.get(100)...)

    return ColorScheme.light(
      primary: Color(0xFFA23C3E),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFDAD8),
      onPrimaryContainer: Color(0xFF410007),
      secondary: Color(0xFF9C4145),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFFDAD9),
      onSecondaryContainer: Color(0xFF400009),
      tertiary: Color(0xFF745A2F),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFDEAB),
      onTertiaryContainer: Color(0xFF281900),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      background: Color(0xFFFFFBFF),
      onBackground: Color(0xFF201A1A),
      surface: Color(0xFFFFF8F7),
      onSurface: Color(0xFF201A1A),
      surfaceVariant: Color(0xFFF4DDDC),
      onSurfaceVariant: Color(0xFF524342),
      outline: Color(0xFF857372),
      outlineVariant: Color(0xFFD7C1C0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF362F2E),
      onInverseSurface: Color(0xFFFBEEED),
      inversePrimary: Color(0xFFFFB3B1),
      surfaceTint: Color(0xFFA23C3E)
    );
  }

  ColorScheme _darkColorScheme() {
    return ColorScheme.dark(
      primary: Color(0xFFFFB3B1),
      onPrimary: Color(0xFF630C15),
      primaryContainer: Color(0xFF822529),
      onPrimaryContainer: Color(0xFFFFDAD8),
      secondary: Color(0xFFFFB3B3),
      onSecondary: Color(0xFF5F131B),
      secondaryContainer: Color(0xFF7E2A2F),
      onSecondaryContainer: Color(0xFFFFDAD9),
      tertiary: Color(0xFFE3C18D),
      onTertiary: Color(0xFF412D05),
      tertiaryContainer: Color(0xFF5A4319),
      onTertiaryContainer: Color(0xFFFFDEAB),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      background: Color(0xFF201A1A),
      onBackground: Color(0xFFEDE0DF),
      surface: Color(0xFF181212),
      onSurface: Color(0xFFD0C4C3),
      surfaceVariant: Color(0xFF524342),
      onSurfaceVariant: Color(0xFFD7C1C0),
      outline: Color(0xFFA08C8B),
      outlineVariant: Color(0xFF524342),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFEDE0DF),
      onInverseSurface: Color(0xFF201A1A),
      inversePrimary: Color(0xFFA23C3E),
      surfaceTint: Color(0xFFFFB3B1)
    );
  }

  ThemeData toLightThemeData() {
    final ColorScheme colorScheme = _lightColorScheme();
    final primaryTextTheme = GoogleFonts.robotoTextTheme();
    final textTheme = primaryTextTheme.copyWith(
      displayLarge: GoogleFonts.roboto(fontSize: 57, fontWeight: FontWeight.w400),
      displayMedium: GoogleFonts.roboto(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: GoogleFonts.roboto(fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.w400),
      headlineMedium: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.w400),
      headlineSmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w400),
      titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400),
    );
    // return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
    // return ThemeData.from(colorScheme: colorScheme, textTheme: primaryTextTheme, useMaterial3: true);
    return ThemeData(useMaterial3: true, colorScheme: colorScheme, textTheme: textTheme, fontFamily: 'Roboto',
      visualDensity: VisualDensity.adaptivePlatformDensity);
  }

  ThemeData toDarkThemeData() {
    final ColorScheme colorScheme = _darkColorScheme();
    final primaryTextTheme = GoogleFonts.robotoTextTheme();
    // return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
    return ThemeData.from(colorScheme: colorScheme, textTheme: primaryTextTheme, useMaterial3: true);
  }

  @override
  ThemeExtension<CosmeticTheme> copyWith({
    Color? seedColor1,
    Color? seedColor2,
    Color? seedColor3,
  }) =>
      CosmeticTheme(
          seedColor1: seedColor1 ?? this.seedColor1,
          seedColor2: seedColor2 ?? this.seedColor2,
          seedColor3: seedColor3 ?? this.seedColor3,
      );

  @override
  ThemeExtension<CosmeticTheme> lerp(covariant ThemeExtension<CosmeticTheme>? other, double t) {
    // TODO: implement lerp
    if (other is! CosmeticTheme) return this;
    return CosmeticTheme(
      seedColor1: Color.lerp(seedColor1, other.seedColor1, t)!,
      seedColor2: Color.lerp(seedColor2, other.seedColor2, t)!,
      seedColor3: Color.lerp(seedColor3, other.seedColor3, t)!,
    );
  }

}
