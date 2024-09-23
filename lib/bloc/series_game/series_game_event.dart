part of 'series_game_bloc.dart';

@immutable
sealed class SeriesGameEvent {}

class SeriesGameGetDataEvent extends SeriesGameEvent {}

class SeriesGameGetMoreDataEvent extends SeriesGameEvent {}

class SeriesGameRestartGameEvent extends SeriesGameEvent {}

class SeriesGameAnswerEvent extends SeriesGameEvent {
  final AnswerResponse response;
  final int index;

  SeriesGameAnswerEvent({
    required this.response,
    required this.index,
  });
}
