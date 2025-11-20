
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_wm.dart';
import 'package:alien_tap/features/claim/pages/claim_page/claim_i18n.dart';
import 'package:alien_tap/features/claim/pages/claim_page/navigation/claim_navigator.dart';
import 'package:alien_tap/features/tap_game/repositories/tap_repository.dart';
import 'package:alien_tap/app/di/app_scope.dart';

ClaimWidgetModel createClaimWidgetModel(BuildContext context) {
  final repository = locator<TapRepository>();
  final navigator = ClaimNavigator(context);
  final i18n = ClaimI18n();

  return ClaimWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}
