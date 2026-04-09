import 'package:famico_v1/src/features/address/view/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/routes/app_navigator.dart';
import '../../app/routes/app_route.dart';
import '../../core_functionality/constants/image_url_helper.dart';
import '../../global/constants/colors_resources.dart';
import '../../global/global_widget/global_image_loader.dart';
import '../../global/global_widget/global_progress_hub.dart';
import '../../global/global_widget/global_sized_box.dart';
import '../../global/global_widget/global_text.dart';
import '../auth/data/repositories/auth_service.dart';
import 'profile/bloc/profile_bloc.dart';
import 'profile/bloc/profile_event.dart';
import 'profile/bloc/profile_state.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profileModel?.user;
        final topPadding = MediaQuery.of(context).padding.top;

        return Scaffold(
          backgroundColor: ColorRes.white,
          body: ProgressHUD(
            inAsyncCall: state.status == ProfileStatus.loading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Cover + Avatar overlap ─────────────────────────────────
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Cover

                      SizedBox(height: 200, width: size(context).width),
                      Container(
                        height: 120 + topPadding,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorRes.appColor,
                              ColorRes.appColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),

                      // Avatar — overlapping the cover bottom
                      Positioned(
                        bottom: 10,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 1),
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: ImageUrlHelper.isValid(profile?.details?.image)
                                ? GlobalImageLoader(
                              imagePath: ImageUrlHelper.resolve(profile?.details?.image),
                              imageFor: ImageFor.network,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                                : const Icon(
                              Icons.person,
                              size: 48,
                              color: ColorRes.appColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  GlobalText(
                    str: profile?.details?.name ?? '—',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorRes.appColor,
                  ),


                  sizedBoxH(20),
                  // ── Menu Items ─────────────────────────────────────────────
                  _ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile Information',
                    onTap: () => AppNavigator.push(context, AppRouteKeys.profile),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    onTap: () => AppNavigator.push(context, AppRouteKeys.address),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Family Name',
                    onTap: () => AppNavigator.push(context, AppRouteKeys.familyName),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () => AppNavigator.push(context, AppRouteKeys.changePass),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About Us',
                    onTap: () {},
                  ),

                  _ProfileMenuItem(
                    icon: Icons.delete_outline_rounded,
                    title: 'Delete Account',
                    onTap: () {},
                    isDestructive: true,
                  ),

                  // ── Log Out ────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () => _showLogoutDialog(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: ColorRes.appColor,
                            size: 18,
                          ),
                          sizedBoxW(8),
                          GlobalText(
                            str: 'Log Out',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorRes.appColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  sizedBoxH(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Logout Dialog ───────────────────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const GlobalText(
          str: 'Log Out',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ColorRes.black,
        ),
        content: const GlobalText(
          str: 'Are you sure you want to log out?',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ColorRes.grey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const GlobalText(
              str: 'Cancel',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorRes.grey,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              AuthService.performLogout(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: ColorRes.appColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const GlobalText(
                str: 'Log Out',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single Menu Item ───────────────────────────────────────────────────────────
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFCC0000) : const Color(0xFF222222);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          splashColor: ColorRes.appColor.withOpacity(0.05),
          highlightColor: ColorRes.appColor.withOpacity(0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade100,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}