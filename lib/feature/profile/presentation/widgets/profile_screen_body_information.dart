import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/functions/navigation.dart';
import 'package:rankah/core/helpers/tokenStorage.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:rankah/feature/profile/presentation/widgets/profile_change_password.dart';
import 'package:rankah/feature/profile/presentation/widgets/profile_phone.dart';
import 'package:rankah/feature/profile/presentation/widgets/profile_username.dart';
import 'package:rankah/feature/authentication/presentation/screen/login_screen.dart';
import 'package:rankah/core/utils/app_font.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileUserName(),
        const Divider(),
        const ProfilePhone(),
        const Divider(),
        const ProfileChangePassword(),
        const Divider(),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.errorColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.errorColor,
          child: Icon(
            Icons.logout,
            color: AppColors.secondaryColor,
            size: 16.sp,
          ),
        ),
        title: Text(
          "Logout",
          style: appTextStyleWithColor(
            fontSize: AppFontSize.s16,
            fontColor: AppColors.errorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Sign out from your account',
          style: appTextStyleWithColor(
            fontSize: AppFontSize.s12,
            fontColor: AppColors.fourthColor,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppColors.errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.errorColor,
            size: 12.sp,
          ),
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.fourthColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.fourthColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout(context);
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: AppColors.errorColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      // مسح التوكن
      await TokenStorage.clearTokens();

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: AppColors.successColor,
        ),
      );

      // التنقل إلى شاشة تسجيل الدخول
      pushWithReplacement(context, const LoginScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred during logout: $e'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }
}
