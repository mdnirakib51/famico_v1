
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'service/auth/login/bloc/login_bloc.dart';
import 'service/on_boarding_screen/bloc/on_boarding_bloc.dart';
import 'service/splash_screen/bloc/splash_bloc.dart';
import 'service/splash_screen/view/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashBloc()),
        BlocProvider(create: (_) => OnBoardingBloc()),
        BlocProvider(create: (_) => LoginBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}