import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/components/global_appbar.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/constants/input_decoration.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/global_widget/global_textform_field.dart';
import '../../../../global/utils/navigation.dart';
import '../bloc/update_password_bloc.dart';
import '../bloc/update_password_event.dart';
import '../bloc/update_password_state.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _oldPassCtrl;
  late TextEditingController _newPassCtrl;
  late TextEditingController _confirmPassCtrl;

  final FocusNode _oldPassFocus    = FocusNode();
  final FocusNode _newPassFocus    = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _oldPassCtrl     = TextEditingController();
    _newPassCtrl     = TextEditingController();
    _confirmPassCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _oldPassFocus.dispose();
    _newPassFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<UpdatePasswordBloc>().add(
        UpdatePasswordSubmitted(
          oldPassword: _oldPassCtrl.text.trim(),
          newPassword: _newPassCtrl.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdatePasswordBloc, UpdatePasswordState>(
      listener: (context, state) {
        if (state.status == UpdatePasswordStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          goBack(context);
        }
        if (state.status == UpdatePasswordStatus.failure &&
            state.errorMessage != null) {
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
          backgroundColor: ColorRes.appBackColor,
          appBar: GlobalAppBar(title: 'Change Password'),
          body: ProgressHUD(
            inAsyncCall: state.status == UpdatePasswordStatus.loading,
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Header icon ──────────────────────────────────────────
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: ColorRes.appColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          size: 40,
                          color: ColorRes.appColor,
                        ),
                      ),
                    ),

                    sizedBoxH(12),

                    Center(
                      child: GlobalText(
                        str: 'Update Your Password',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorRes.black,
                      ),
                    ),

                    Center(
                      child: GlobalText(
                        str: 'Enter your current password and choose a new one',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorRes.grey,
                      ),
                    ),

                    sizedBoxH(32),

                    // ── Old Password ─────────────────────────────────────────
                    GlobalTextFormField(
                      controller: _oldPassCtrl,
                      focusNode: _oldPassFocus,
                      titleText: 'Current Password',
                      hintText: 'Enter Current Password',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      isPasswordField: true,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) =>
                          context.read<UpdatePasswordBloc>().add(
                            UpdatePasswordFieldChanged(
                              field: UpdatePasswordField.oldPassword,
                              value: val,
                            ),
                          ),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_newPassFocus),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Current password is required';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(16),

                    // ── New Password ─────────────────────────────────────────
                    GlobalTextFormField(
                      controller: _newPassCtrl,
                      focusNode: _newPassFocus,
                      titleText: 'New Password',
                      hintText: 'Enter New Password',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      isPasswordField: true,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) =>
                          context.read<UpdatePasswordBloc>().add(
                            UpdatePasswordFieldChanged(
                              field: UpdatePasswordField.newPassword,
                              value: val,
                            ),
                          ),
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_confirmPassFocus),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'New password is required';
                        }
                        if (val.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        if (val == _oldPassCtrl.text) {
                          return 'New password must differ from current password';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(16),

                    // ── Confirm Password ─────────────────────────────────────
                    GlobalTextFormField(
                      controller: _confirmPassCtrl,
                      focusNode: _confirmPassFocus,
                      titleText: 'Confirm New Password',
                      hintText: 'Re-enter New Password',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      isPasswordField: true,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) =>
                          context.read<UpdatePasswordBloc>().add(
                            UpdatePasswordFieldChanged(
                              field: UpdatePasswordField.confirmPassword,
                              value: val,
                            ),
                          ),
                      onFieldSubmitted: (_) => _submit(context),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (val != _newPassCtrl.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(32),

                    // ── Submit Button ────────────────────────────────────────
                    GlobalButtonWidget(
                      str: 'UPDATE PASSWORD',
                      height: 45,
                      buttomColor: ColorRes.appColor,
                      onTap: () => _submit(context),
                    ),

                    sizedBoxH(30),
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