import 'package:flutter/material.dart';

/// Профессиональная цветовая палитра для игрового приложения с неоновой концепцией
/// Следует лучшим практикам Material Design 3 и WCAG для доступности
class NeonTheme {
  // ========== Основные брендовые цвета ==========
  /// Яркий зеленый - основной акцентный цвет (Primary)
  static const Color brandBrightGreen = Color(0xFF00FF88); // Более яркий и насыщенный
  /// Светлый зеленый - вторичный акцент (Secondary)
  static const Color brandLightGreen = Color(0xFF66FFB3);

  /// Темно-синий - основной фон (Dark Blue)
  static const Color brandDarkBlue = Color(0xFF1A1F3A);

  /// Средний синий - поверхности (Medium Blue)
  static const Color brandMediumBlue = Color(0xFF2A3455);

  /// Глубокий синий - для карточек (Deep Blue)
  static const Color brandDeepBlue = Color(0xFF15192B);

  // ========== Фоновые цвета ==========
  /// Основной темный фон
  static const Color darkBackground = Color(0xFF0D0F1A);

  /// Поверхности (Surface)
  static const Color darkSurface = Color(0xFF1A1F3A);

  /// Карточки и контейнеры
  static const Color darkCard = Color(0xFF252B45);

  /// Элевация поверхностей
  static const Color darkElevated = Color(0xFF2F3655);

  // ========== Текстовые цвета ==========
  /// Основной текст (высокий контраст)
  static const Color lightText = Color(0xFFF5F7FA);

  /// Вторичный текст (средний контраст)
  static const Color mediumText = Color(0xFFB8C5D6);

  /// Третичный текст (низкий контраст)
  static const Color dimText = Color(0xFF8A95A8);

  /// Текст на светлом фоне
  static const Color darkText = Color(0xFF0D0F1A);

  // ========== Семантические цвета ==========
  /// Успех (Success)
  static const Color success = Color(0xFF00FF88);
  static const Color successLight = Color(0xFF66FFB3);
  static const Color successDark = Color(0xFF00CC6A);

  /// Предупреждение (Warning)
  static const Color warning = Color(0xFFFFB84D);
  static const Color warningLight = Color(0xFFFFD699);
  static const Color warningDark = Color(0xFFE69900);

  /// Ошибка (Error)
  static const Color error = Color(0xFFFF4D6D);
  static const Color errorLight = Color(0xFFFF8FA3);
  static const Color errorDark = Color(0xFFE6002E);

  /// Информация (Info)
  static const Color info = Color(0xFF4DA6FF);
  static const Color infoLight = Color(0xFF80C1FF);
  static const Color infoDark = Color(0xFF1A8CFF);

  // ========== Дополнительные акцентные цвета ==========
  /// Фиолетовый акцент (для особых элементов)
  static const Color accentPurple = Color(0xFF9D4EDD);

  /// Циан акцент
  static const Color accentCyan = Color(0xFF00E5FF);

  /// Оранжевый акцент
  static const Color accentOrange = Color(0xFFFF6B35);

