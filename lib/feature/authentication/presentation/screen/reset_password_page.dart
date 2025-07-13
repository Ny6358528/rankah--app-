// reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/authentication/logic/cubit/forget_password_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/forget_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final codeController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password has been reset successfully.")),
          );
          Navigator.pop(context);
        } else if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();

        return Scaffold(
          appBar: AppBar(title: const Text("Reset Password")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: "Verification Code"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "New Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (codeController.text.isEmpty || passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    cubit.resetPassword(
                      email: widget.email,
                      code: codeController.text.trim(),
                      newPassword: passwordController.text.trim(),
                    );
                  },
                  child: const Text("Reset Password"),
                ),
                if (state is ForgotPasswordLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }
}
