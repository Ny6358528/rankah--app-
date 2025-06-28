import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/components/widgets/app_text_form_field.dart';
import 'package:rankah/core/components/widgets/app_material_button.dart';
import 'package:rankah/core/components/models/text_felid_form_model.dart';
import 'package:rankah/core/functions/app_regex.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/profile/logic/cubit/profile_cubit.dart';

class ProfilePhone extends StatefulWidget {
  const ProfilePhone({super.key});

  @override
  State<ProfilePhone> createState() => _ProfilePhoneState();
}

class _ProfilePhoneState extends State<ProfilePhone> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
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
          child: const Icon(Icons.phone, color: AppColors.secondaryColor),
        ),
        title: Text(
          "Phone",
          style: appTextStyleWithColor(
            fontSize: AppFontSize.s18,
            fontColor: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          phoneController.text.isEmpty
              ? 'Enter your phone number'
              : phoneController.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      children: [
        AppTextFormField(
          textFelidFormModel: TextFelidFormModel(
            controller: phoneController,
            hintText: 'Enter your phone number',
            labelText: 'Phone Number',
            prefixIcon: Icons.phone,
            textInputType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 10),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : AppMaterialButton(
                buttonString: "Save",
                color: AppColors.primaryColor,
                onPressed: () async {
                  final phone = phoneController.text.trim();

                  if (phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter your phone number')),
                    );
                    return;
                  }

                  if (!AppRegex.isPhoneNumberValid(phone)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid phone number')),
                    );
                    return;
                  }

                  setState(() => isLoading = true);
                  await cubit.updateProfileInfo(
                    name: cubit.fullName ?? '',
                    phone: phone,
                  );
                  setState(() => isLoading = false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Phone number updated successfully')),
                  );
                },
              ),
      ],
    );
  }
}
