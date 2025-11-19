// lib/features/trading/pages/trading_page/trading_wm.dart
import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'trading_i18n.dart';
import 'navigation/trading_navigator.dart';
import '../../repositories/trading_repository.dart';
import '../../models/asset.dart';
import '../../models/trading_position.dart';

class TradingWidgetModel extends WidgetModel {
  final TradingRepository _repository;
  final TradingNavigator _navigator;
  final TradingI18n i18n;
  final Logger _logger = Logger();

  // Торговый баланс (мок данные)
  final BehaviorSubject<double> _tradingBalance = BehaviorSubject.seeded(10000.0);
  Stream<double> get tradingBalanceStream => _tradingBalance.stream;
  double get tradingBalance => _tradingBalance.value;

  // Текущий актив
  final BehaviorSubject<Asset?> _selectedAsset = BehaviorSubject.seeded(null);
  Stream<Asset?> get selectedAssetStream => _selectedAsset.stream;

  // Открытые позиции
  final BehaviorSubject<List<TradingPosition>> _positions = BehaviorSubject.seeded([]);
  Stream<List<TradingPosition>> get positionsStream => _positions.stream;

  // Сумма инвестирования
  final BehaviorSubject<double> _investAmount = BehaviorSubject.seeded(100.0);
  Stream<double> get investAmountStream => _investAmount.stream;

  // Загрузка
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  TradingWidgetModel(
    this._repository,
    this._navigator,
    this.i18n,
    WidgetModelDependencies dependencies,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadPositions();
  }

  @override
  void dispose() {
    _tradingBalance.close();
    _selectedAsset.close();
    _positions.close();
    _investAmount.close();
    _isLoading.close();
    super.dispose();
  }

  Future<void> searchAsset(String ticker) async {
    if (ticker.isEmpty) {
      _selectedAsset.add(null);
      return;
    }

    _isLoading.add(true);
    try {
      final asset = await _repository.searchAsset(ticker);
      _selectedAsset.add(asset);
      if (asset == null) {
        _logger.w('Asset not found: $ticker');
      }
    } catch (e) {
      _logger.e('Failed to search asset', error: e);
      _selectedAsset.add(null);
    } finally {
      _isLoading.add(false);
    }
  }

  void setInvestAmount(double amount) {
    if (amount > tradingBalance) {
      amount = tradingBalance;
    }
    if (amount < 0) {
      amount = 0;
    }
    _investAmount.add(amount);
  }

  void addToInvestAmount(double add) {
    setInvestAmount(_investAmount.value + add);
  }

  void setMaxInvestAmount() {
    setInvestAmount(tradingBalance);
  }

  Future<void> buyAsset() async {
    final asset = _selectedAsset.value;
    if (asset == null) return;

    final amount = _investAmount.value;
    if (amount <= 0 || amount > tradingBalance) return;

    _isLoading.add(true);
    try {
      await _repository.buyAsset(asset.ticker, amount);
      _tradingBalance.add(tradingBalance - amount);
      _investAmount.add(100.0);
      await _loadPositions();
      _logger.d('Bought ${asset.ticker} for $amount ALEN');
    } catch (e) {
      _logger.e('Failed to buy asset', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> closePosition(String positionId) async {
    _isLoading.add(true);
    try {
      await _repository.closePosition(positionId);
      final position = _positions.value.firstWhere((p) => p.id == positionId);
      _tradingBalance.add(tradingBalance + position.entryPrice * position.quantity + position.pnl);
      await _loadPositions();
      _logger.d('Closed position: $positionId');
    } catch (e) {
      _logger.e('Failed to close position', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> _loadPositions() async {
    try {
      final positions = await _repository.getOpenPositions();
      _positions.add(positions);
    } catch (e) {
      _logger.e('Failed to load positions', error: e);
    }
  }

  void goBack() => _navigator.goBack();
}

