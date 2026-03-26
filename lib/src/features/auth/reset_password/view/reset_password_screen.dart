import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/constants/input_decoration.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/global_widget/global_textform_field.dart';
import '../../../../global/utils/navigation.dart';
import '../../../../global/widget/container_space_background_widget.dart';
import '../../../../app/routes/app_route.dart';
import '../bloc/reset_password_bloc.dart';
import '../bloc/reset_password_event.dart';
import '../bloc/reset_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneEmail;

  const ResetPasswordScreen({super.key, required this.phoneEmail});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordBloc>().add(
        ResetPasswordSubmitted(
          phoneEmail: widget.phoneEmail,
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.status == ResetPasswordStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          navigateAndRemoveAllNamed(context, AppRouteKeys.login);
        }

        if (state.status == ResetPasswordStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorRes.appBackColor,
          body: ProgressHUD(
            inAsyncCall: state.status == ResetPasswordStatus.loading,
            child: ContainerSpaceBackWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBoxH(60),

                    // ── Back Button ──
                    GestureDetector(
                      onTap: () => goBack(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: ColorRes.black,
                        size: 22,
                      ),
                    ),

                    sizedBoxH(20),

                    // ── Header ──
                    const Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText(
                            str: "Reset Password",
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                          GlobalText(
                            str: "Enter your new password below",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorRes.grey,
                          ),
                        ],
                      ),
                    ),

                    // ── Form ──
                    Expanded(
                      flex: 7,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ── New Password ──
                            GlobalTextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              titleText: 'New Password',
                              hintText: 'Enter New Password',
                              decoration: glassInputDecoration,
                              filled: true,
                              fillColor: ColorRes.white,
                              isDense: true,
                              isPasswordField: true,
                              textInputAction: TextInputAction.next,
                              onChanged: (val) {
                                context.read<ResetPasswordBloc>().add(
                                  ResetPasswordFieldChanged(
                                    field: ResetPasswordField.password,
                                    value: val,
                                  ),
                                );
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocus);
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Password is required';
                                }
                                if (val.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            sizedBoxH(12),

                            // ── Confirm Password ──
                            GlobalTextFormField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              titleText: 'Confirm Password',
                              hintText: 'Re-enter New Password',
                              decoration: glassInputDecoration,
                              filled: true,
                              fillColor: ColorRes.white,
                              isDense: true,
                              isPasswordField: true,
                              textInputAction: TextInputAction.done,
                              onChanged: (val) {
                                context.read<ResetPasswordBloc>().add(
                                  ResetPasswordFieldChanged(
                                    field: ResetPasswordField.confirmPassword,
                                    value: val,
                                  ),
                                );
                              },
                              onFieldSubmitted: (_) => _submit(context),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (val != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            sizedBoxH(30),

                            GlobalButtonWidget(
                              str: 'RESET PASSWORD',
                              height: 45,
                              buttomColor: ColorRes.appColor,
                              onTap: () => _submit(context),
                            ),

                            const Spacer(),
                            sizedBoxH(30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}