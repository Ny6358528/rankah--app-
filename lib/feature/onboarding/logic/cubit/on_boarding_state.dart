part of 'on_boarding_cubit.dart';

@immutable
sealed class OnBoardingState {}

final class OnBoardingInitial extends OnBoardingState {}
final class OnBoardingLastPage extends OnBoardingState {}
final class OnBoardingFirstPage extends OnBoardingState {}
