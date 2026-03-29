import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/routes/app_navigator.dart';
import '../../../app/routes/app_route.dart';
import '../../../global/constants/colors_resources.dart';
import '../../../global/constants/images.dart';
import '../../../global/global_widget/global_image_loader.dart';
import '../../../global/widget/container_space_background_widget.dart';
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
          if (!state.onBoardingCompleted) {
            AppNavigator.pushAndRemoveAll(context, AppRouteKeys.onBoarding);
          } else if (state.token == null) {
            AppNavigator.pushAndRemoveAll(context, AppRouteKeys.login);
          } else {
            AppNavigator.pushAndRemoveAll(context, AppRouteKeys.dashboard);
          }
        }
      },
      child: const Scaffold(
        backgroundColor: ColorRes.appBackColor,
        body: ContainerSpaceBackWidget(
          child: Center(
            child: GlobalImageLoader(
              imagePath: Images.appLogoIc,
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}