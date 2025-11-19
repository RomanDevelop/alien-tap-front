// lib/features/liquidity/pages/liquidity_page/liquidity_wm.dart
import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'liquidity_i18n.dart';
import 'navigation/liquidity_navigator.dart';
import '../../repositories/liquidity_repository.dart';

class LiquidityWidgetModel extends WidgetModel {
  final LiquidityRepository _repository;
  final LiquidityNavigator _navigator;
  final LiquidityI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<Map<String, dynamic>> _poolInfo = BehaviorSubject.seeded({
    'lpBalance': 0.0,
    'rewards24h': 0.0,
    'totalTvl': 0.0,
    'apr': 0.0,
    'lpTokens': 0.0,
    'accumulatedProfit': 0.0,
  });
  Stream<Map<String, dynamic>> get poolInfoStream => _poolInfo.stream;

  final BehaviorSubject<double> _investAmount = BehaviorSubject.seeded(100.0);
  Stream<double> get investAmountStream => _investAmount.stream;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  LiquidityWidgetModel(
    this._repository,
    this._navigator,
    this.i18n,
    WidgetModelDependencies dependencies,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadPoolInfo();
  }

  @override
  void dispose() {
    _poolInfo.close();
    _investAmount.close();
    _isLoading.close();
    super.dispose();
  }

  Future<void> _loadPoolInfo() async {
    _isLoading.add(true);
    try {
      final info = await _repository.getPoolInfo();
      _poolInfo.add(info);
    } catch (e) {
      _logger.e('Failed to load pool info', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  void setInvestAmount(double amount) {
    if (amount < 0) amount = 0;
    _investAmount.add(amount);
  }

  void addToInvestAmount(double add) {
    setInvestAmount(_investAmount.value + add);
  }

  void setMaxInvestAmount() {
    // Мок: максимальная сумма = 10000 ALEN
    setInvestAmount(10000.0);
  }

  double calculatePollNeeded(double alenAmount) {
    // Мок: соотношение 1:1
    return alenAmount;
  }

  double calculateShare(double alenAmount) {
    final tvl = _poolInfo.value['totalTvl'] as double;
    if (tvl == 0) return 0;
    return (alenAmount / tvl) * 100;
  }

  Future<void> addLiquidity() async {
    final amount = _investAmount.value;
    if (amount <= 0) return;

    _isLoading.add(true);
    try {
      await _repository.addLiquidity(amount);
      await _loadPoolInfo();
      _investAmount.add(100.0);
      _logger.d('Added liquidity: $amount ALEN');
    } catch (e) {
      _logger.e('Failed to add liquidity', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> removeLiquidity() async {
    final lpTokens = _poolInfo.value['lpTokens'] as double;
    if (lpTokens <= 0) return;

    _isLoading.add(true);
    try {
      await _repository.removeLiquidity(lpTokens);
      await _loadPoolInfo();
      _logger.d('Removed liquidity');
    } catch (e) {
      _logger.e('Failed to remove liquidity', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  void goBack() => _navigator.goBack();
}

