import 'package:famico_v1/src/features/user/upload_doc/bloc/upload_doc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/routes/app_route.dart';
import 'features/auth/login/bloc/login_bloc.dart';
import 'features/auth/registration/bloc/registration_bloc.dart';
import 'features/on_boarding_screen/bloc/on_boarding_bloc.dart';
import 'features/splash_screen/bloc/splash_bloc.dart';
import 'features/user/profile/bloc/profile_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashBloc()),
        BlocProvider(create: (_) => OnBoardingBloc()),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => RegistrationBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
        BlocProvider(create: (_) => UploadDocBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouteKeys.splash,
        onGenerateRoute: AppRouteGenerator.generateRoute,
        // ────────────────────────────────────
      ),
    );
  }
}