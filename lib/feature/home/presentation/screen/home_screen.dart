import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/services/service_locator.dart';
import 'package:rankah/core/utils/app_padding.dart';
import 'package:rankah/core/utils/app_strings.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/history/logic/cubit/history_cubit.dart';
import 'package:rankah/feature/history/presentation/screen/history_screen.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_cubit.dart';
import 'package:rankah/feature/home/presentation/widgets/home_screen_body.dart';
import 'package:rankah/feature/home/presentation/widgets/home_screen_navigation_bar.dart';
import 'package:rankah/feature/home/presentation/screen/pending_list_screen.dart';
import 'package:rankah/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:rankah/feature/profile/presentation/widgets/profile_screen_body.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('HomeScreen: Building widget');
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) {
            print('HomeScreen: Creating HomeCubit');
            final cubit = sl<HomeCubit>();
            print('HomeScreen: HomeCubit created, calling getParkingSpots');
            cubit.getParkingSpots();
            return cubit;
          },
        ),
        BlocProvider<PendingReservationCubit>(
          create: (context) => sl<PendingReservationCubit>(),
        ),
        BlocProvider<ReservationCubit>(
          create: (_) => sl<ReservationCubit>(),
        ),
        BlocProvider<HistoryCubit>(
          create: (_) => sl<HistoryCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appName),
          actions: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondaryColor),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        bottomSheet: const HomeScreenNavigationBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p16),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return IndexedStack(
                  index: context.watch<HomeCubit>().currentIndex,
                  children: [
                    HomeScreenBody(),
                    PendingListScreen(),
                    HistoryScreen(),
                    ProfileScreenBody(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
