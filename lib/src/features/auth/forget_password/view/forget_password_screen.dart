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
import '../bloc/forget_password_bloc.dart';
import '../bloc/forget_password_event.dart';
import '../bloc/forget_password_state.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late TextEditingController _phoneEmailController;
  late TextEditingController _otpController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  final FocusNode _phoneEmailFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _phoneEmailController = TextEditingController();
    _otpController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneEmailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _phoneEmailFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _submitEmail(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_emailFormKey.currentState!.validate()) {
      context.read<ForgetPasswordBloc>().add(
        ForgetPasswordSubmitted(
          phoneEmail: _phoneEmailController.text.trim(),
        ),
      );
    }
  }

  void _submitOtp(BuildContext context) {
    context.read<ForgetPasswordBloc>().add(const ForgetPasswordOtpSubmitted());
  }

  void _submitReset(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_passwordFormKey.currentState!.validate()) {
      context.read<ForgetPasswordBloc>().add(const ForgetPasswordResetSubmitted());
    }
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state.status == ForgetPasswordStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          goBack(context);
        }

        if (state.status == ForgetPasswordStatus.failure &&
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
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorRes.appBackColor,
          body: ProgressHUD(
            inAsyncCall: state.status == ForgetPasswordStatus.loading,
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
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText(
                            str: _headerTitle(state.step),
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                          GlobalText(
                            str: _headerSubtitle(state.step),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorRes.grey,
                          ),
                        ],
                      ),
                    ),

                    // ── Step Content ──
                    Expanded(
                      flex: 7,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: switch (state.step) {
                          ForgetPasswordStep.email => _EmailStep(
                            key: const ValueKey('email'),
                            formKey: _emailFormKey,
                            controller: _phoneEmailController,
                            focusNode: _phoneEmailFocus,
                            onChanged: (val) {
                              context.read<ForgetPasswordBloc>().add(
                                ForgetPasswordFieldChanged(
                                  field: ForgetPasswordField.phoneEmail,
                                  value: val,
                                ),
                              );
                            },
                            onSubmit: () => _submitEmail(context),
                          ),
                          ForgetPasswordStep.otp => _OtpStep(
                            key: const ValueKey('otp'),
                            controller: _otpController,
                            state: state,
                            onOtpChanged: (val) {
                              context.read<ForgetPasswordBloc>().add(
                                ForgetPasswordOtpChanged(otp: val),
                              );
                            },
                            onSubmit: () => _submitOtp(context),
                            onResend: () {
                              _otpController.clear();
                              context.read<ForgetPasswordBloc>().add(
                                const ForgetPasswordResendOtp(),
                              );
                            },
                            formatTimer: _formatTimer,
                          ),
                          ForgetPasswordStep.newPassword => _NewPasswordStep(
                            key: const ValueKey('newPassword'),
                            formKey: _passwordFormKey,
                            newController: _newPasswordController,
                            confirmController: _confirmPasswordController,
                            newFocus: _newPasswordFocus,
                            confirmFocus: _confirmPasswordFocus,
                            obscureNew: _obscureNew,
                            obscureConfirm: _obscureConfirm,
                            state: state,
                            onNewChanged: (val) {
                              context.read<ForgetPasswordBloc>().add(
                                ForgetPasswordNewPasswordChanged(
                                    newPassword: val),
                              );
                            },
                            onConfirmChanged: (val) {
                              context.read<ForgetPasswordBloc>().add(
                                ForgetPasswordConfirmPasswordChanged(
                                    confirmPassword: val),
                              );
                            },
                            onToggleNew: () =>
                                setState(() => _obscureNew = !_obscureNew),
                            onToggleConfirm: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                            onSubmit: () => _submitReset(context),
                          ),
                        },
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

  String _headerTitle(ForgetPasswordStep step) {
    return switch (step) {
      ForgetPasswordStep.email => 'Forgot Password?',
      ForgetPasswordStep.otp => 'Enter OTP',
      ForgetPasswordStep.newPassword => 'New Password',
    };
  }

  String _headerSubtitle(ForgetPasswordStep step) {
    return switch (step) {
      ForgetPasswordStep.email => 'Enter your email or phone to receive OTP',
      ForgetPasswordStep.otp =>
      'Enter the 6-digit OTP sent to your email/phone',
      ForgetPasswordStep.newPassword => 'Set your new password',
    };
  }
}

