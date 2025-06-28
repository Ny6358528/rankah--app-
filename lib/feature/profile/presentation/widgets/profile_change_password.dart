import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/components/widgets/app_text_form_field.dart';
import 'package:rankah/core/components/widgets/app_material_button.dart';
import 'package:rankah/core/components/models/text_felid_form_model.dart';
import 'package:rankah/core/functions/app_regex.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/profile/logic/cubit/profile_cubit.dart';

class ProfileChangePassword extends StatefulWidget {
  const ProfileChangePassword({super.key});

  @override
  State<ProfileChangePassword> createState() => _ProfileChangePasswordState();
}

class _ProfileChangePasswordState extends State<ProfileChangePassword> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return ExpansionTile(
      title: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.lock, color: AppColors.secondaryColor),
        ),
        title: Text(
          "Change Password",
          style: appTextStyleWithColor(
            fontSize: AppFontSize.s18,
            fontColor: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          newPasswordController.text.isEmpty
              ? '*********************'
              : newPasswordController.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      children: [
        Text(
          'Change password to secure your account',
          style: appTextStyleWithColor(
            fontSize: AppFontSize.s14,
            fontColor: AppColors.fourthColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Form(
          key: formKey,
          child: Column(
            children: [
              AppTextFormField(
                textFelidFormModel: TextFelidFormModel(
                  controller: currentPasswordController,
                  hintText: 'Current Password',
                  labelText: 'Current Password',
                  prefixIcon: Icons.lock_outline,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                textFelidFormModel: TextFelidFormModel(
                  controller: newPasswordController,
                  hintText: 'New Password',
                  labelText: 'New Password',
                  prefixIcon: Icons.lock,
                  obscureText: cubit.isPasswordVisible,
                  textInputType: TextInputType.visiblePassword,
                  suffixOnPressed: cubit.togglePasswordVisibility,
                  suffixIcon: cubit.isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                textFelidFormModel: TextFelidFormModel(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  labelText: 'Confirm Password',
                  prefixIcon: Icons.lock,
                  obscureText: cubit.isConfirmPasswordVisible,
                  textInputType: TextInputType.visiblePassword,
                  suffixOnPressed: cubit.toggleConfirmPasswordVisibility,
                  suffixIcon: cubit.isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : AppMaterialButton(
                      buttonString: "Save",
                      color: AppColors.primaryColor,
                      onPressed: () async {
                        final current = currentPasswordController.text.trim();
                        final newPass = newPasswordController.text.trim();
                        final confirm = confirmPasswordController.text.trim();

                        if (!formKey.currentState!.validate()) return;

                        if (!AppRegex.isPasswordValid(newPass)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password is too weak')),
                          );
                          return;
                        }

                        if (newPass != confirm) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        await cubit.changePassword(
                          currentPassword: current,
                          newPassword: newPass,
                        );

                        setState(() => isLoading = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password updated successfully')),
                        );
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
