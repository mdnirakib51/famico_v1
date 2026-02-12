
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/constants/input_decoration.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/global_widget/global_textform_field.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'components/auth_background_com.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          // Update controllers when credentials are loaded
          if (state.email != _emailController.text) {
            _emailController.text = state.email;
          }
          if (state.password != _passwordController.text) {
            _passwordController.text = state.password;
          }

          // Navigate on successful login
          if (state.status == LoginStatus.success) {
            // Get.offAll(() => DashboardBottomNavigationBar());
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
            body: ProgressHUD(
              inAsyncCall: state.status == LoginStatus.loading,
              child: Form(
                key: _formKey,
                child: AuthBackGroundCom(
                  children: [
                    sizedBoxH(70),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText(
                            str: "Welcome",
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                          GlobalText(
                            str: "Please Log In to Continue",
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GlobalTextFormField(
                              controller: _emailController,
                              titleText: 'User Email / Unique ID / Phone',
                              hintText: 'Enter Your Email / Unique ID / Phone',
                              decoration: glassInputDecoration,
                              filled: true,
                              fillColor: ColorRes.white,
                              keyboardType: TextInputType.emailAddress,
                              titleStyle: GoogleFonts.roboto(
                                color: ColorRes.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                              onChanged: (val) {
                                context.read<LoginBloc>().add(LoginFieldChanged(field: LoginField.email, value: val));
                              },
                            ),
                            sizedBoxH(20),
                            GlobalTextFormField(
                              controller: _passwordController,
                              titleText: 'Password',
                              hintText: 'Enter Your Password',
                              decoration: glassInputDecoration,
                              filled: true,
                              fillColor: ColorRes.white,
                              titleStyle: GoogleFonts.roboto(
                                color: ColorRes.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                              isDense: true,
                              isPasswordField: true,
                              onChanged: (val) {
                                context.read<LoginBloc>().add(LoginFieldChanged(field: LoginField.password, value: val));
                              },
                            ),
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
                                      context.read<LoginBloc>().add(LoginFieldChanged(field: LoginField.rememberMe, value: value ?? false));
                                    },
                                  ),
                                ),
                                sizedBoxW(10),
                                const GlobalText(
                                  str: "Remember Me",
                                  color: ColorRes.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                )
                              ],
                            ),
                            sizedBoxH(40),
                            GlobalButtonWidget(
                              str: 'SIGN IN',
                              height: 45,
                              buttomColor: ColorRes.appButtonColor,
                              onTap: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  context.read<LoginBloc>().add(LoginSubmitted(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ));
                                }
                              },
                            ),
                            sizedBoxH(20),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 4, child: SizedBox()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}