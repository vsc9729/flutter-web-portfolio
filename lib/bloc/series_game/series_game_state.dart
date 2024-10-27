part of 'series_game_bloc.dart';

@immutable
sealed class SeriesGameState {}

final class SeriesGameInitial extends SeriesGameState {}

final class SeriesGameDataLoadingState extends SeriesGameState {}

final class SeriesGameDataReceivedState extends SeriesGameState {
  final int score;
  final int highScore;

  SeriesGameDataReceivedState(this.score, this.highScore);
}

final class SeriesGameAnswerWrongState extends SeriesGameState {}

final class SeriesGameAnswerCorrectState extends SeriesGameState {}
