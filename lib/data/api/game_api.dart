// lib/data/api/game_api.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:js/js.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:alien_tap/config/app_config.dart';

@JS('Telegram.WebApp.initDataUnsafe')
external dynamic get _telegramInitData;

@JS('Telegram.WebApp.getInitDataJSON')
external String? getInitDataJSON();

@JS('Telegram.WebApp.getInitDataProperty')
external dynamic getInitDataProperty(String key);

@JS('Telegram.WebApp.getInitData')
external String? getInitDataString();

@JS('Telegram.WebApp.parseInitDataUser')
external String? parseInitDataUser();

@JS('Telegram.WebApp.diagnose')
external dynamic diagnoseTelegramWebApp();

// Direct console.log for guaranteed logging in production
@JS('console.log')
external void jsConsoleLog(String message);

@JS('console.warn')
external void jsConsoleWarn(String message);

@JS('console.error')
external void jsConsoleError(String message);

// ensureTelegramMock removed for production - only real Telegram data is used

// Alternative: Get initData via JS function if available
@JS('JSON.parse')
external dynamic parseJSON(String json);

class GameApi {
  final Dio _dio;
  final GetStorage _storage = GetStorage();
  final Logger _logger = Logger();

  GameApi(String baseUrl)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
            // Убираем предупреждение ngrok (только для разработки)
            if (kDebugMode) 'ngrok-skip-browser-warning': 'true',
          },
        ),
      ) {
    // Log API base URL for debugging
    print('🔧 GameApi initialized with baseUrl: $baseUrl');
    try {
      jsConsoleLog('🔧 GameApi initialized with baseUrl: $baseUrl');
    } catch (e) {
      // JS not available yet, ignore
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Always log requests (not just in debug mode) for production debugging
          final fullUrl = options.uri.toString();
          print('📡 REQUEST[${options.method}] => $fullUrl');
          try {
            jsConsoleLog('📡 REQUEST[${options.method}] => $fullUrl');
          } catch (e) {
            // JS not available, ignore
          }
          
          // Log Authorization header status (always, not just in debug mode)
          if (options.headers.containsKey('Authorization')) {
            final authHeader = options.headers['Authorization'] as String?;
            if (authHeader != null && authHeader.isNotEmpty) {
              print('   ✅ Authorization header present (length: ${authHeader.length})');
              try {
                jsConsoleLog('   ✅ Authorization header present (length: ${authHeader.length})');
              } catch (e) {
                // JS not available, ignore
              }
            } else {
              print('   ⚠️ Authorization header is empty');
              try {
                jsConsoleWarn('   ⚠️ Authorization header is empty');
              } catch (e) {
                // JS not available, ignore
              }
            }
          } else {
            print('   ⚠️ Authorization header missing');
            try {
              jsConsoleWarn('   ⚠️ Authorization header missing');
            } catch (e) {
              // JS not available, ignore
            }
          }
          
          if (kDebugMode) {
            // Формируем полный URL для логирования
            _logger.d('REQUEST[${options.method}] => URL: $fullUrl');
            if (options.headers.containsKey('Authorization')) {
              _logger.d('  Authorization: Bearer *** (token present)');
            }

            // Логируем тело запроса для /auth/telegram
            if (options.path == '/auth/telegram' && options.data != null) {
              try {
                final requestData = options.data as Map<String, dynamic>?;
                if (requestData != null) {
                  _logger.d('📤 REQUEST BODY (before serialization):');
                  _logger.d('  - Keys: ${requestData.keys.toList()}');
                  _logger.d('  - Has user: ${requestData.containsKey('user')}');
                  if (requestData.containsKey('user')) {
                    final user = requestData['user'];
                    _logger.d('  - user type: ${user.runtimeType}');
                    if (user is Map) {
                      _logger.d('  - user.id: ${user['id']}');
                      _logger.d('  - user.username: ${user['username']}');
                    } else {
                      _logger.w('  - user is not a Map! user: $user');
                    }
                  } else {
                    _logger.e('  - ❌ USER IS MISSING IN REQUEST BODY!');
                  }
                  _logger.d('  - hash: ${requestData['hash']?.toString().substring(0, 20)}...');
                  _logger.d('  - auth_date: ${requestData['auth_date']}');
                } else {
                  _logger.w('  - Request data is null');
                }
              } catch (e) {
                _logger.w('  - Could not log request body: $e');
              }
            }
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          // Always log errors for production debugging
          final url = e.requestOptions.uri.toString();
          print('❌ ERROR[${e.response?.statusCode ?? 'NO_RESPONSE'}] => $url');
          try {
            jsConsoleError('❌ ERROR[${e.response?.statusCode ?? 'NO_RESPONSE'}] => $url');
            if (e.response != null) {
              jsConsoleError('   Response: ${e.response!.data}');
            } else {
              jsConsoleError('   Error: ${e.message}');
            }
          } catch (jsError) {
            // JS not available, ignore
          }
          if (e.response != null) {
            print('   Response: ${e.response!.data}');
          } else {
            print('   Error: ${e.message}');
          }
          
          if (kDebugMode) {
            _logger.e('ERROR[${e.response?.statusCode}] => URL: $url');
            _logger.e('  Message: ${e.message}');
            if (e.response != null) {
              _logger.e('  Response: ${e.response!.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  String? get _token => _storage.read<String>('jwt_token');

  set _token(String? t) => t == null ? _storage.remove('jwt_token') : _storage.write('jwt_token', t);

  Options get _authOptions {
    final token = _token;
    if (token == null || token.isEmpty) {
      print('⚠️ _authOptions: token is null or empty!');
      try {
        jsConsoleWarn('⚠️ _authOptions: token is null or empty!');
      } catch (e) {
        // JS not available, ignore
      }
      // Return empty options if no token (will cause 401, but at least request will be sent)
      return Options();
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<void> initialize() async {
    await GetStorage.init();
    // Wait for JS to be ready
    await Future.delayed(const Duration(milliseconds: 500));

    // In production, verify that we're running in Telegram
    if (AppConfig.isProduction) {
      if (!_isRunningInTelegram()) {
        throw Exception('Application must be run inside Telegram WebApp. Telegram initData is not available.');
      }
    }

    // Check if initData is available (only in debug mode)
    if (kDebugMode) {
      try {
        final initData = _telegramInitData;
        if (initData != null) {
          _logger.d('✅ Telegram initData is available');
          try {
            final hash = getInitDataProperty('hash');
            if (hash != null && hash.toString().isNotEmpty) {
              _logger.d('✅ Hash is available in initData (length: ${hash.toString().length})');
            } else {
              _logger.w('⚠️ Hash is missing in initData');
            }
          } catch (e) {
            _logger.w('Could not verify hash: $e');
          }
        } else {
          if (AppConfig.isProduction) {
            _logger.e('❌ Telegram initData not available in production!');
          } else {
            _logger.w('⚠️ Telegram initData not available (development mode)');
          }
        }
      } catch (e) {
        _logger.w('Could not check Telegram initData: $e');
      }
    }
  }

  /// Проверяет, что приложение запущено в Telegram WebApp
  /// В продакшене это критично для безопасности
  bool _isRunningInTelegram() {
    try {
      final initData = _telegramInitData;
      if (initData == null) return false;

      final hash = getInitDataProperty('hash');
      if (hash == null || hash.toString().isEmpty) return false;

      final hashStr = hash.toString();
      // В продакшене не должно быть моковых хешей
      if (AppConfig.isProduction && hashStr.contains('mock')) {
        return false;
      }

      // Реальный хеш от Telegram обычно длиннее 40 символов и является hex строкой
      if (AppConfig.isProduction) {
        // Проверяем что это не мок
        if (hashStr.length < 40 || hashStr.startsWith('mock_')) {
          return false;
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        _logger.w('Error checking Telegram environment: $e');
      }
      return false;
    }
  }

  Future<String> authenticate() async {
    // ✅ ПРАВИЛЬНАЯ РЕАЛИЗАЦИЯ: Отправляем только оригинальную строку initData
    // Согласно документации: https://core.telegram.org/bots/webapps#validating-data-received
    // Бэкенд должен получить оригинальную строку initData для проверки подписи
    
    print('🔍 GameApi.authenticate() called');
    try {
      jsConsoleLog('🔍 GameApi.authenticate() called');
    } catch (e) {
      // JS not available, ignore
    }
    if (kDebugMode) {
      _logger.d('🔍 Starting authentication...');
    }

    // В продакшене проверяем что мы в Telegram
    if (AppConfig.isProduction) {
      if (!_isRunningInTelegram()) {
        throw Exception('Application must be run inside Telegram WebApp. Telegram initData is not available.');
      }
    }

    // ✅ Получаем оригинальную строку initData (НЕ парсим её!)
    final initDataString = getInitDataString();
    if (initDataString == null || initDataString.isEmpty) {
      throw Exception('Telegram initData string is required for authentication. Application must be run inside Telegram WebApp');
    }

    if (kDebugMode) {
      _logger.d('✅ Got initData string (length: ${initDataString.length})');
      _logger.d('   - Preview: ${initDataString.length > 100 ? initDataString.substring(0, 100) + "..." : initDataString}');
      _logger.d('   - Contains hash: ${initDataString.contains('hash=')}');
      _logger.d('   - Contains user: ${initDataString.contains('user=')}');
      _logger.d('   - Contains auth_date: ${initDataString.contains('auth_date=')}');
    }

    print('✅ Got initData string (length: ${initDataString.length})');
    try {
      jsConsoleLog('✅ Got initData string (length: ${initDataString.length})');
    } catch (e) {
      // JS not available, ignore
    }

    // ✅ Отправляем ТОЛЬКО оригинальную строку initData
    // Бэкенд сам парсит её и проверяет подпись
    try {
      if (kDebugMode) {
        _logger.d('🚀 Sending POST request to /auth/telegram...');
        _logger.d('   - Sending ONLY initData string (as per Telegram documentation)');
        _logger.d('   - initData string length: ${initDataString.length}');
      }

      // ✅ ПРАВИЛЬНО: Отправляем только initData как строку
      final requestData = {
        'initData': initDataString, // ✅ Только оригинальная строка!
      };

      if (kDebugMode) {
        _logger.d('📋 Request data:');
        _logger.d('   - Keys: ${requestData.keys.toList()}');
        _logger.d('   - initData string length: ${initDataString.length}');
        _logger.d('   - initData preview: ${initDataString.length > 100 ? initDataString.substring(0, 100) + "..." : initDataString}');
      }

      // Log full URL before sending
      final fullUrl = '${_dio.options.baseUrl}/auth/telegram';
      print('📤 Sending authentication request to: $fullUrl');
      print('   - Sending ONLY initData string (as per Telegram documentation)');
      print('   - initData length: ${initDataString.length}');
      try {
        jsConsoleLog('📤 Sending authentication request to: $fullUrl');
        jsConsoleLog('   - Base URL: ${_dio.options.baseUrl}');
        jsConsoleLog('   - Data keys: ${requestData.keys.toList()}');
        jsConsoleLog('   - initData string length: ${initDataString.length}');
        jsConsoleLog('   - initData preview: ${initDataString.length > 100 ? initDataString.substring(0, 100) + "..." : initDataString}');
      } catch (e) {
        // JS not available, ignore
      }
      final response = await _dio.post('/auth/telegram', data: requestData);
      print('📥 Received response: status=${response.statusCode}');
      try {
        jsConsoleLog('📥 Received response: status=${response.statusCode}');
      } catch (e) {
        // JS not available, ignore
      }

      final token = response.data['token'] as String;
      final userId = response.data['user_id'] as String?;

      print('✅ Token received from backend (length: ${token.length})');
      try {
        jsConsoleLog('✅ Token received from backend (length: ${token.length})');
      } catch (e) {
        // JS not available, ignore
      }
      
      // Save token synchronously (GetStorage.write is synchronous)
      _token = token;
      print('💾 Token saved to storage');
      try {
        jsConsoleLog('💾 Token saved to storage');
      } catch (e) {
        // JS not available, ignore
      }
      if (kDebugMode) {
        _logger.d('✅ Token saved (length: ${token.length})');
      }

      // Verify token was saved
      final savedToken = _token;
      if (savedToken == null || savedToken != token) {
        _logger.e('❌ CRITICAL: Token was not saved correctly!');
        throw Exception('Failed to save authentication token');
      } else {
        if (kDebugMode) {
          _logger.d('✅ Token verification: saved correctly');
        }
      }

      if (userId != null) {
        _storage.write('user_id', userId);
      }

      if (kDebugMode) {
        _logger.d('Authentication successful, token received');
      }
      return token;
    } on DioException catch (e) {
      if (kDebugMode) {
        _logger.e('Authentication failed: ${e.response?.statusCode} - ${e.response?.data}');
      }
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final errorData = e.response!.data;
        throw Exception('Auth failed: $statusCode${errorData != null ? ' - $errorData' : ''}');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Unexpected error during authentication: $e');
      }
      rethrow;
    }
  }

  Future<int> updateScore(int score) async {
    try {
      final res = await _dio.post('/game/update_score', data: {'score': score}, options: _authOptions);
      return res.data['score'] as int;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        if (kDebugMode) {
          _logger.w('401 Unauthorized, attempting re-authentication...');
        }
        try {
          await authenticate();
          // Retry the request once
          final res = await _dio.post('/game/update_score', data: {'score': score}, options: _authOptions);
          return res.data['score'] as int;
        } catch (authError) {
          if (kDebugMode) {
            _logger.e('Re-authentication failed: $authError');
          }
          rethrow;
        }
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    try {
      final res = await _dio.get('/game/leaderboard', options: _authOptions);
      // According to docs, response is a List
      final List<dynamic> data = res.data as List;
      return data.map((json) => json as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        if (kDebugMode) {
          _logger.w('401 Unauthorized on leaderboard, attempting re-authentication...');
        }
        try {
          await authenticate();
          // Retry the request once
          final res = await _dio.get('/game/leaderboard', options: _authOptions);
          final List<dynamic> data = res.data as List;
          return data.map((json) => json as Map<String, dynamic>).toList();
        } catch (authError) {
          if (kDebugMode) {
            _logger.e('Re-authentication failed: $authError');
          }
          rethrow;
        }
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Failed to get leaderboard: $e');
      }
      rethrow;
    }
  }

  Future<String> startClaim(double amount) async {
    try {
      final res = await _dio.post('/claim/start', data: {'amount': amount}, options: _authOptions);
      return res.data['claim_id'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        if (kDebugMode) {
          _logger.w('401 Unauthorized, attempting re-authentication...');
        }
        try {
          await authenticate();
          final res = await _dio.post('/claim/start', data: {'amount': amount}, options: _authOptions);
          return res.data['claim_id'] as String;
        } catch (authError) {
          if (kDebugMode) {
            _logger.e('Re-authentication failed: $authError');
          }
          rethrow;
        }
      }
      if (kDebugMode) {
        _logger.e('Failed to start claim: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> confirmClaim(String claimId) async {
    try {
      await _dio.post('/claim/confirm', data: {'claim_id': claimId}, options: _authOptions);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        if (kDebugMode) {
          _logger.w('401 Unauthorized, attempting re-authentication...');
        }
        try {
          await authenticate();
          await _dio.post('/claim/confirm', data: {'claim_id': claimId}, options: _authOptions);
        } catch (authError) {
          if (kDebugMode) {
            _logger.e('Re-authentication failed: $authError');
          }
          rethrow;
        }
      } else {
        if (kDebugMode) {
          _logger.e('Failed to confirm claim: ${e.response?.data}');
        }
        rethrow;
      }
    }
  }

  Future<void> logout() async {
    _token = null;
    _storage.remove('jwt_token');
    _storage.remove('user_id');
  }
}
