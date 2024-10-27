import 'package:portfolio/imports.dart';

class HighLowGameMainScreen extends StatefulWidget {
  const HighLowGameMainScreen({super.key});

  @override
  State<HighLowGameMainScreen> createState() => _HighLowGameMainScreenState();
}

class _HighLowGameMainScreenState extends State<HighLowGameMainScreen>
    with SingleTickerProviderStateMixin {
  late final PageController highLowGamePageController;
  late SeriesGameBloc seriesGameBloc;
  late AnimationController animationController;

  ValueNotifier<double> vsOpacity = ValueNotifier(1);

  @override
  initState() {
    highLowGamePageController = PageController(
      initialPage: 0,
      viewportFraction: 1 / 2,
    );
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    );
    animationController.addListener(() {
      if (vsOpacity.value < animationController.value) {
        vsOpacity.value = animationController.value;
      }
    });
    seriesGameBloc = BlocProvider.of<SeriesGameBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SeriesGameBloc, SeriesGameState>(
          builder: (context, state) {
        if (state is SeriesGameDataReceivedState) {
          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                padEnds: false,
                scrollBehavior: AppScrollBehavior(),
                controller: highLowGamePageController,
                itemCount: seriesGameBloc.seriesList.length,
                itemBuilder: (context, index) {
                  if (index == seriesGameBloc.seriesList.length / 2) {
                    seriesGameBloc.add(SeriesGameGetDataEvent());
                  }
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          seriesGameBloc.seriesList[index].primaryImage!.url!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ValueListenableBuilder(
                        valueListenable: seriesGameBloc.isAnswered[index],
                        builder: (context, isAnswered, child) {
                          ShowData show = seriesGameBloc.seriesList[index];
                          return Container(
                            padding: EdgeInsets.all(15.h),
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                                child: !(isAnswered ==
                                        AnswerResponse.unanswered)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '"${show.originalTitleText?.text ?? AppStrings.anonymous}"',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            AppStrings.has,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            '${show.ratingsSummary?.aggregateRating ?? 5}',
                                            style: TextStyle(
                                              fontSize: 25.h,
                                              color: const Color(0xfffff989),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            AppStrings.imdbRating,
                                            style: TextStyle(
                                              fontSize: 18.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '"${show.originalTitleText?.text ?? AppStrings.anonymous}"',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            AppStrings.has,
                                            style: TextStyle(
                                              fontSize: 18.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  AnswerResponse response = seriesGameBloc
                                                              .seriesList[
                                                                  index - 1]
                                                              .ratingsSummary!
                                                              .aggregateRating! <=
                                                          show.ratingsSummary!
                                                              .aggregateRating!
                                                      ? AnswerResponse.correct
                                                      : AnswerResponse.wrong;
                                                  seriesGameBloc.add(
                                                    SeriesGameAnswerEvent(
                                                      index: index,
                                                      response: response,
                                                    ),
                                                  );
                                                  if (response ==
                                                      AnswerResponse.correct) {
                                                    highLowGamePageController
                                                        .nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.linear,
                                                    );
                                                    vsOpacity.value = 0;
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 500));
                                                    await animationController
                                                        .forward();
                                                    animationController.reset();
                                                  } else {
                                                    await Future.delayed(
                                                      const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    keyTwo.currentState!
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HighLowGameEndScreen(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 50.h,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.h,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      9999,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          AppStrings.higher,
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xfffff989),
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.h,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_up,
                                                          size: 16.h,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  AnswerResponse response = seriesGameBloc
                                                              .seriesList[
                                                                  index - 1]
                                                              .ratingsSummary!
                                                              .aggregateRating! >=
                                                          show.ratingsSummary!
                                                              .aggregateRating!
                                                      ? AnswerResponse.correct
                                                      : AnswerResponse.wrong;
                                                  seriesGameBloc.add(
                                                    SeriesGameAnswerEvent(
                                                      index: index,
                                                      response: response,
                                                    ),
                                                  );
                                                  if (response ==
                                                      AnswerResponse.correct) {
                                                    highLowGamePageController
                                                        .nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 1000),
                                                      curve: Curves.linear,
                                                    );
                                                    vsOpacity.value = 0;
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 500));
                                                    await animationController
                                                        .forward();
                                                    animationController.reset();
                                                  } else {
                                                    await Future.delayed(
                                                      const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    keyTwo.currentState!
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HighLowGameEndScreen(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 50.h,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.h,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      9999,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          AppStrings.lower,
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xfffff989),
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.h,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                          size: 16.h,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          Text(
                                            AppStrings.imdbRating,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )),
                          );
                        }),
                  );
                },
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: vsOpacity,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: vsOpacity.value,
                            child: Container(
                              height: 50.h,
                              width: 50.h,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  AppStrings.vs,
                                  style: TextStyle(
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 20.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${AppStrings.highScore}${seriesGameBloc.highScore}",
                            style: TextStyle(
                              fontSize: 15.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${AppStrings.score}${seriesGameBloc.score}",
                            style: TextStyle(
                              fontSize: 15.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              )
            ],
          );
        } else {
          return const Center(
            child: Text(AppStrings.somethingWrong),
          );
        }
      }),
    );
  }
}