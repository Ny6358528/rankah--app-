import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/components/widgets/app_text_form_field.dart';
import 'package:rankah/core/components/widgets/app_material_button.dart';
import 'package:rankah/core/components/models/text_felid_form_model.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:rankah/feature/profile/logic/cubit/profile_state.dart';

class ProfileUserName extends StatefulWidget {
  const ProfileUserName({super.key});

  @override
  State<ProfileUserName> createState() => _ProfileUserNameState();
}

class _ProfileUserNameState extends State<ProfileUserName> {
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
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
          child: const Icon(Icons.person, color: AppColors.secondaryColor),
        ),
        title: Text(
          "Username",
          style: appTextStyleWithColor(
            fontSize: AppFontSize.s18,
            fontColor: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          nameController.text.isEmpty
              ? 'Enter your full name'
              : nameController.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      children: [
        AppTextFormField(
          textFelidFormModel: TextFelidFormModel(
            controller: nameController,
            hintText: 'Enter your name',
            labelText: 'Full Name',
            prefixIcon: Icons.person,
            textInputType: TextInputType.name,
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
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your name')),
                    );
                    return;
                  }

                  setState(() => isLoading = true);
                  await cubit.updateProfileInfo(
                    name: nameController.text.trim(),
                    phone: cubit.phoneNumber ?? "",
                  );
                  setState(() => isLoading = false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name updated successfully')),
                  );
                },
              ),
      ],
    );
  }
}
