import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';

class CarPlateNumber extends StatelessWidget {
  const CarPlateNumber({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: context.read<ReservationCubit>().carPlateNumberController,
      length: 7,
      keyboardType: TextInputType.text,
      defaultPinTheme: PinTheme(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.fourthColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.fourthColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      errorPinTheme: PinTheme(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.errorColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
