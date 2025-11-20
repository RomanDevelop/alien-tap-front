// lib/app/theme/neon_theme.dart
import 'package:flutter/material.dart';

class NeonTheme {
  // НОВАЯ ПАЛИТРА (из предоставленного изображения)
  static const Color brandDarkBlue = Color(0xFF203664);      // Темный синий - основной фон
  static const Color brandMediumBlue = Color(0xFF405E79);     // Средний синий - поверхности
  static const Color brandBrightGreen = Color(0xFF35C055);    // Яркий зеленый - акценты (исправлено 3SC055 -> 35C055)
  static const Color brandLightGreen = Color(0xFF6DDA86);     // Светло-зеленый - вторичные акценты
  
  // Неоновые цвета (сохраняем для совместимости и усиления)
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonPurple = Color(0xFF9D00FF);
  static const Color neonPink = Color(0xFFFF00FF);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color neonBlue = Color(0xFF0066FF);
  static const Color neonOrange = Color(0xFFFF6600);
  
  // Темные фоны (обновлены с новой палитрой)
  static const Color darkBackground = Color(0xFF0A0A0F);     // Оставляем для глубокого контраста
  static const Color darkSurface = Color(0xFF203664);        // НОВЫЙ: brandDarkBlue
  static const Color darkCard = Color(0xFF405E79);            // НОВЫЙ: brandMediumBlue
  
  // Светлые акценты
  static const Color lightText = Color(0xFFE0E0E0);
  static const Color mediumText = Color(0xFFB0B0B0);
  
  // Гибридные цвета (комбинация новой палитры и неона для усиления)
  static const Color accentPrimary = Color(0xFF35C055);       // Яркий зеленый как основной акцент
  static const Color accentSecondary = Color(0xFF6DDA86);     // Светло-зеленый для вторичных элементов
  static const Color accentNeon = Color(0xFF00FFFF);         // Неоновый cyan для особых эффектов
  
  static ThemeData get theme {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: brandBrightGreen,                 // НОВЫЙ: яркий зеленый
      onPrimary: darkBackground,
      secondary: accentSecondary,                 // НОВЫЙ: светло-зеленый
      onSecondary: Colors.white,
      tertiary: neonCyan,                        // Неоновый cyan для особых случаев
      onTertiary: Colors.white,
      error: Color(0xFFFF1744),
      onError: Colors.white,
      surface: brandDarkBlue,                    // НОВЫЙ: темный синий
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
        backgroundColor: brandDarkBlue,            // НОВЫЙ: темный синий
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: brandBrightGreen,                // НОВЫЙ: яркий зеленый
          letterSpacing: 1.2,
          shadows: greenTextShadow,                // НОВЫЙ: зеленое свечение
        ),
        iconTheme: IconThemeData(color: brandBrightGreen),  // НОВЫЙ: яркий зеленый
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
      
      // Кнопки (обновлены новой палитрой)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandBrightGreen,       // НОВЫЙ: яркий зеленый
          foregroundColor: darkBackground,
          elevation: 8,
          shadowColor: brandBrightGreen.withOpacity(0.6),  // НОВЫЙ: зеленое свечение
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
          foregroundColor: accentSecondary,        // НОВЫЙ: светло-зеленый
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brandBrightGreen,       // НОВЫЙ: яркий зеленый
          side: BorderSide(color: brandBrightGreen, width: 2),  // НОВЫЙ
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
      
