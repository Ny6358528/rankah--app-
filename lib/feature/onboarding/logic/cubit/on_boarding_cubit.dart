import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rankah/feature/onboarding/data/static_data/on_boarding_data.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());
  final PageController pageController = PageController();

  void nextPage() {
    if (pageController.page!.toInt() < onboardingDataList.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      emit(OnBoardingLastPage());
    }
  }

  void previousPage() {
    if (pageController.page!.toInt() > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      emit(OnBoardingFirstPage());
    }
  }
}
