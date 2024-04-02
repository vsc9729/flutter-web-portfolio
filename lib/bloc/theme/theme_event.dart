part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class ThemeInitialEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {}
