import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/constants/images.dart';
import '../../../../global/constants/input_decoration.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_couple_text_button.dart';
import '../../../../global/global_widget/global_image_loader.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/global_widget/global_textform_field.dart';
import '../../../../global/widget/container_space_background_widget.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<RegistrationBloc>().add(
        RegistrationSubmitted(
          username: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status == RegistrationStatus.success) {
          // navigateAndRemoveAll(context, DashboardScreen());
        }

        if (state.status == RegistrationStatus.failure &&
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
            inAsyncCall: state.status == RegistrationStatus.loading,
            child: ContainerSpaceBackWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBoxH(60),
                    const Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText(
                            str: "Create Account",
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                          GlobalText(
                            str: "Please Register to Continue",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 9,
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              // ── Full Name ──
                              GlobalTextFormField(
                                controller: _nameController,
                                focusNode: _nameFocus,
                                titleText: 'Username',
                                hintText: 'Enter Your Username',
                                decoration: glassInputDecoration,
                                filled: true,
                                fillColor: ColorRes.white,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  context.read<RegistrationBloc>().add(
                                    RegistrationFieldChanged(
                                      field: RegistrationField.username,
                                      value: val,
                                    ),
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_emailFocus);
                                },
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Full name is required';
                                  }
                                  if (val.trim().length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),

                              sizedBoxH(10),

                              // ── Email ──
                              GlobalTextFormField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                titleText: 'Email',
                                hintText: 'Enter Your Email',
                                decoration: glassInputDecoration,
                                filled: true,
                                fillColor: ColorRes.white,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  context.read<RegistrationBloc>().add(
                                    RegistrationFieldChanged(
                                      field: RegistrationField.email,
                                      value: val,
                                    ),
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_phoneFocus);
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                  );
                                  if (!emailRegex.hasMatch(val)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              sizedBoxH(10),

                              // ── Phone ──
                              GlobalTextFormField(
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                titleText: 'Phone Number',
                                hintText: 'Enter Your Phone Number',
                                decoration: glassInputDecoration,
                                filled: true,
                                fillColor: ColorRes.white,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  context.read<RegistrationBloc>().add(
                                    RegistrationFieldChanged(
                                      field: RegistrationField.phone,
                                      value: val,
                                    ),
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_passwordFocus);
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  if (val.length < 10) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),

                              sizedBoxH(10),

                              // ── Password ──
                              GlobalTextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                titleText: 'Password',
                                hintText: 'Enter Your Password',
                                decoration: glassInputDecoration,
                                filled: true,
                                fillColor: ColorRes.white,
                                isDense: true,
                                isPasswordField: true,
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  context.read<RegistrationBloc>().add(
                                    RegistrationFieldChanged(
                                      field: RegistrationField.password,
                                      value: val,
                                    ),
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_confirmPasswordFocus);
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

                              sizedBoxH(10),

                              // ── Confirm Password ──
                              GlobalTextFormField(
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                titleText: 'Confirm Password',
                                hintText: 'Re-enter Your Password',
                                decoration: glassInputDecoration,
                                filled: true,
                                fillColor: ColorRes.white,
                                isDense: true,
                                isPasswordField: true,
                                textInputAction: TextInputAction.done,
                                onChanged: (val) {
                                  context.read<RegistrationBloc>().add(
                                    RegistrationFieldChanged(
                                      field: RegistrationField.confirmPassword,
                                      value: val,
                                    ),
                                  );
                                },
                                onFieldSubmitted: (_) => _submitForm(context),
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

                              // ── Register Button ──
                              GlobalButtonWidget(
                                str: 'REGISTER',
                                height: 45,
                                buttomColor: ColorRes.appColor,
                                onTap: () => _submitForm(context),
                              ),

                              sizedBoxH(20),
                              const GlobalText(
                                str: "- - - - - -  or  - - - - - -",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: ColorRes.grey,
                              ),

                              sizedBoxH(20),

                              // ── Social Login Buttons ──
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.read<RegistrationBloc>().add(
                                        RegistrationWithFacebookRequested(),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: ColorRes.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: const GlobalImageLoader(
                                        imagePath: Images.facebookIc,
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ),

                                  sizedBoxW(10),

                                  GestureDetector(
                                    onTap: () {
                                      context.read<RegistrationBloc>().add(
                                        RegistrationWithGoogleRequested(),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: ColorRes.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: GlobalImageLoader(
                                        imagePath: Images.googleIc,
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              sizedBoxH(20),

                              // ── Already have account ──
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: CoupleTextButton(
                                    firstText: "Already have an account?",
                                    secondText: "Login",
                                  ),
                                ),
                              ),

                              sizedBoxH(30),
                            ],
                          ),
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