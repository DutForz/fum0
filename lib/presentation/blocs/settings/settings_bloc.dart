import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required bool initialDarkMode}) : _isDarkMode = initialDarkMode, super(SettingsLoaded(isDarkMode: initialDarkMode)) {
    on<SettingsStarted>(_onStarted);
    on<SettingsThemeToggled>(_onThemeToggled);
  }
  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode;
  void _onStarted(SettingsStarted event, Emitter<SettingsState> emit) { emit(SettingsLoaded(isDarkMode: _isDarkMode)); }
  void _onThemeToggled(SettingsThemeToggled event, Emitter<SettingsState> emit) { _isDarkMode = !_isDarkMode; emit(SettingsLoaded(isDarkMode: _isDarkMode)); }
}
