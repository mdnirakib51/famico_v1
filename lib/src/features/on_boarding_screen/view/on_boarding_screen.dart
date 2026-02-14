
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../global/constants/colors_resources.dart';
import '../../../global/constants/images.dart';
import '../../../global/global_widget/global_bottom_widget.dart';
import '../../../global/global_widget/global_image_loader.dart';
import '../../../global/global_widget/global_sized_box.dart';
import '../../../global/global_widget/global_text.dart';
import '../../../global/utils/navigation.dart';
import '../../../global/widget/container_space_background_widget.dart';
import '../../auth/login/view/login_screen.dart';
import '../bloc/on_boarding_bloc.dart';
import '../bloc/on_boarding_event.dart';
import '../bloc/on_boarding_state.dart';

class OnBoardModel {
  String? img;
  String? text;
  String? subText;

  OnBoardModel({required this.img, required this.text, required this.subText});
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with TickerProviderStateMixin {

  late PageController _pageController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  Map<String, List<OnBoardModel>> languageData = {
    'EN': [
      OnBoardModel(
          img: Images.onBoard3,
          text: "Welcome to Family Life",
          subText: "Stay connected with your family members and never miss important moments together."
      ),
      OnBoardModel(
          img: Images.onBoard1,
          text: "Stay Updated",
          subText: "Get instant notifications about family events, schedules, and important announcements."
      ),
      OnBoardModel(
          img: Images.onBoard2,
          text: "Track Family Activities",
          subText: "Monitor your family's daily activities, expenses, and shared responsibilities easily."
      ),
    ],
    'BN': [
      OnBoardModel(
          img: Images.onBoard3,
          text: "পারিবারিক জীবনে স্বাগতম",
          subText: "আপনার পরিবারের সদস্যদের সাথে সংযুক্ত থাকুন এবং গুরুত্বপূর্ণ মুহূর্তগুলি মিস করবেন না।"
      ),
      OnBoardModel(
          img: Images.onBoard1,
          text: "আপডেট থাকুন",
          subText: "পারিবারিক ইভেন্ট, সময়সূচী এবং গুরুত্বপূর্ণ ঘোষণা সম্পর্কে তাৎক্ষণিক বিজ্ঞপ্তি পান।"
      ),
      OnBoardModel(
          img: Images.onBoard2,
          text: "পারিবারিক কার্যক্রম ট্র্যাক করুন",
          subText: "আপনার পরিবারের দৈনন্দিন কার্যক্রম, খরচ এবং ভাগ করা দায়িত্বগুলি সহজেই পর্যবেক্ষণ করুন।"
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);

    // Enhanced floating animation with different curves
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _floatingAnimation = Tween<double>(
      begin: -15,
      end: 15,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOutSine,
    ));

    // Enhanced pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.7,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutCubic,
    ));

    // Start all animations
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<OnBoardModel> getImages(String language) {
    return languageData[language] ?? languageData['EN']!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingBloc(),
      child: BlocListener<OnBoardingBloc, OnBoardingState>(
        listener: (context, state) {
          if (state.status == OnBoardingStatus.navigating) {
            navigateAndRemoveAll(context, LoginScreen());
          }
        },
        child: BlocBuilder<OnBoardingBloc, OnBoardingState>(
          builder: (context, state) {
            final images = getImages(state.selectedLanguage);

            return Scaffold(
              backgroundColor: ColorRes.appBackColor,
              body: ContainerSpaceBackWidget(
                child: SizedBox(
                  child: Column(
                    children: [
                      sizedBoxH(30),

                      // Language toggle
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<OnBoardingBloc>().add(
                                    LanguageChanged('EN')
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6
                                ),
                                decoration: BoxDecoration(
                                  color: state.selectedLanguage == 'EN'
                                      ? ColorRes.appColor
                                      : Colors.grey.withValues(alpha: 0.2),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                  ),
                                ),
                                child: GlobalText(
                                  str: 'EN',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: state.selectedLanguage == 'EN'
                                      ? Colors.white
                                      : ColorRes.appColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<OnBoardingBloc>().add(
                                    LanguageChanged('BN')
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6
                                ),
                                decoration: BoxDecoration(
                                  color: state.selectedLanguage == 'BN'
                                      ? ColorRes.appColor
                                      : Colors.grey.withValues(alpha: 0.2),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                child: GlobalText(
                                  str: 'BN',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: state.selectedLanguage == 'BN'
                                      ? Colors.white
                                      : ColorRes.appColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: SizedBox(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              context.read<OnBoardingBloc>().add(
                                  PageChanged(index)
                              );
                            },
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _floatingAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatingAnimation.value * 0.5),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Image Container with enhanced styling
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.35,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: GlobalImageLoader(
                                                imagePath: images[index].img ?? '',
                                                fit: BoxFit.fitWidth,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 30),

                                          // Main Title Text
                                          GlobalText(
                                            str: images[index].text ?? '',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                            color: ColorRes.appColor,
                                          ),

                                          const SizedBox(height: 10),

                                          // Subtitle Text
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: GlobalText(
                                              str: images[index].subText ?? '',
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      // Page Indicators
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                                (index) => AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                bool isCurrentPage = index == state.currentPageIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: isCurrentPage
                                      ? 14 + (_pulseAnimation.value * 3)
                                      : 6,
                                  height: isCurrentPage
                                      ? 4 + (_pulseAnimation.value * 3)
                                      : 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: isCurrentPage
                                        ? ColorRes.appColor
                                        : Colors.grey.withValues(alpha: 0.5),
                                    boxShadow: isCurrentPage ? [
                                      BoxShadow(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ] : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      GlobalButtonWidget(
                        str: state.currentPageIndex == images.length - 1
                            ? (state.selectedLanguage == 'EN' ? "Get Started" : "শুরু করুন")
                            : (state.selectedLanguage == 'EN' ? "Next" : "পরবর্তী"),
                        radius: 8,
                        height: 42,
                        textSize: 14,
                        horizontal: 20,
                        buttomColor: ColorRes.appColor,
                        onTap: () {
                          if (state.currentPageIndex < images.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            context.read<OnBoardingBloc>().add(GetStartedPressed());
                          }
                        },
                      ),

                      sizedBoxH(20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}