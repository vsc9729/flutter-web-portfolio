part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

final class NavigationInitial extends NavigationState {}

final class HomePage extends NavigationState {}

final class ProjectsPage extends NavigationState {}

final class AboutPage extends NavigationState {}

final class ContactPage extends NavigationState {}
