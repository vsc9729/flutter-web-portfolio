import 'package:portfolio/imports.dart';

part 'series_game_event.dart';
part 'series_game_state.dart';

enum AnswerResponse { unanswered, correct, wrong, initial }

class SeriesGameBloc extends Bloc<SeriesGameEvent, SeriesGameState> {
  SeriesGameBloc() : super(SeriesGameInitial()) {
    on<SeriesGameGetDataEvent>(_handleSeriesGameGetData);
    on<SeriesGameAnswerEvent>(_handleSeriesGameAnswerEvent);
    on<SeriesGameRestartGameEvent>(_handleSeriesGameRestartGameEvent);
  }
  SeriesRepo seriesRepo = SeriesRepo();
  List<ShowData> seriesList = [];
  int score = 0;
  int? highScore;
  late List<ValueNotifier<AnswerResponse>> isAnswered;
  FutureOr<void> _handleSeriesGameGetData(
    SeriesGameGetDataEvent event,
    Emitter<SeriesGameState> emit,
  ) async {
    if (seriesList.isEmpty) {
      emit(SeriesGameDataLoadingState());
    }
    highScore ??= seriesRepo.getHighScore();
    List<ShowData>? newSeries = await seriesRepo.getSeries();
    if (seriesList.isEmpty) {
      seriesList = newSeries!;
      isAnswered = List.generate(seriesList.length, (index) {
        if (index == 0) {
          return ValueNotifier(AnswerResponse.initial);
        }
        return ValueNotifier(AnswerResponse.unanswered);
      });
      emit(SeriesGameDataReceivedState(score, highScore!));
    } else {
      seriesList.addAll((newSeries ?? []));
      emit(SeriesGameDataReceivedState(score, highScore!));
    }
  }

  FutureOr<void> _handleSeriesGameAnswerEvent(
    SeriesGameAnswerEvent event,
    Emitter<SeriesGameState> emit,
  ) async {
    if (event.response == AnswerResponse.correct) {
      isAnswered[event.index].value = AnswerResponse.correct;
      score++;
      if (score > highScore!) {
        highScore = score;
        await seriesRepo.setHighScore(highScore!);
      }

      emit(SeriesGameDataReceivedState(score, highScore!));
    } else {
      isAnswered[event.index].value = AnswerResponse.wrong;
    }
  }

  FutureOr<void> _handleSeriesGameRestartGameEvent(
    SeriesGameRestartGameEvent event,
    Emitter<SeriesGameState> emit,
  ) {
    score = 0;
    seriesList.shuffle();
    isAnswered = List.generate(seriesList.length, (index) {
      if (index == 0) {
        return ValueNotifier(AnswerResponse.initial);
      }
      return ValueNotifier(AnswerResponse.unanswered);
    });
    emit(SeriesGameInitial());
  }
}
