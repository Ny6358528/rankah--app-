import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/components/widgets/app_material_button.dart';
import 'package:rankah/core/functions/app_regex.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';

class ReservationButton extends StatelessWidget {
  final int parkingSpotId;
  const ReservationButton({super.key, required this.parkingSpotId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReservationCubit>();
    return AppMaterialButton(
      onPressed: () {
        final text = cubit.carPlateNumberController.text.trim();
        if (text.isNotEmpty) {
          if (!AppRegex.isCarNumberValid(text)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Invalid car plate number format'),
            ));
          } else {
            cubit.reserveSpot(parkingSpotId);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please fill the car plate number'),
          ));
        }
      },
      color: AppColors.primaryColor,
      buttonString: 'Reserve Spot',
    );
  }
}
