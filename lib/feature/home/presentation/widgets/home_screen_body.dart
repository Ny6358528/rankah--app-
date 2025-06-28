import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_cubit.dart';
import 'package:rankah/feature/home/presentation/widgets/home_screen_body_information.dart';
import 'package:rankah/feature/home/presentation/widgets/spots_items.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeCubit>().getParkingSpots();
        context.read<PendingReservationCubit>().getPendingReservations();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            EasyDateTimeLine(
              initialDate: DateTime.now(),
              activeColor: AppColors.primaryColor,
            ),
            Divider(),
            HomeScreenBodyPictures(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Find Your Parking Spot Now",
                        style: appTextStyleWithColor(
                          fontSize: AppFontSize.s20,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return IconButton(
                          onPressed: state is HomeLoading
                              ? null
                              : () {
                                  context.read<HomeCubit>().getParkingSpots();
                                  context
                                      .read<PendingReservationCubit>()
                                      .getPendingReservations();
                                },
                          icon: state is HomeLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryColor),
                                  ),
                                )
                              : Icon(
                                  Icons.refresh,
                                  color: AppColors.primaryColor,
                                  size: 24.sp,
                                ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  'Find parking, and plan your trips with ease, and drive safely with peace of mind with Rankah Application.',
                  style: appTextStyleWithColor(
                    fontSize: AppFontSize.s10,
                    fontWeight: FontWeight.bold,
                    fontColor: AppColors.fourthColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(),
                SpotsItems(),
              ],
            ),
            Divider(),
            SizedBox(height: 100.h)
          ],
        ),
      ),
    );
  }
}
