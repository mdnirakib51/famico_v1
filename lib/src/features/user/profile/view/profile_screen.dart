import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/widget/container_space_background_widget.dart';
import '../../data/model/profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.failure &&
            state.errorMessage != null) {
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
          backgroundColor: ColorRes.appBackColor,
          appBar: AppBar(
            backgroundColor: ColorRes.appColor,
            title: const GlobalText(
              str: 'My Profile',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorRes.white,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: ColorRes.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ProgressHUD(
            inAsyncCall: state.status == ProfileStatus.loading,
            child: state.status == ProfileStatus.success &&
                state.profileModel?.profile != null
                ? _buildProfileContent(state.profileModel!.profile!)
                : state.status == ProfileStatus.failure
                ? _buildErrorWidget(state.errorMessage)
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(Profile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar & Name ──────────────────────────────────────────
          Center(
            child: Column(
              children: [
                sizedBoxH(20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: ColorRes.appColor.withOpacity(0.15),
                  backgroundImage: profile.image != null && profile.image!.isNotEmpty
                      ? NetworkImage(profile.image!)
                      : null,
                  child: profile.image == null || profile.image!.isEmpty
                      ? const Icon(Icons.person, size: 50, color: ColorRes.appColor)
                      : null,
                ),
                sizedBoxH(12),
                GlobalText(
                  str: profile.name ?? '—',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: ColorRes.black,
                ),
                sizedBoxH(4),
                GlobalText(
                  str: profile.email ?? '—',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ColorRes.grey,
                ),
                sizedBoxH(20),
              ],
            ),
          ),

          // ── Personal Info Card ────────────────────────────────────
          _sectionCard(
            title: 'Personal Information',
            icon: Icons.person_outline,
            children: [
              _infoRow(Icons.badge_outlined, 'User ID', '${profile.id ?? '—'}'),
              _infoRow(Icons.phone_outlined, 'Phone', profile.phone ?? '—'),
              _infoRow(Icons.cake_outlined, 'Date of Birth', profile.dob ?? '—'),
              _infoRow(Icons.numbers_outlined, 'Age', '${profile.age ?? '—'}'),
              // _infoRow(Icons.credit_card_outlined, 'NID', profile.nid ?? '—'),
            ],
          ),

          sizedBoxH(16),

          // ── Account Info Card ─────────────────────────────────────
          if (profile.authEntity != null)
            _sectionCard(
              title: 'Account Information',
              icon: Icons.manage_accounts_outlined,
              children: [
                _infoRow(Icons.person_pin_outlined, 'Username',
                    profile.authEntity!.username ?? '—'),
                _infoRow(Icons.email_outlined, 'Email',
                    profile.authEntity!.email ?? '—'),
                _infoRow(Icons.phone_android_outlined, 'Phone',
                    profile.authEntity!.phone ?? '—'),
                _infoRow(Icons.access_time_outlined, 'Last Login',
                    profile.lastLogin ?? '—'),
              ],
            ),

          sizedBoxH(16),

          // ── Present Address Card ──────────────────────────────────
          if (profile.presentAddress != null)
            _sectionCard(
              title: 'Present Address',
              icon: Icons.location_on_outlined,
              children: [
                _infoRow(Icons.signpost_outlined, 'Street',
                    profile.presentAddress!.street ?? '—'),
                _infoRow(Icons.location_city_outlined, 'City',
                    profile.presentAddress!.city ?? '—'),
                _infoRow(Icons.map_outlined, 'State',
                    profile.presentAddress!.state ?? '—'),
                _infoRow(Icons.flag_outlined, 'Country',
                    profile.presentAddress!.country ?? '—'),
                _infoRow(Icons.local_post_office_outlined, 'ZIP',
                    profile.presentAddress!.zip ?? '—'),
              ],
            ),

          sizedBoxH(16),

          // ── Permanent Address Card ────────────────────────────────
          if (profile.permanentAddress != null)
            _sectionCard(
              title: 'Permanent Address',
              icon: Icons.home_outlined,
              children: [
                _infoRow(Icons.signpost_outlined, 'Street',
                    profile.permanentAddress!.street ?? '—'),
                _infoRow(Icons.location_city_outlined, 'City',
                    profile.permanentAddress!.city ?? '—'),
                _infoRow(Icons.map_outlined, 'State',
                    profile.permanentAddress!.state ?? '—'),
                _infoRow(Icons.flag_outlined, 'Country',
                    profile.permanentAddress!.country ?? '—'),
                _infoRow(Icons.local_post_office_outlined, 'ZIP',
                    profile.permanentAddress!.zip ?? '—'),
              ],
            ),

          sizedBoxH(30),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ColorRes.appColor.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: ColorRes.appColor, size: 20),
                sizedBoxW(8),
                GlobalText(
                  str: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ColorRes.appColor,
                ),
              ],
            ),
          ),
          // Rows
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: ColorRes.grey),
          sizedBoxW(10),
          Expanded(
            flex: 2,
            child: GlobalText(
              str: label,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColorRes.grey,
            ),
          ),
          const GlobalText(
            str: ':',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: ColorRes.grey,
          ),
          sizedBoxW(8),
          Expanded(
            flex: 3,
            child: GlobalText(
              str: value,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ColorRes.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          sizedBoxH(16),
          GlobalText(
            str: message ?? 'Something went wrong',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ColorRes.grey,
          ),
          sizedBoxH(20),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<ProfileBloc>().add(FetchUserProfile()),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.appColor,
              foregroundColor: ColorRes.white,
            ),
          ),
        ],
      ),
    );
  }
}