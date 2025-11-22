import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'wallet_i18n.dart';
import 'navigation/wallet_navigator.dart';
import '../../repositories/wallet_repository.dart';

class WalletWidgetModel extends WidgetModel {
  final WalletRepository _repository;
  final WalletNavigator _navigator;
  final WalletI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<Map<String, dynamic>> _balance = BehaviorSubject.seeded({
    'total': 0.0,
    'available': 0.0,
    'locked': 0.0,
  });
  Stream<Map<String, dynamic>> get balanceStream => _balance.stream;

  final BehaviorSubject<List<Map<String, dynamic>>> _transactions = BehaviorSubject.seeded([]);
  Stream<List<Map<String, dynamic>>> get transactionsStream => _transactions.stream;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  WalletWidgetModel(this._repository, this._navigator, this.i18n, WidgetModelDependencies dependencies)
    : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadBalance();
    _loadTransactions();
  }

  @override
  void dispose() {
    _balance.close();
    _transactions.close();
    _isLoading.close();
    super.dispose();
  }

  Future<void> _loadBalance() async {
    _isLoading.add(true);
    try {
      final balance = await _repository.getWalletBalance();
      _balance.add(balance);
    } catch (e) {
      _logger.e('Failed to load balance', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> _loadTransactions() async {
    try {
      final transactions = await _repository.getTransactionHistory();
      _transactions.add(transactions);
    } catch (e) {
      _logger.e('Failed to load transactions', error: e);
    }
  }

  void goBack() => _navigator.goBack();
}
