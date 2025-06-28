

part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ParkingSpotModel> parkingSpots;
  HomeSuccess({required this.parkingSpots});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
