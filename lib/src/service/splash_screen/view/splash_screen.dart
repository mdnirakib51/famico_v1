import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../global/constants/colors_resources.dart';
import '../../../global/constants/images.dart';
import '../../../global/global_widget/global_image_loader.dart';
import '../../../global/global_widget/global_sized_box.dart';
import '../../../global/global_widget/global_text.dart';
import '../../../global/utils/navigation.dart';
import '../../auth/login/view/login_screen.dart';
import '../../on_boarding_screen/view/on_boarding_screen.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Set portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Start splash initialization
    context.read<SplashBloc>().add(CheckAppInitialization());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.status == SplashStatus.navigating) {
          // Check if onboarding is completed
          if (!state.onBoardingCompleted) {
            navigateAndRemoveAll(context, OnBoardingScreen());
          } else if (state.token == null) {
            navigateAndRemoveAll(context, LoginScreen());
          } else {
            navigateAndRemoveAll(context, Scaffold(body: Center(child: Text("Home Screen"))));
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorRes.appColor,
        body: SizedBox(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlobalImageLoader(
                        imagePath: Images.appLogoIc,
                        height: 220,
                        width: 220,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.code,
                      color: ColorRes.white,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    GlobalText(
                      str: "Developed By MinifyDev",
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                    ),
                  ],
                ),
                sizedBoxH(30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}