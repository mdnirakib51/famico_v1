import 'package:famico_v1/src/app/routes/app_navigator.dart';
import 'package:famico_v1/src/features/auth/data/repositories/auth_service.dart';
import 'package:flutter/material.dart';
import '../../app/routes/app_route.dart';
import '../constants/colors_resources.dart';
import '../global_widget/global_text.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({
    super.key,
    required this.title,
    this.isBackIc = true,
    this.centerTitle,
    this.titleColor,
    this.fontSize,
    this.fontWeight,
    this.backColor,
    this.notiOnTap,
    this.actions,
  });

  final String title;
  final Color? titleColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backColor;
  final bool? isBackIc;
  final bool? centerTitle;
  final Function()? notiOnTap;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backColor ?? ColorRes.appColor,
      automaticallyImplyLeading: false,
      leadingWidth: isBackIc == true ? 56 : 0,
      leading: isBackIc == true
          ? IconButton(
        splashRadius: 0.1,
        icon: const Icon(Icons.arrow_back, color: ColorRes.white, size: 22),
        onPressed: () {
          AuthService.performLogout();
          // AppNavigator.pop(context);
        },
      )
          : const SizedBox.shrink(),
      centerTitle: centerTitle,
      title: GlobalText(
        str: title,
        color: titleColor ?? ColorRes.white,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w500,
        textAlign: TextAlign.center,
        fontFamily: 'Rubik',
      ),
      actions: actions,
    );
  }
}