  static ThemeData get theme {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: brandBrightGreen,
      onPrimary: darkBackground,
      secondary: brandLightGreen,
      onSecondary: Colors.white,
      tertiary: brandLightGreen,
      onTertiary: Colors.white,
      error: error,
      onError: lightText,
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
        backgroundColor: darkSurface,
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
          foregroundColor: darkText,
          elevation: 8,
          shadowColor: brandBrightGreen.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return 4;
            }
            if (states.contains(MaterialState.disabled)) {
              return 0;
            }
            if (states.contains(MaterialState.hovered)) {
              return 12;
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
        color: darkCard,
        elevation: 4,
        shadowColor: brandBrightGreen.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
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
        backgroundColor: darkCard,
        contentTextStyle: TextStyle(color: lightText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        actionTextColor: brandBrightGreen,
      ),

      dividerTheme: DividerThemeData(color: brandBrightGreen.withOpacity(0.3), thickness: 1, space: 1),

      listTileTheme: ListTileThemeData(
        tileColor: darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textColor: lightText,
        iconColor: brandBrightGreen,
        selectedTileColor: brandMediumBlue.withOpacity(0.5),
      ),

      iconTheme: IconThemeData(color: brandBrightGreen, size: 24),
    );
  }

  /// Градиент фона с улучшенной глубиной
  static BoxDecoration get backgroundGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [darkBackground, brandDeepBlue, brandDarkBlue, brandMediumBlue],
      stops: const [0.0, 0.3, 0.7, 1.0],
    ),
  );

  /// Альтернативный градиент для специальных экранов
  static BoxDecoration get alternativeGradient => BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.topLeft,
      radius: 1.5,
      colors: [brandDarkBlue.withOpacity(0.8), darkBackground],
    ),
  );

  /// Градиент для основных кнопок с улучшенным свечением
  static BoxDecoration get buttonGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [brandBrightGreen, brandLightGreen, successLight],
      stops: const [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: brandBrightGreen.withOpacity(0.7), blurRadius: 24, spreadRadius: 3, offset: const Offset(0, 4)),
      BoxShadow(color: brandLightGreen.withOpacity(0.4), blurRadius: 40, spreadRadius: 6),
      BoxShadow(color: brandBrightGreen.withOpacity(0.2), blurRadius: 60, spreadRadius: 8),
    ],
  );

  /// Градиент для вторичных кнопок
  static BoxDecoration get secondaryButtonGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [brandMediumBlue, brandDarkBlue],
      stops: const [0.0, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: brandBrightGreen.withOpacity(0.3), width: 1.5),
    boxShadow: [BoxShadow(color: brandBrightGreen.withOpacity(0.2), blurRadius: 15, spreadRadius: 1)],
  );

  /// Градиент для карточек с улучшенной глубиной
  static BoxDecoration get cardGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [darkCard, brandMediumBlue, brandDarkBlue],
      stops: const [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: brandBrightGreen.withOpacity(0.15), width: 1),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 4)),
      BoxShadow(color: brandBrightGreen.withOpacity(0.15), blurRadius: 30, spreadRadius: 3),
    ],
  );

  /// Градиент для выделенных карточек
  static BoxDecoration get highlightedCardGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [darkCard, brandMediumBlue.withOpacity(0.8), brandDarkBlue],
      stops: const [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: brandBrightGreen.withOpacity(0.4), width: 2),
    boxShadow: [
      BoxShadow(color: brandBrightGreen.withOpacity(0.3), blurRadius: 25, spreadRadius: 3, offset: const Offset(0, 6)),
      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, spreadRadius: 4),
    ],
  );

  /// Неоновое свечение для текста (интенсивное)
  static List<Shadow> get neonTextShadow => [
    Shadow(color: brandBrightGreen.withOpacity(1.0), blurRadius: 12, offset: const Offset(0, 0)),
    Shadow(color: brandLightGreen.withOpacity(0.8), blurRadius: 24, offset: const Offset(0, 0)),
    Shadow(color: brandBrightGreen.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 0)),
  ];

  /// Зеленое свечение для текста (умеренное)
  static List<Shadow> get greenTextShadow => [
    Shadow(color: brandBrightGreen.withOpacity(0.9), blurRadius: 14, offset: const Offset(0, 0)),
    Shadow(color: brandLightGreen.withOpacity(0.6), blurRadius: 28, offset: const Offset(0, 0)),
  ];

  /// Свечение для заголовков
  static List<Shadow> get titleTextShadow => [
    Shadow(color: brandBrightGreen.withOpacity(0.7), blurRadius: 10, offset: const Offset(0, 2)),
    Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 4)),
  ];

  /// Интенсивное неоновое свечение для важных элементов
  static List<BoxShadow> get neonGlow => [
    BoxShadow(color: brandBrightGreen.withOpacity(0.7), blurRadius: 24, spreadRadius: 3, offset: const Offset(0, 4)),
    BoxShadow(color: brandLightGreen.withOpacity(0.5), blurRadius: 45, spreadRadius: 6),
    BoxShadow(color: brandBrightGreen.withOpacity(0.3), blurRadius: 70, spreadRadius: 10),
  ];

  /// Умеренное зеленое свечение
  static List<BoxShadow> get greenGlow => [
    BoxShadow(color: brandBrightGreen.withOpacity(0.6), blurRadius: 22, spreadRadius: 2, offset: const Offset(0, 2)),
    BoxShadow(color: brandLightGreen.withOpacity(0.4), blurRadius: 42, spreadRadius: 5),
  ];

  /// Синее свечение для фоновых элементов
  static List<BoxShadow> get blueGlow => [
    BoxShadow(color: brandMediumBlue.withOpacity(0.5), blurRadius: 18, spreadRadius: 2, offset: const Offset(0, 2)),
    BoxShadow(color: brandDarkBlue.withOpacity(0.3), blurRadius: 35, spreadRadius: 4),
  ];

  /// Свечение для кнопок
  static List<BoxShadow> get buttonGlow => [
    BoxShadow(color: brandBrightGreen.withOpacity(0.6), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 4)),
    BoxShadow(color: brandLightGreen.withOpacity(0.3), blurRadius: 35, spreadRadius: 4),
  ];

  /// Свечение для карточек
  static List<BoxShadow> get cardGlow => [
    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 25, spreadRadius: 3, offset: const Offset(0, 6)),
    BoxShadow(color: brandBrightGreen.withOpacity(0.15), blurRadius: 40, spreadRadius: 5),
  ];
}
