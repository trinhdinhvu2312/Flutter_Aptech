import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/bloc/models/app_config.dart';

class AppConfigCubit extends Cubit<AppConfig> {
  AppConfigCubit() : super(AppConfig(
      settings: {
        'theme': 'dark',
        'notifications': {'enabled': true, 'sound': true}
      },
      selectedTabIndex: 0
  ));

  void updateTheme(String theme) {
    final newSettings = Map<String, dynamic>.from(state.settings);
    newSettings['theme'] = theme;
    emit(state.copyWith(settings: newSettings));
  }

  void updateNotifications(bool enabled, bool sound) {
    final newSettings = Map<String, dynamic>.from(state.settings);
    newSettings['notifications'] = {'enabled': enabled, 'sound': sound};
    emit(state.copyWith(settings: newSettings));
  }

  void updateSelectedTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}
