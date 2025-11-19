// lib/features/portfolio/pages/portfolio_page/portfolio_wm.dart
import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'portfolio_i18n.dart';
import 'navigation/portfolio_navigator.dart';
import '../../repositories/portfolio_repository.dart';
import '../../models/portfolio_history.dart';
import '../../../trading/models/trading_position.dart';

class PortfolioWidgetModel extends WidgetModel {
  final PortfolioRepository _repository;
  final PortfolioNavigator _navigator;
  final PortfolioI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<int> _selectedTab = BehaviorSubject.seeded(0);
  Stream<int> get selectedTabStream => _selectedTab.stream;

  final BehaviorSubject<List<TradingPosition>> _positions = BehaviorSubject.seeded([]);
  Stream<List<TradingPosition>> get positionsStream => _positions.stream;

  final BehaviorSubject<List<PortfolioHistory>> _history = BehaviorSubject.seeded([]);
  Stream<List<PortfolioHistory>> get historyStream => _history.stream;

  final BehaviorSubject<Map<String, double>> _earnings = BehaviorSubject.seeded({
    'week': 0.0,
    'month': 0.0,
    'allTime': 0.0,
  });
  Stream<Map<String, double>> get earningsStream => _earnings.stream;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  PortfolioWidgetModel(
    this._repository,
    this._navigator,
    this.i18n,
    WidgetModelDependencies dependencies,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadData();
  }

  @override
  void dispose() {
    _selectedTab.close();
    _positions.close();
    _history.close();
    _earnings.close();
    _isLoading.close();
    super.dispose();
  }

  void selectTab(int index) {
    _selectedTab.add(index);
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading.add(true);
    try {
      final tab = _selectedTab.value;
      if (tab == 0) {
        final positions = await _repository.getOpenPositions();
        _positions.add(positions);
      } else if (tab == 1) {
        final history = await _repository.getHistory();
        _history.add(history);
      } else if (tab == 2) {
        final earnings = await _repository.getEarnings();
        _earnings.add(earnings);
      }
    } catch (e) {
      _logger.e('Failed to load portfolio data', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  void goBack() => _navigator.goBack();
}

