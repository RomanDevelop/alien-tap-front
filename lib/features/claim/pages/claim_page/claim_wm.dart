import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_i18n.dart';
import 'package:alien_tap/features/claim/pages/claim_page/navigation/claim_navigator.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_state.dart';
import 'package:logger/logger.dart';

class ClaimWidgetModel extends WidgetModel {
  final TapRepository _repository;
  final ClaimNavigator _navigator;
  final ClaimI18n i18n;
  final Logger _logger = Logger();

  final BehaviorSubject<ClaimState> _state = BehaviorSubject.seeded(ClaimState.input);
  Stream<ClaimState> get stateStream => _state.stream;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;

  final BehaviorSubject<Map<String, dynamic>> _claimInfo = BehaviorSubject.seeded({});
  Stream<Map<String, dynamic>> get claimInfoStream => _claimInfo.stream;

  final BehaviorSubject<int> _currentScore = BehaviorSubject.seeded(0);
  Stream<int> get currentScoreStream => _currentScore.stream;

  String? _claimId;

  ClaimWidgetModel(this._repository, this._navigator, this.i18n, WidgetModelDependencies dependencies)
    : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    _loadCurrentScore();
  }

  Future<void> _loadCurrentScore() async {
    _currentScore.add(0);
  }

  Future<void> startClaim(double amount, String walletAddress) async {
    if (_isLoading.value == true) return;

    if (walletAddress.isEmpty || !walletAddress.startsWith('0x') || walletAddress.length < 40) {
      _navigator.showError(i18n.invalidWalletAddress);
      return;
    }

    _isLoading.add(true);
    try {
      final claimId = await _repository.startClaim(amount);
      _claimId = claimId;
      _claimInfo.add({'amount': amount, 'claim_id': claimId, 'wallet_address': walletAddress});
      _state.add(ClaimState.confirmation);
      _logger.d('Claim started: $claimId for wallet: $walletAddress');
    } catch (e) {
      _logger.e('Failed to start claim', error: e);
      _navigator.showError(e.toString());
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> confirmClaim() async {
    if (_isLoading.value == true || _claimId == null) return;

    _isLoading.add(true);
    try {
      await _repository.confirmClaim(_claimId!);
      _state.add(ClaimState.success);
      _logger.d('Claim confirmed: $_claimId');
    } catch (e) {
      _logger.e('Failed to confirm claim', error: e);
      _navigator.showError(e.toString());
    } finally {
      _isLoading.add(false);
    }
  }

  void cancel() {
    _state.add(ClaimState.input);
    _claimInfo.add({});
    _claimId = null;
  }

  void goBack() {
    _navigator.goBack();
  }

  @override
  void dispose() {
    _state.close();
    _isLoading.close();
    _claimInfo.close();
    _currentScore.close();
    super.dispose();
  }
}
