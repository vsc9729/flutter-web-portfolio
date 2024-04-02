import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeInitialEvent>(_handleThemeInitialEvent);
    on<ChangeThemeEvent>(_handleChangeThemeEvent);
  }

  FutureOr<void> _handleThemeInitialEvent(
    ThemeInitialEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(LightTheme());
  }

  FutureOr<void> _handleChangeThemeEvent(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    if (state is LightTheme || state is ThemeInitial) {
      emit(DarkTheme());
    } else {
      emit(LightTheme());
    }
  }
}
