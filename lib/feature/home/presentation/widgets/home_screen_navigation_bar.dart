import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_cubit.dart';

class HomeScreenNavigationBar extends StatelessWidget {
  const HomeScreenNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black45, blurRadius: 5.0),
            ],
          ),
          child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: context.read<HomeCubit>().currentIndex,
              onTap: (value) {
                context.read<HomeCubit>().changeIndex(value);
                if (value == 1) {
                  context
                      .read<PendingReservationCubit>()
                      .getPendingReservations();
                }
              },
              elevation: 10,
              items: [
                BottomNavigationBarItem(
                  icon: state is HomeLoading &&
                          context.read<HomeCubit>().currentIndex == 0
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.home_outlined),
                  activeIcon: state is HomeLoading &&
                          context.read<HomeCubit>().currentIndex == 0
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  activeIcon: const Icon(Icons.schedule),
                  icon: const Icon(Icons.schedule_outlined),
                  label: "Pending",
                ),
                BottomNavigationBarItem(
                  activeIcon: const Icon(Icons.history_rounded),
                  icon: const Icon(Icons.history_toggle_off_outlined),
                  label: "History",
                ),
                BottomNavigationBarItem(
                  activeIcon: const Icon(Icons.person),
                  icon: const Icon(Icons.person_outlined),
                  label: "Profile",
                ),
              ]),
        );
      },
    );
  }
}
