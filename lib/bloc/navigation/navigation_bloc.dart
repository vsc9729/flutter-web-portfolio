import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomePage()) {
    on<NavigationEvent>((event, emit) {});
    on<HomePageEvent>(_handleHomePageEvent);
    on<ProjectsPageEvent>(_handleProjectsPageEvent);
    on<AboutPageEvent>(_handleAboutPageEvent);
    on<ContactPageEvent>(_handleContactPageEvent);
  }

  FutureOr<void> _handleHomePageEvent(
    HomePageEvent event,
    Emitter<NavigationState> emit,
  ) {
    emit(HomePage());
  }

  FutureOr<void> _handleProjectsPageEvent(
    ProjectsPageEvent event,
    Emitter<NavigationState> emit,
  ) {
    emit(ProjectsPage());
  }

  FutureOr<void> _handleAboutPageEvent(
    AboutPageEvent event,
    Emitter<NavigationState> emit,
  ) {
    emit(AboutPage());
  }

  FutureOr<void> _handleContactPageEvent(
    ContactPageEvent event,
    Emitter<NavigationState> emit,
  ) {
    emit(ContactPage());
  }
}