      // Поля ввода (обновлены новой палитрой)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brandMediumBlue,               // НОВЫЙ: средний синий
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brandBrightGreen.withOpacity(0.3), width: 1),  // НОВЫЙ
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brandBrightGreen.withOpacity(0.3), width: 1),  // НОВЫЙ
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brandBrightGreen, width: 2),  // НОВЫЙ: яркий зеленый
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: TextStyle(color: mediumText),
        hintStyle: TextStyle(color: mediumText.withOpacity(0.6)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Карточки (обновлены новой палитрой)
      cardTheme: CardThemeData(
        color: brandMediumBlue,                   // НОВЫЙ: средний синий
        elevation: 4,
        shadowColor: brandBrightGreen.withOpacity(0.2),  // НОВЫЙ: зеленое свечение
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Диалоги (обновлены новой палитрой)
      dialogTheme: DialogThemeData(
        backgroundColor: brandDarkBlue,            // НОВЫЙ: темный синий
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: brandBrightGreen,                // НОВЫЙ: яркий зеленый
          shadows: greenTextShadow,                // НОВЫЙ: зеленое свечение
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: lightText,
        ),
      ),
      
      // Snackbar (обновлен новой палитрой)
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brandMediumBlue,          // НОВЫЙ: средний синий
        contentTextStyle: TextStyle(color: lightText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Divider (обновлен новой палитрой)
      dividerTheme: DividerThemeData(
        color: brandBrightGreen.withOpacity(0.3),  // НОВЫЙ: зеленый
        thickness: 1,
        space: 1,
      ),
      
      // ListTile (обновлен новой палитрой)
      listTileTheme: ListTileThemeData(
        tileColor: brandMediumBlue,               // НОВЫЙ: средний синий
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textColor: lightText,
        iconColor: brandBrightGreen,              // НОВЫЙ: яркий зеленый
      ),
      
      // Icon Theme (обновлен новой палитрой)
      iconTheme: IconThemeData(
        color: brandBrightGreen,                 // НОВЫЙ: яркий зеленый
        size: 24,
      ),
    );
  }
  
  // Градиент для фона (усилен новой палитрой)
  static BoxDecoration get backgroundGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        darkBackground,           // Глубокий черный для контраста
        brandDarkBlue,            // НОВЫЙ: темный синий
        brandMediumBlue,          // НОВЫЙ: средний синий
        Color(0xFF0F0F1F),        // Очень темный для глубины
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
    ),
  );
  
  // Градиент для кнопок (усилен новой палитрой)
  static BoxDecoration get buttonGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        brandBrightGreen,          // НОВЫЙ: яркий зеленый
        accentSecondary,          // НОВЫЙ: светло-зеленый
        neonCyan,                 // Неоновый для свечения
      ],
      stops: [0.0, 0.7, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: brandBrightGreen.withOpacity(0.6),  // Усиленное свечение зеленым
        blurRadius: 20,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: neonCyan.withOpacity(0.3),          // Дополнительное неоновое свечение
        blurRadius: 30,
        spreadRadius: 4,
      ),
    ],
  );
  
  // Градиент для карточек (усилен новой палитрой)
  static BoxDecoration get cardGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        brandMediumBlue,           // НОВЫЙ: средний синий
        brandDarkBlue,            // НОВЫЙ: темный синий
        darkCard,                 // Старый darkCard для глубины
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: brandMediumBlue.withOpacity(0.3),  // НОВЫЙ: свечение синим
        blurRadius: 15,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: brandBrightGreen.withOpacity(0.1),  // НОВЫЙ: легкое зеленое свечение
        blurRadius: 25,
        spreadRadius: 2,
      ),
    ],
  );
  
  // Неоновое свечение для текста (усилено новой палитрой)
  static List<Shadow> get neonTextShadow => [
    Shadow(
      color: brandBrightGreen.withOpacity(0.9),  // НОВЫЙ: яркий зеленый
      blurRadius: 10,
    ),
    Shadow(
      color: neonCyan.withOpacity(0.6),          // Неоновый cyan для глубины
      blurRadius: 20,
    ),
    Shadow(
      color: brandBrightGreen.withOpacity(0.3),  // НОВЫЙ: дополнительное свечение
      blurRadius: 30,
    ),
  ];
  
  // Новое свечение для зеленых акцентов
  static List<Shadow> get greenTextShadow => [
    Shadow(
      color: brandBrightGreen.withOpacity(0.8),
      blurRadius: 12,
    ),
    Shadow(
      color: accentSecondary.withOpacity(0.5),
      blurRadius: 24,
    ),
  ];
  
  // Неоновое свечение для элементов (усилено новой палитрой)
  static List<BoxShadow> get neonGlow => [
    BoxShadow(
      color: brandBrightGreen.withOpacity(0.6),   // НОВЫЙ: яркий зеленый
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: neonCyan.withOpacity(0.4),          // Неоновый cyan
      blurRadius: 40,
      spreadRadius: 4,
    ),
    BoxShadow(
      color: brandBrightGreen.withOpacity(0.2),   // НОВЫЙ: дополнительное свечение
      blurRadius: 60,
      spreadRadius: 6,
    ),
  ];
  
  // Новое зеленое свечение
  static List<BoxShadow> get greenGlow => [
    BoxShadow(
      color: brandBrightGreen.withOpacity(0.5),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: accentSecondary.withOpacity(0.3),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
  
  // Синее свечение для фоновых элементов
  static List<BoxShadow> get blueGlow => [
    BoxShadow(
      color: brandMediumBlue.withOpacity(0.4),
      blurRadius: 15,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: brandDarkBlue.withOpacity(0.2),
      blurRadius: 30,
      spreadRadius: 3,
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

