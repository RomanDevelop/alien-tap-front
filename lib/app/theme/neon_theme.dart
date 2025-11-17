// lib/app/theme/neon_theme.dart
import 'package:flutter/material.dart';

class NeonTheme {
  // Неоновые цвета
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonPurple = Color(0xFF9D00FF);
  static const Color neonPink = Color(0xFFFF00FF);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color neonBlue = Color(0xFF0066FF);
  static const Color neonOrange = Color(0xFFFF6600);
  
  // Темные фоны
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  
  // Светлые акценты
  static const Color lightText = Color(0xFFE0E0E0);
  static const Color mediumText = Color(0xFFB0B0B0);
  
  static ThemeData get theme {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: neonCyan,
      onPrimary: darkBackground,
      secondary: neonPurple,
      onSecondary: Colors.white,
      tertiary: neonPink,
      onTertiary: Colors.white,
      error: Color(0xFFFF1744),
      onError: Colors.white,
      surface: darkSurface,
      onSurface: lightText,
      background: darkBackground,
      onBackground: lightText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: neonCyan,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: neonCyan),
      ),
      
      // Тексты
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: neonCyan,
          shadows: [
            Shadow(
              color: neonCyan.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: neonCyan,
          shadows: [
            Shadow(
              color: neonCyan.withOpacity(0.5),
              blurRadius: 8,
            ),
          ],
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightText,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightText,
          letterSpacing: 0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: lightText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: mediumText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: mediumText,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: mediumText,
        ),
      ),
      
      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonCyan,
          foregroundColor: darkBackground,
          elevation: 8,
          shadowColor: neonCyan.withOpacity(0.5),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return 4;
              }
              if (states.contains(MaterialState.disabled)) {
                return 0;
              }
              return 8;
            },
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: neonPurple,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neonCyan,
          side: BorderSide(color: neonCyan, width: 2),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      
      // Поля ввода
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonCyan.withOpacity(0.3), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonCyan.withOpacity(0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonCyan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: TextStyle(color: mediumText),
        hintStyle: TextStyle(color: mediumText.withOpacity(0.6)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Карточки
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 4,
        shadowColor: neonPurple.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Диалоги
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: neonCyan,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: lightText,
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: TextStyle(color: lightText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: neonCyan.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),
      
      // ListTile
      listTileTheme: ListTileThemeData(
        tileColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textColor: lightText,
        iconColor: neonCyan,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: neonCyan,
        size: 24,
      ),
    );
  }
  
  // Градиент для фона
  static BoxDecoration get backgroundGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        darkBackground,
        darkSurface,
        Color(0xFF0F0F1F),
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  );
  
  // Градиент для кнопок
  static BoxDecoration get buttonGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        neonCyan,
        neonBlue,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: neonCyan.withOpacity(0.5),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ],
  );
  
  // Градиент для карточек
  static BoxDecoration get cardGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        darkCard,
        darkSurface,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: neonPurple.withOpacity(0.2),
        blurRadius: 15,
        spreadRadius: 1,
      ),
    ],
  );
  
  // Неоновое свечение для текста
  static List<Shadow> get neonTextShadow => [
    Shadow(
      color: neonCyan.withOpacity(0.8),
      blurRadius: 10,
    ),
    Shadow(
      color: neonCyan.withOpacity(0.4),
      blurRadius: 20,
    ),
  ];
  
  // Неоновое свечение для элементов
  static List<BoxShadow> get neonGlow => [
    BoxShadow(
      color: neonCyan.withOpacity(0.5),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: neonCyan.withOpacity(0.3),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
  
  // Неоновое свечение фиолетового цвета
  static List<BoxShadow> get neonPurpleGlow => [
    BoxShadow(
      color: neonPurple.withOpacity(0.5),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: neonPurple.withOpacity(0.3),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
  
  // Неоновое свечение розового цвета
  static List<BoxShadow> get neonPinkGlow => [
    BoxShadow(
      color: neonPink.withOpacity(0.5),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: neonPink.withOpacity(0.3),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
}

