import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/home/data/home_repository.dart';
import 'package:rankah/feature/home/data/parking_spot_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit({required this.homeRepository}) : super(HomeInitial()) {
    print('HomeCubit initialized');
  }

  int currentIndex = 0;
  List<ParkingSpotModel> parkingSpots = [];

  void changeIndex(int index) {
    print('HomeCubit: changeIndex called with index = ' + index.toString());
    currentIndex = index;
    emit(HomeInitial());
    if (index == 0 || index == 1) {
      print(
          'HomeCubit: changeIndex detected Home/Pending tab, calling getParkingSpots');
      if (index == 0) {
        // Refresh data when returning to Home
        refreshParkingSpots();
      } else {
        // Just get data for Pending
        getParkingSpots();
      }
    }
  }

  Future<void> getParkingSpots() async {
    print('HomeCubit: Starting to fetch parking spots');
    emit(HomeLoading());

    try {
      print('HomeCubit: Calling repository.getParkingSpots()');
      parkingSpots = await homeRepository.getParkingSpots();
      print('HomeCubit: Successfully fetched ' +
          parkingSpots.length.toString() +
          ' parking spots');
      for (var spot in parkingSpots) {
        print('HomeCubit: Spot: ' +
            spot.name +
            ' - Status: ' +
            spot.spotStatus.toString());
      }
      emit(HomeSuccess(parkingSpots: parkingSpots));
      print('HomeCubit: Emitted HomeSuccess');
    } catch (e) {
      print('HomeCubit: Error fetching parking spots: ' + e.toString());
      emit(HomeError(message: e.toString()));
      print('HomeCubit: Emitted HomeError');
    }
  }

  Future<void> refreshParkingSpots() async {
    print('HomeCubit: Refreshing parking spots');
    await getParkingSpots();
  }
}
