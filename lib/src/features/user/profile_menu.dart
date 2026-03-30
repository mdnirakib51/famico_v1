
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
        final profile = state.profileModel?.profile;

        return Scaffold(
          backgroundColor: ColorRes.appBackColor,
          body: ProgressHUD(
            inAsyncCall: state.status == ProfileStatus.loading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Cover + Avatar + Name ──────────────────────────────────
                  _buildHeader(context, state),

                  // ── Menu List ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _menuCard(
                          icon: Icons.person_outline_rounded,
                          title: 'My Profile',
                          subtitle: 'View and edit your personal info',
                          onTap: () {
                            AppNavigator.pushAndRemoveAll(context, AppRouteKeys.profile);
                          },
                        ),

                        sizedBoxH(12),

                        _menuCard(
                          icon: Icons.people_outline_rounded,
                          title: 'Family',
                          subtitle: 'Manage your family members',
                          onTap: () {
                            // TODO: navigate to Family screen
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, ProfileState state) {
    final profile = state.profileModel?.profile;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // ── Cover Image ──────────────────────────────────────────────────────
        Container(
          height: 180,
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
          child: ImageUrlHelper.isValid(profile?.image)
              ? GlobalImageLoader(
            imagePath: ImageUrlHelper.resolve(profile?.image),
            imageFor: ImageFor.network,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          )
              : null,
        ),

        // ── Dark overlay on cover ────────────────────────────────────────────
        Container(
          height: 180,
          width: double.infinity,
          color: Colors.black.withOpacity(0.25),
        ),

        // ── Avatar + Name (centered on cover bottom) ─────────────────────────
        Positioned(
          bottom: -50,
          child: Column(
            children: [
              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorRes.white, width: 3),
                  color: ColorRes.appColor.withOpacity(0.15),
                ),
                child: ClipOval(
                  child: ImageUrlHelper.isValid(profile?.image)
                      ? GlobalImageLoader(
                    imagePath: ImageUrlHelper.resolve(profile?.image),
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
            ],
          ),
        ),
      ],
    );
  }
}

// ── Spacer for avatar overlap + name section ────────────────────────────────
Widget _buildNameSection(ProfileState state) {
  final profile = state.profileModel?.profile;
  return Container(
    color: ColorRes.appBackColor,
    width: double.infinity,
    padding: const EdgeInsets.only(top: 60, bottom: 16),
    child: Column(
      children: [
        GlobalText(
          str: profile?.name ?? '—',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: ColorRes.black,
        ),
        sizedBoxH(4),
        GlobalText(
          str: profile?.email ?? '—',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: ColorRes.grey,
        ),
      ],
    ),
  );
}

// ── Menu Card ─────────────────────────────────────────────────────────────────
Widget _menuCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorRes.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ColorRes.appColor, size: 22),
          ),
          sizedBoxW(14),
          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  str: title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: ColorRes.black,
                ),
                sizedBoxH(2),
                GlobalText(
                  str: subtitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ColorRes.grey,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: ColorRes.grey),
        ],
      ),
    ),
  );
}