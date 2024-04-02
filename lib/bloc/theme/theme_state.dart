part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}

final class LightTheme extends ThemeState {}

final class DarkTheme extends ThemeState {}
