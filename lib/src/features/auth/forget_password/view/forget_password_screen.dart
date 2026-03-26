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
import '../../reset_password/bloc/reset_password_bloc.dart';
import '../../reset_password/view/reset_password_screen.dart';
import '../bloc/forget_password_bloc.dart';
import '../bloc/forget_password_event.dart';
import '../bloc/forget_password_state.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneEmailController;
  final FocusNode _phoneEmailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneEmailController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneEmailController.dispose();
    _phoneEmailFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordBloc>().add(
        ForgetPasswordSubmitted(
          phoneEmail: _phoneEmailController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state.status == ForgetPasswordStatus.success) {
          navigateTo(context, BlocProvider(
            create: (_) => ResetPasswordBloc(),
            child: ResetPasswordScreen(
              phoneEmail: _phoneEmailController.text.trim(),
            )),
          );
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
                    const Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText(
                            str: "Forgot Password?",
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                          GlobalText(
                            str: "Enter your email or phone to receive OTP",
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
                            GlobalTextFormField(
                              controller: _phoneEmailController,
                              focusNode: _phoneEmailFocus,
                              titleText: 'Email / Phone',
                              hintText: 'Enter Your Email or Phone',
                              decoration: glassInputDecoration,
                              filled: true,
                              fillColor: ColorRes.white,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onChanged: (val) {
                                context.read<ForgetPasswordBloc>().add(
                                  ForgetPasswordFieldChanged(
                                    field: ForgetPasswordField.phoneEmail,
                                    value: val,
                                  ),
                                );
                              },
                              onFieldSubmitted: (_) => _submit(context),
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
                              onTap: () => _submit(context),
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