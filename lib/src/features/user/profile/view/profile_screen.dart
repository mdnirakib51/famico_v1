
import 'dart:io';
import 'package:famico_v1/src/global/components/global_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core_functionality/constants/image_url_helper.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/global_widget/auth_netword_image.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_image_loader.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/utils/navigation.dart';
import '../../data/model/profile_model.dart';
import '../../update_profile/bloc/update_profile_bloc.dart';
import '../../upload_doc/bloc/upload_doc_bloc.dart';
import '../../upload_doc/bloc/upload_doc_event.dart';
import '../../upload_doc/bloc/upload_doc_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../update_profile/view/update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserProfile());
  }

  // ── Image picker helpers ───────────────────────────────────────────────────

  Future<void> _pickProfileImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null && mounted) {
      context.read<UploadDocBloc>().add(UploadDocImagePicked(file));
    }
  }

  Future<void> _pickNidImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null && mounted) {
      context.read<UploadDocBloc>().add(UploadDocNidPicked(file));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, profileState) {
        final profile = profileState.profileModel?.profile;

        return Scaffold(
          backgroundColor: ColorRes.appBackColor,
          appBar: GlobalAppBar(
            title: 'My Profile',
            actions: [
              // ── Edit Button ──
              if (profileState.status == ProfileStatus.success && profile != null)
                GestureDetector(
                  onTap: () {
                    navigateTo(context, BlocProvider(create: (_) => UpdateProfileBloc(), child: UpdateProfileScreen(profile: profile)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: ColorRes.white),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined, color: ColorRes.white, size: 14),
                        sizedBoxW(3),
                        GlobalText(
                          str: "Edit Profile",
                          color: ColorRes.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                sizedBoxW(10),
            ],
          ),
          body: ProgressHUD(
            inAsyncCall: profileState.status == ProfileStatus.loading,
            child: profileState.status == ProfileStatus.success && profile != null
                ? _buildContent(context, profile)
                : profileState.status == ProfileStatus.failure
                ? _buildErrorWidget(profileState.errorMessage)
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  // ── Main content ───────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, Profile profile) {
    return BlocConsumer<UploadDocBloc, UploadDocState>(
      listener: (context, state) {
        if (state.status == UploadDocStatus.success) {
          // Refresh profile after upload
          context.read<ProfileBloc>().add(FetchUserProfile());
        }
        if (state.status == UploadDocStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, uploadState) {
        return ProgressHUD(
          inAsyncCall: uploadState.status == UploadDocStatus.loading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ──────────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      sizedBoxH(20),
                      Stack(
                        children: [
                          // GlobalImageLoader(
                          //   imagePath: ImageUrlHelper.resolve(profile.image),
                          //   imageFor: ImageFor.network,
                          //   height: 50,
                          //   width: 50,
                          //   // headers: _authHeaders(),
                          // ),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: ColorRes.appColor.withOpacity(0.15),
                            backgroundImage: uploadState.image != null
                                ? FileImage(File(uploadState.image!.path))
                                :  AuthNetworkImage.provider(profile.image),
                            child: (uploadState.image == null &&
                                !ImageUrlHelper.isValid(profile.image))
                                ? const Icon(Icons.person, size: 50, color: ColorRes.appColor)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickProfileImage,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: ColorRes.appColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: ColorRes.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, size: 14, color: ColorRes.white),
                              ),
                            ),
                          ),
                        ],
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

                // ── Personal Info ────────────────────────────────────────────
                _sectionCard(
                  title: 'Personal Information',
                  icon: Icons.person_outline,
                  children: [
                    _infoRow(Icons.badge_outlined, 'User ID', '${profile.id ?? '—'}'),
                    _infoRow(Icons.phone_outlined, 'Phone', profile.phone ?? '—'),
                    _infoRow(Icons.cake_outlined, 'Date of Birth', profile.dob ?? '—'),
                    _infoRow(Icons.numbers_outlined, 'Age', '${profile.age ?? '—'}'),
                  ],
                ),

                sizedBoxH(16),

                // ── Account Info ─────────────────────────────────────────────
                if (profile.authEntity != null)
                  _sectionCard(
                    title: 'Account Information',
                    icon: Icons.manage_accounts_outlined,
                    children: [
                      _infoRow(Icons.person_pin_outlined, 'Username', profile.authEntity!.username ?? '—'),
                      _infoRow(Icons.email_outlined, 'Email', profile.authEntity!.email ?? '—'),
                      _infoRow(Icons.phone_android_outlined, 'Phone', profile.authEntity!.phone ?? '—'),
                      _infoRow(Icons.access_time_outlined, 'Last Login', profile.lastLogin ?? '—'),
                    ],
                  ),

                sizedBoxH(16),

                // ── Present Address ──────────────────────────────────────────
                if (profile.presentAddress != null)
                  _sectionCard(
                    title: 'Present Address',
                    icon: Icons.location_on_outlined,
                    children: [
                      _infoRow(Icons.signpost_outlined, 'Street', profile.presentAddress!.street ?? '—'),
                      _infoRow(Icons.location_city_outlined, 'City', profile.presentAddress!.city ?? '—'),
                      _infoRow(Icons.map_outlined, 'State', profile.presentAddress!.state ?? '—'),
                      _infoRow(Icons.flag_outlined, 'Country', profile.presentAddress!.country ?? '—'),
                      _infoRow(Icons.local_post_office_outlined, 'ZIP', profile.presentAddress!.zip ?? '—'),
                    ],
                  ),

                sizedBoxH(16),

                // ── Permanent Address ────────────────────────────────────────
                if (profile.permanentAddress != null)
                  _sectionCard(
                    title: 'Permanent Address',
                    icon: Icons.home_outlined,
                    children: [
                      _infoRow(Icons.signpost_outlined, 'Street', profile.permanentAddress!.street ?? '—'),
                      _infoRow(Icons.location_city_outlined, 'City', profile.permanentAddress!.city ?? '—'),
                      _infoRow(Icons.map_outlined, 'State', profile.permanentAddress!.state ?? '—'),
                      _infoRow(Icons.flag_outlined, 'Country', profile.permanentAddress!.country ?? '—'),
                      _infoRow(Icons.local_post_office_outlined, 'ZIP', profile.permanentAddress!.zip ?? '—'),
                    ],
                  ),

                sizedBoxH(16),

                // ── Upload Documents Card ────────────────────────────────────
                _sectionCard(
                  title: 'Documents',
                  icon: Icons.upload_file_outlined,
                  children: [
                    // Profile Image row
                    _docPickerRow(
                      context: context,
                      icon: Icons.person_outline,
                      label: 'Profile Photo',
                      pickedFile: uploadState.image,
                      onTap: _pickProfileImage,
                    ),

                    const Divider(height: 1, indent: 16, endIndent: 16),

                    // NID row
                    _docPickerRow(
                      context: context,
                      icon: Icons.credit_card_outlined,
                      label: 'NID / Identity Card',
                      pickedFile: uploadState.nid,
                      onTap: _pickNidImage,
                    ),

                    // Upload button — shown when at least one file is selected
                    if (uploadState.image != null || uploadState.nid != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: GlobalButtonWidget(
                          str: 'UPLOAD DOCUMENTS',
                          height: 42,
                          buttomColor: ColorRes.appColor,
                          onTap: () {
                            context.read<UploadDocBloc>().add(UploadDocSubmitted());
                          },
                        ),
                      ),
                  ],
                ),


                sizedBoxH(20),
                GestureDetector(
                  onTap: () => _showLogoutDialog(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                        sizedBoxW(10),
                        GlobalText(
                          str: 'Logout',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                sizedBoxH(30),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Doc picker row ─────────────────────────────────────────────────────────

  Widget _docPickerRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required XFile? pickedFile,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorRes.grey),
          sizedBoxW(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  str: label,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ColorRes.grey,
                ),
                if (pickedFile != null)
                  GlobalText(
                    str: pickedFile.name,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorRes.appColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: ColorRes.appColor.withOpacity(0.3)),
              ),
              child: GlobalText(
                str: pickedFile != null ? 'Change' : 'Select',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ColorRes.appColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section card ───────────────────────────────────────────────────────────

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // ── Info row ───────────────────────────────────────────────────────────────

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
          const GlobalText(str: ':', fontSize: 13, fontWeight: FontWeight.w500, color: ColorRes.grey),
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

  // ── Error widget ───────────────────────────────────────────────────────────

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
            onPressed: () => context.read<ProfileBloc>().add(FetchUserProfile()),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red.shade600, size: 22),
            sizedBoxW(8),
            const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: ColorRes.grey, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: context.read<AuthBloc>().add(LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: ColorRes.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}