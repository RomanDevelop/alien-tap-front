// lib/features/profile/pages/profile_page/profile_wm.dart
import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'profile_i18n.dart';
import 'navigation/profile_navigator.dart';
import '../../repositories/profile_repository.dart';

class ProfileWidgetModel extends WidgetModel {
  final ProfileRepository _repository;
  final ProfileNavigator _navigator;
  final ProfileI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<Map<String, dynamic>> _userProfile = BehaviorSubject.seeded({});
  Stream<Map<String, dynamic>> get userProfileStream => _userProfile.stream;

  final BehaviorSubject<List<Map<String, dynamic>>> _operationsHistory = BehaviorSubject.seeded([]);
  Stream<List<Map<String, dynamic>>> get operationsHistoryStream => _operationsHistory.stream;

  final BehaviorSubject<String?> _referralLink = BehaviorSubject.seeded(null);
  Stream<String?> get referralLinkStream => _referralLink.stream;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  ProfileWidgetModel(
    this._repository,
    this._navigator,
    this.i18n,
    WidgetModelDependencies dependencies,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadProfile();
    _loadOperationsHistory();
  }

  @override
  void dispose() {
    _userProfile.close();
    _operationsHistory.close();
    _referralLink.close();
    _isLoading.close();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    _isLoading.add(true);
    try {
      final profile = await _repository.getUserProfile();
      _userProfile.add(profile);
    } catch (e) {
      _logger.e('Failed to load profile', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> _loadOperationsHistory() async {
    try {
      final history = await _repository.getOperationsHistory();
      _operationsHistory.add(history);
    } catch (e) {
      _logger.e('Failed to load operations history', error: e);
    }
  }

  Future<void> generateReferralLink() async {
    _isLoading.add(true);
    try {
      final link = await _repository.generateReferralLink();
      _referralLink.add(link);
      _logger.d('Referral link generated: $link');
    } catch (e) {
      _logger.e('Failed to generate referral link', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> copyReferralLink() async {
    final link = _referralLink.value;
    if (link != null) {
      await Clipboard.setData(ClipboardData(text: link));
      _logger.d('Referral link copied to clipboard');
    }
  }

  Future<void> logout() async {
    try {
      _logger.d('Logging out from profile...');
      // Очищаем токен через репозиторий
      await _repository.logout();
      _logger.d('Logout successful, redirecting to auth');
      // Переходим на экран авторизации
      _navigator.logout();
    } catch (e) {
      _logger.e('Logout failed', error: e);
      // Даже если logout не удался, пытаемся перейти на экран авторизации
      _navigator.logout();
    }
  }

  void goBack() => _navigator.goBack();
}

