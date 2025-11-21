import 'package:flutter/material.dart';

class NeonTheme {
  static const Color brandDarkBlue = Color(0xFF203664);
  static const Color brandMediumBlue = Color(0xFF405E79);
  static const Color brandBrightGreen = Color(0xFF35C055);
  static const Color brandLightGreen = Color(0xFF6DDA86);
  
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF203664);
  static const Color darkCard = Color(0xFF405E79);
  
  static const Color lightText = Color(0xFFE0E0E0);
  static const Color mediumText = Color(0xFFB0B0B0);
  
  static ThemeData get theme {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: brandBrightGreen, 
      onPrimary: darkBackground,
      secondary: brandLightGreen, 
      onSecondary: Colors.white,
      tertiary: brandLightGreen, 
      onTertiary: Colors.white,
      error: Color(0xFFFF1744),
      onError: Colors.white,
      surface: brandDarkBlue, 
      onSurface: lightText,
      background: darkBackground,
      onBackground: lightText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      
      
      appBarTheme: AppBarTheme(
        backgroundColor: brandDarkBlue, 
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: brandBrightGreen, 
          letterSpacing: 1.2,
          shadows: greenTextShadow, 
        ),
        iconTheme: IconThemeData(color: brandBrightGreen), 
      ),

      
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: brandBrightGreen,
          shadows: [Shadow(color: brandBrightGreen.withOpacity(0.5), blurRadius: 10)],
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: brandBrightGreen,
          shadows: [Shadow(color: brandBrightGreen.withOpacity(0.5), blurRadius: 8)],
        ),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: lightText, letterSpacing: 0.5),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: lightText, letterSpacing: 0.5),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: lightText),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: lightText),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: lightText),
        bodyLarge: TextStyle(fontSize: 16, color: mediumText),
        bodyMedium: TextStyle(fontSize: 14, color: mediumText),
        bodySmall: TextStyle(fontSize: 12, color: mediumText),
      ),
      
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandBrightGreen, 
          foregroundColor: darkBackground,
          elevation: 8,
          shadowColor: brandBrightGreen.withOpacity(0.6), 
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return 4;
              }
              if (states.contains(MaterialState.disabled)) {
                return 0;
              }
              return 8;
          }),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brandLightGreen, 
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brandBrightGreen, 
          side: BorderSide(color: brandBrightGreen, width: 2), 
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brandMediumBlue, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brandBrightGreen.withOpacity(0.3), width: 1), 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brandBrightGreen.withOpacity(0.3), width: 1), 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brandBrightGreen, width: 2), 
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: TextStyle(color: mediumText),
        hintStyle: TextStyle(color: mediumText.withOpacity(0.6)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      
      cardTheme: CardThemeData(
        color: brandMediumBlue, 
        elevation: 4,
        shadowColor: brandBrightGreen.withOpacity(0.2), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      
      
      dialogTheme: DialogThemeData(
        backgroundColor: brandDarkBlue, 
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: brandBrightGreen, 
          shadows: greenTextShadow, 
        ),
        contentTextStyle: TextStyle(fontSize: 16, color: lightText),
      ),

      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brandMediumBlue, 
        contentTextStyle: TextStyle(color: lightText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      
      
      dividerTheme: DividerThemeData(
        color: brandBrightGreen.withOpacity(0.3), 
        thickness: 1,
        space: 1,
      ),
      
      
      listTileTheme: ListTileThemeData(
        tileColor: brandMediumBlue, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textColor: lightText,
        iconColor: brandBrightGreen, 
      ),

      
      iconTheme: IconThemeData(
        color: brandBrightGreen, 
        size: 24,
      ),
    );
  }
  
  
  static BoxDecoration get backgroundGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        darkBackground,
        brandDarkBlue, 
        brandMediumBlue, 
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  );
  
  
  static BoxDecoration get buttonGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        brandBrightGreen, 
        brandLightGreen, 
      ],
      stops: [0.0, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: brandBrightGreen.withOpacity(0.6), 
        blurRadius: 20,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: brandLightGreen.withOpacity(0.3), 
        blurRadius: 30,
        spreadRadius: 4,
      ),
    ],
  );
  
  
  static BoxDecoration get cardGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        brandMediumBlue, 
        brandDarkBlue, 
        darkCard,
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: brandMediumBlue.withOpacity(0.3), 
        blurRadius: 15,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: brandBrightGreen.withOpacity(0.1), 
        blurRadius: 25,
        spreadRadius: 2,
      ),
    ],
  );
  
  
  static List<Shadow> get neonTextShadow => [
    Shadow(
      color: brandBrightGreen.withOpacity(0.9), 
      blurRadius: 10,
    ),
    Shadow(
      color: brandLightGreen.withOpacity(0.6), 
      blurRadius: 20,
    ),
    Shadow(
      color: brandBrightGreen.withOpacity(0.3), 
      blurRadius: 30,
    ),
  ];

  
  static List<Shadow> get greenTextShadow => [
    Shadow(color: brandBrightGreen.withOpacity(0.8), blurRadius: 12),
    Shadow(color: brandLightGreen.withOpacity(0.5), blurRadius: 24),
  ];

  
  static List<BoxShadow> get neonGlow => [
    BoxShadow(
      color: brandBrightGreen.withOpacity(0.6), 
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: brandLightGreen.withOpacity(0.4), 
      blurRadius: 40,
      spreadRadius: 4,
    ),
    BoxShadow(
      color: brandBrightGreen.withOpacity(0.2), 
      blurRadius: 60,
      spreadRadius: 6,
    ),
  ];

  
  static List<BoxShadow> get greenGlow => [
    BoxShadow(color: brandBrightGreen.withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
    BoxShadow(color: brandLightGreen.withOpacity(0.3), blurRadius: 40, spreadRadius: 4),
  ];
  
  
  static List<BoxShadow> get blueGlow => [
    BoxShadow(color: brandMediumBlue.withOpacity(0.4), blurRadius: 15, spreadRadius: 1),
    BoxShadow(color: brandDarkBlue.withOpacity(0.2), blurRadius: 30, spreadRadius: 3),
  ];

  
}
