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

@JS('ensureTelegramMock')
external dynamic ensureTelegramMock();

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
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            // Формируем полный URL для логирования
            final fullUrl = options.uri.toString();
            _logger.d('REQUEST[${options.method}] => URL: $fullUrl');
            if (options.headers.containsKey('Authorization')) {
              _logger.d('  Authorization: Bearer *** (token present)');
            }
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            final url = e.requestOptions.uri.toString();
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

  Options get _authOptions => Options(headers: {'Authorization': 'Bearer ${_token}'});

  Future<void> initialize() async {
    await GetStorage.init();
    // Don't authenticate on init - will happen when making first API call
    // This allows the app to start even if Telegram WebApp is not available (e.g., in dev)

    // Wait for JS to be ready
    await Future.delayed(const Duration(milliseconds: 500));

    // Ensure mock is created (ONLY for development)
    if (kDebugMode && !AppConfig.isProduction) {
      try {
        if (kDebugMode) {
          _logger.d('🔧 Ensuring Telegram mock is created during initialization...');
        }
        ensureTelegramMock();
        if (kDebugMode) {
          _logger.d('✅ ensureTelegramMock() called during init');
        }
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        if (kDebugMode) {
          _logger.w('⚠️ ensureTelegramMock() not available during init: $e (this is OK if running in real Telegram)');
        }
      }
    }

    // Check if initData is available (only in debug mode)
    if (kDebugMode) {
      try {
        final initData = _telegramInitData;
        if (initData != null) {
          _logger.d('✅ Telegram initData is available');

          // Try to get hash to verify data structure
          try {
            final hash = getInitDataProperty('hash');
            if (hash != null && hash.toString().isNotEmpty) {
              _logger.d('✅ Hash is available in initData (length: ${hash.toString().length})');
              final isMock = hash.toString().contains('mock');
              _logger.d('📋 Development mode: ${isMock ? 'Yes (using mock)' : 'No (real Telegram)'}');
            } else {
              _logger.w('⚠️ Hash is missing in initData');
            }
          } catch (e) {
            _logger.w('Could not verify hash: $e');
          }
        } else {
          _logger.w('⚠️ Telegram initData not available (running outside Telegram - should use mock)');
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
    // Strategy: Use getInitDataProperty from JS - it's the most reliable method
    // This function is defined in telegram.js and can properly access JS object properties
    Map<String, dynamic> data = {};

    if (kDebugMode) {
      _logger.d('🔍 Starting authentication...');
    }

    // В продакшене проверяем что мы в Telegram
    if (AppConfig.isProduction) {
      if (!_isRunningInTelegram()) {
        throw Exception('Application must be run inside Telegram WebApp');
      }
    }

    // First, ensure mock is created (ONLY for development)
    if (kDebugMode && !AppConfig.isProduction) {
      try {
        if (kDebugMode) {
          _logger.d('🔧 Ensuring Telegram mock is created...');
        }
        ensureTelegramMock();
        if (kDebugMode) {
          _logger.d('✅ ensureTelegramMock() called');
        }
        // Wait a bit for mock to be created
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        if (kDebugMode) {
          _logger.w('⚠️ ensureTelegramMock() not available: $e (this is OK if running in real Telegram)');
        }
      }
    }

    // First, check if initData exists at all
    try {
      final initDataCheck = _telegramInitData;
      if (kDebugMode) {
        _logger.d(
          '📥 _telegramInitData check: ${initDataCheck != null ? "exists (${initDataCheck.runtimeType})" : "null"}',
        );
      }
      if (initDataCheck == null) {
        if (AppConfig.isProduction) {
          throw Exception('Telegram initData is not available. Application must be run inside Telegram WebApp');
        }
        if (kDebugMode) {
          _logger.w('⚠️ _telegramInitData is null! Will use fallback mock data for development.');
        }
      }
    } catch (e) {
      if (AppConfig.isProduction) {
        rethrow;
      }
      if (kDebugMode) {
        _logger.w('⚠️ Failed to access _telegramInitData: $e');
      }
    }

    // Method 1: Try getInitDataProperty first (most reliable - works from JS)
    try {
      // Get hash (CRITICAL)
      final hash = getInitDataProperty('hash');
      if (kDebugMode) {
        _logger.d('📥 getInitDataProperty("hash") returned: ${hash != null ? "${hash.runtimeType}" : "null"}');
      }

      if (hash != null && hash.toString().isNotEmpty) {
        data['hash'] = hash.toString();
        if (kDebugMode) {
          _logger.d('✅ Got hash via getInitDataProperty (length: ${data['hash'].length})');
        }
      } else {
        if (kDebugMode) {
          _logger.w('⚠️ Hash is null from getInitDataProperty, trying direct access...');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        _logger.w('⚠️ getInitDataProperty("hash") failed: $e');
      }
    }

    // Method 2: Fallback to direct access if getInitDataProperty failed
    if (data['hash'] == null || data['hash'].toString().isEmpty) {
      if (kDebugMode) {
        _logger.w('⚠️ Trying direct access to _telegramInitData...');
      }
      final initData = _telegramInitData;
      if (initData != null) {
        try {
          final hash = (initData as dynamic).hash;
          if (hash != null && hash.toString().isNotEmpty) {
            data['hash'] = hash.toString();
            if (kDebugMode) {
              _logger.d('✅ Got hash via direct access');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            _logger.e('❌ Direct access to hash failed: $e');
          }
        }
      }
    }

    // Get auth_date
    try {
      final authDate = getInitDataProperty('auth_date');
      if (authDate != null) {
        data['auth_date'] = authDate is num ? authDate.toInt() : authDate;
        if (kDebugMode) {
          _logger.d('✅ Got auth_date via getInitDataProperty');
        }
      } else {
        // Fallback to direct access
        try {
          final initData = _telegramInitData;
          if (initData != null) {
            final authDate = (initData as dynamic).auth_date;
            if (authDate != null) {
              data['auth_date'] = authDate is num ? authDate.toInt() : authDate;
              if (kDebugMode) {
                _logger.d('✅ Got auth_date via direct access');
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            _logger.w('⚠️ Failed to get auth_date: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        _logger.w('⚠️ getInitDataProperty("auth_date") failed: $e');
      }
    }

    // Get user
    try {
      final user = getInitDataProperty('user');
      if (user != null) {
        data['user'] = {
          'id': (user as dynamic).id,
          'username': (user as dynamic).username,
          'first_name': (user as dynamic).first_name,
          'last_name': (user as dynamic).last_name,
        };
        if (kDebugMode) {
          _logger.d('✅ Got user via getInitDataProperty');
        }
      } else {
        // Fallback to direct access
        try {
          final initData = _telegramInitData;
          if (initData != null) {
            final user = (initData as dynamic).user;
            if (user != null) {
              data['user'] = {
                'id': (user as dynamic).id,
                'username': (user as dynamic).username,
                'first_name': (user as dynamic).first_name,
                'last_name': (user as dynamic).last_name,
              };
              if (kDebugMode) {
                _logger.d('✅ Got user via direct access');
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            _logger.w('⚠️ Failed to get user: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        _logger.w('⚠️ getInitDataProperty("user") failed: $e');
      }
    }

    // Final validation - hash is required (CRITICAL for security)
    if (data['hash'] == null || data['hash'].toString().isEmpty) {
      // В продакшене НЕ создаём мок данные - это критическая уязвимость!
      if (AppConfig.isProduction) {
        throw Exception('Telegram hash is required for authentication. Application must be run inside Telegram WebApp');
      }
      
      // Только в development режиме создаём мок данные
      if (kDebugMode) {
        _logger.w('⚠️ Hash is missing, creating fallback mock data for development...');
        
        final fallbackHash = 'mock_hash_for_development_fallback_${DateTime.now().millisecondsSinceEpoch}';
        data['hash'] = fallbackHash;

        if (data['auth_date'] == null) {
          data['auth_date'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        }

        if (data['user'] == null) {
          data['user'] = {'id': 1111, 'username': 'dev_user', 'first_name': 'Dev', 'last_name': 'User'};
        }

        _logger.w('✅ Created fallback mock data for development');
        _logger.d('📋 Fallback data: hash length=${data['hash'].toString().length}, auth_date=${data['auth_date']}');
      }
    }

    if (kDebugMode) {
      _logger.d('📤 Final data being sent:');
      _logger.d('  - Keys: ${data.keys.toList()}');
      _logger.d('  - Has user: ${data.containsKey('user')}');
      _logger.d('  - auth_date: ${data['auth_date']}');
      _logger.d('  - hash length: ${data['hash']?.toString().length ?? 0}');
    }

    // Send initData as-is (according to docs: data: initData)
    try {
      final response = await _dio.post('/auth/telegram', data: data);

      final token = response.data['token'] as String;
      final userId = response.data['user_id'] as String?;

      // Save token synchronously (GetStorage.write is synchronous)
      _token = token;
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
      final res = await _dio.get('/game/leaderboard');
      // According to docs, response is a List
      final List<dynamic> data = res.data as List;
      return data.map((json) => json as Map<String, dynamic>).toList();
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
