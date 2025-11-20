
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import '../profile_wm.dart';
import '../profile_i18n.dart';
import '../navigation/profile_navigator.dart';
import '../../../../profile/repositories/profile_repository.dart';

ProfileWidgetModel createProfileWidgetModel(BuildContext context) {
  final i18n = ProfileI18n();
  final navigator = ProfileNavigator(context);
  final repository = ProfileRepository();
  return ProfileWidgetModel(repository, navigator, i18n, WidgetModelDependencies());
}

