part of 'navigation_bloc.dart';

@immutable
sealed class NavigationEvent {}

final class HomePageEvent extends NavigationEvent {}

final class ProjectsPageEvent extends NavigationEvent {}

final class AboutPageEvent extends NavigationEvent {}

final class ContactPageEvent extends NavigationEvent {}