// ─────────────────────────────────────────────
// Step 1: Email Input
// ─────────────────────────────────────────────
class _EmailStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  const _EmailStep({
    super.key,
    required this.formKey,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GlobalTextFormField(
            controller: controller,
            focusNode: focusNode,
            titleText: 'Email / Phone',
            hintText: 'Enter Your Email or Phone',
            decoration: glassInputDecoration,
            filled: true,
            fillColor: ColorRes.white,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: onChanged,
            onFieldSubmitted: (_) => onSubmit(),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Email or Phone is required';
              }
              return null;
            },
          ),
          sizedBoxH(30),
          GlobalButtonWidget(
            str: 'SEND OTP',
            height: 45,
            buttomColor: ColorRes.appColor,
            onTap: onSubmit,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => goBack(context),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Remember your password? ",
                    style: TextStyle(
                      color: ColorRes.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "Login",
                    style: TextStyle(
                      color: ColorRes.appColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          sizedBoxH(30),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Step 2: OTP Input
// ─────────────────────────────────────────────
class _OtpStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgetPasswordState state;
  final ValueChanged<String> onOtpChanged;
  final VoidCallback onSubmit;
  final VoidCallback onResend;
  final String Function(int) formatTimer;

  const _OtpStep({
    super.key,
    required this.controller,
    required this.state,
    required this.onOtpChanged,
    required this.onSubmit,
    required this.onResend,
    required this.formatTimer,
  });

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = state.isOtpComplete;
    final bool timerExpired = !state.isTimerRunning && state.timerSeconds == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // OTP TextField (6-digit, maxLength)
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 12,
          ),
          decoration: glassInputDecoration.copyWith(
            hintText: '------',
            hintStyle: const TextStyle(
              fontSize: 24,
              letterSpacing: 12,
              color: ColorRes.grey,
            ),
            counterText: '',
            filled: true,
            fillColor: ColorRes.white,
          ),
          onChanged: onOtpChanged,
        ),

        sizedBoxH(16),

        // Timer / Resend row
        if (!timerExpired)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GlobalText(
                str: 'Resend OTP in ',
                fontSize: 13,
                color: ColorRes.grey,
              ),
              GlobalText(
                str: formatTimer(state.timerSeconds),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ColorRes.appColor,
              ),
            ],
          )
        else
          GestureDetector(
            onTap: onResend,
            child: const GlobalText(
              str: 'Resend OTP',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ColorRes.appColor,
            ),
          ),

        sizedBoxH(30),

        // Submit button — grey when OTP incomplete
        GlobalButtonWidget(
          str: 'SUBMIT OTP',
          height: 45,
          buttomColor: canSubmit ? ColorRes.appColor : ColorRes.grey,
          onTap: canSubmit ? onSubmit : null,
        ),

        const Spacer(),
        sizedBoxH(30),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Step 3: New Password Input
// ─────────────────────────────────────────────
class _NewPasswordStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController newController;
  final TextEditingController confirmController;
  final FocusNode newFocus;
  final FocusNode confirmFocus;
  final bool obscureNew;
  final bool obscureConfirm;
  final ForgetPasswordState state;
  final ValueChanged<String> onNewChanged;
  final ValueChanged<String> onConfirmChanged;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;

  const _NewPasswordStep({
    super.key,
    required this.formKey,
    required this.newController,
    required this.confirmController,
    required this.newFocus,
    required this.confirmFocus,
    required this.obscureNew,
    required this.obscureConfirm,
    required this.state,
    required this.onNewChanged,
    required this.onConfirmChanged,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GlobalTextFormField(
            controller: newController,
            focusNode: newFocus,
            titleText: 'New Password',
            hintText: 'Enter New Password',
            decoration: glassInputDecoration,
            filled: true,
            fillColor: ColorRes.white,
            obscureText: obscureNew,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            suffixIcon: GestureDetector(
              onTap: onToggleNew,
              child: Icon(
                obscureNew ? Icons.visibility_off : Icons.visibility,
                color: ColorRes.grey,
              ),
            ),
            onChanged: onNewChanged,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(confirmFocus),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Password is required';
              if (val.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),

          sizedBoxH(16),

          GlobalTextFormField(
            controller: confirmController,
            focusNode: confirmFocus,
            titleText: 'Confirm Password',
            hintText: 'Re-enter New Password',
            decoration: glassInputDecoration,
            filled: true,
            fillColor: ColorRes.white,
            obscureText: obscureConfirm,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            suffixIcon: GestureDetector(
              onTap: onToggleConfirm,
              child: Icon(
                obscureConfirm ? Icons.visibility_off : Icons.visibility,
                color: ColorRes.grey,
              ),
            ),
            onChanged: onConfirmChanged,
            onFieldSubmitted: (_) => onSubmit(),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please confirm your password';
              }
              if (val != newController.text) return 'Passwords do not match';
              return null;
            },
          ),

          sizedBoxH(30),

          GlobalButtonWidget(
            str: 'RESET PASSWORD',
            height: 45,
            buttomColor: ColorRes.appColor,
            onTap: onSubmit,
          ),

          const Spacer(),
          sizedBoxH(30),
        ],
      ),
    );
  }
}