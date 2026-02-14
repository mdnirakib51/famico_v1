
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
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  // FocusNodes
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          // Update controllers when credentials are loaded
          if (state.email.isNotEmpty && _emailController.text.isEmpty) {
            _emailController.text = state.email;
          }
          if (state.password.isNotEmpty && _passwordController.text.isEmpty) {
            _passwordController.text = state.password;
          }

          // Navigate on successful login
          if (state.status == LoginStatus.success) {
            // Navigate to home/dashboard
            // navigateAndRemoveAll(context, DashboardScreen());
          }

          // Show error message on failure
          if (state.status == LoginStatus.failure && state.errorMessage != null) {
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
              inAsyncCall: state.status == LoginStatus.loading,
              child: ContainerSpaceBackWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxH(70),
                      const Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText(
                              str: "Welcome",
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                            GlobalText(
                              str: "Please Log In to Continue",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 7,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GlobalTextFormField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                titleText: 'User Email / Unique ID / Phone',
                                hintText: 'Enter Your Email / Unique ID / Phone',
                                decoration: glassInputDecoration,
                                filled: true,
                                fillColor: ColorRes.white,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  context.read<LoginBloc>().add(
                                    LoginFieldChanged(
                                      field: LoginField.email,
                                      value: val,
                                    ),
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_passwordFocus);
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Email / ID / Phone is required';
                                  }
                                  return null;
                                },
                              ),

                              sizedBoxH(10),
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
                                textInputAction: TextInputAction.done,
                                onChanged: (val) {
                                  context.read<LoginBloc>().add(
                                    LoginFieldChanged(
                                      field: LoginField.password,
                                      value: val,
                                    ),
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(
                                      LoginSubmitted(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      ),
                                    );
                                  }
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
                              sizedBoxH(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: Checkbox(
                                      value: state.rememberMe,
                                      activeColor: ColorRes.appColor,
                                      onChanged: (bool? value) {
                                        context.read<LoginBloc>().add(
                                          LoginFieldChanged(
                                            field: LoginField.rememberMe,
                                            value: value ?? false,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  sizedBoxW(10),
                                  const GlobalText(
                                    str: "Remember Me",
                                    color: ColorRes.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  )
                                ],
                              ),

                              sizedBoxH(40),
                              GlobalButtonWidget(
                                str: 'SIGN IN',
                                height: 45,
                                buttomColor: ColorRes.appColor,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(LoginSubmitted(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    ),
                                    );
                                  }
                                },
                              ),

                              sizedBoxH(20),
                              const GlobalText(
                                str: "- - - - - -  or  - - - - - -",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: ColorRes.grey,
                              ),

                              sizedBoxH(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
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

                                  sizedBoxW(10),
                                  Container(
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
                                ],
                              ),

                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  // navigateTo(context, const RegistrationScreenBloc());
                                },
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: CoupleTextButton(
                                    firstText: "Don't have any account?",
                                    secondText: "Registration",
                                  ),
                                ),
                              ),

                              sizedBoxH(30)
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
      ),
    );
  }
}
