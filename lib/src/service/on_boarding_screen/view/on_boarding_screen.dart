
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../global/constants/colors_resources.dart';
import '../../../global/constants/images.dart';
import '../../../global/global_widget/global_bottom_widget.dart';
import '../../../global/global_widget/global_text.dart';
import '../../../global/utils/navigation.dart';
import '../../auth/login/view/login_screen.dart';
import '../bloc/on_boarding_bloc.dart';
import '../bloc/on_boarding_event.dart';
import '../bloc/on_boarding_state.dart';

class OnBoardModel {
  String? text;
  String? subText;

  OnBoardModel({required this.text, required this.subText});
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late PageController _pageController;
  bool _isAnimating = false;

  List<OnBoardModel> images = [
    OnBoardModel(
      text: "Smart Fish Farming",
      subText: "Monitor your ponds in real-time and manage everything from one smart dashboard.",
    ),
    OnBoardModel(
      text: "Stay Notified",
      subText: "Receive instant alerts about water quality, feeding schedules, weather changes and more.",
    ),
    OnBoardModel(
      text: "Track Farm Performance",
      subText: "Analyze daily reports, farm growth and performance insights to maximize productivity.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingBloc(),
      child: BlocListener<OnBoardingBloc, OnBoardingState>(
        listener: (context, state) {
          if (state.status == OnBoardingStatus.navigating) {
            navigateAndRemoveAll(context, LoginScreen());
            return;
          }

          // Only animate if it's auto-slide and not already animating
          if (state.shouldAnimateToPage && _pageController.hasClients && !_isAnimating) {
            _isAnimating = true;
            _pageController.animateToPage(
              state.currentPageIndex,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            ).then((_) {
              _isAnimating = false;
            });
          }
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.onBoardBackImg),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
              ),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Content Area (Text Only)
                      Expanded(
                        child: BlocBuilder<OnBoardingBloc, OnBoardingState>(
                          builder: (context, state) {
                            return PageView.builder(
                              controller: _pageController,
                              itemCount: images.length,
                              physics: ClampingScrollPhysics(),
                              onPageChanged: (index) {
                                // Update state when user manually swipes
                                if (!_isAnimating) {
                                  context.read<OnBoardingBloc>().add(PageChanged(index));
                                }
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 24, right: 24, top: 100),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Title Text at Top
                                      GlobalText(
                                        str: images[index].text ?? '',
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.center,
                                        color: ColorRes.white,
                                      ),

                                      SizedBox(height: 20),

                                      // Subtitle Text
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: GlobalText(
                                          str: images[index].subText ?? '',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          textAlign: TextAlign.center,
                                          maxLines: 4,
                                          color: ColorRes.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // Page Indicators
                      BlocBuilder<OnBoardingBloc, OnBoardingState>(
                        builder: (context, state) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(images.length, (index) => AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                width: index == state.currentPageIndex ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: index == state.currentPageIndex
                                      ? ColorRes.teal
                                      : ColorRes.white.withValues(alpha: 0.4),
                                ),
                              )),
                            ),
                          );
                        },
                      ),

                      // Get Started Button at Bottom
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 30),
                        child: BlocBuilder<OnBoardingBloc, OnBoardingState>(
                          builder: (context, state) {
                            return GlobalButtonWidget(
                              str: "Get Started",
                              radius: 30,
                              height: 56,
                              textSize: 16,
                              buttomColor: ColorRes.teal,
                              onTap: () {
                                context.read<OnBoardingBloc>().add(GetStartedPressed());
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}