import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/components/global_appbar.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/constants/input_decoration.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/global_widget/global_textform_field.dart';
import '../../../../global/utils/navigation.dart';
import '../../data/model/profile_model.dart';
import '../bloc/update_profile_bloc.dart';
import '../bloc/update_profile_event.dart';
import '../bloc/update_profile_state.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserInfo profile; // pass existing profile to pre-fill

  const UpdateProfileScreen({super.key, required this.profile});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _ageController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing profile
    _nameController  = TextEditingController(text: widget.profile.details?.name ?? '');
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _emailController = TextEditingController(text: widget.profile.email ?? '');
    _dobController   = TextEditingController(text: widget.profile.details?.dob ?? '');
    _ageController   = TextEditingController(
      text: widget.profile?.details?.age != null ? widget.profile.details?.age.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _dobFocus.dispose();
    _ageFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<UpdateProfileBloc>().add(
        UpdateProfileSubmitted(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          dob: _dobController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
        ),
      );
    }
  }

  /// Date picker for DOB field
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(_dobController.text) ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: ColorRes.appColor),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _dobController.text = formatted;

      // Auto-calculate age
      final age = DateTime.now().year - picked.year;
      _ageController.text = age.toString();

      context.read<UpdateProfileBloc>().add(
        UpdateProfileFieldChanged(field: UpdateProfileField.dob, value: formatted),
      );
      context.read<UpdateProfileBloc>().add(
        UpdateProfileFieldChanged(field: UpdateProfileField.age, value: age),
      );
    }
  }

  DateTime? _parseDate(String text) {
    try {
      return DateTime.parse(text);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state.status == UpdateProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          goBack(context);
        }

        if (state.status == UpdateProfileStatus.failure &&
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
          resizeToAvoidBottomInset: true,
          backgroundColor: ColorRes.appBackColor,
          appBar: GlobalAppBar(
            title: 'Update Profile',
          ),
          body: ProgressHUD(
            inAsyncCall: state.status == UpdateProfileStatus.loading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Avatar ──────────────────────────────────────
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: ColorRes.appColor.withOpacity(0.15),
                            backgroundImage: widget.profile.details?.image != null &&
                                (widget.profile.details?.image?.isNotEmpty ?? false)
                                ? NetworkImage(widget.profile.details?.image ?? '')
                                : null,
                            child: widget.profile.details?.image == null ||
                                (widget.profile.details?.image?.isEmpty ?? true)
                                ? const Icon(Icons.person,
                                size: 48, color: ColorRes.appColor)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: ColorRes.appColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: ColorRes.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 14, color: ColorRes.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    sizedBoxH(28),

                    // ── Full Name ────────────────────────────────────
                    GlobalTextFormField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      titleText: 'Full Name',
                      hintText: 'Enter Your Full Name',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) => context.read<UpdateProfileBloc>().add(
                        UpdateProfileFieldChanged(
                            field: UpdateProfileField.name, value: val),
                      ),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_phoneFocus),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(12),

                    // ── Phone ────────────────────────────────────────
                    GlobalTextFormField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      titleText: 'Phone Number',
                      hintText: 'Enter Your Phone Number',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) => context.read<UpdateProfileBloc>().add(
                        UpdateProfileFieldChanged(
                            field: UpdateProfileField.phone, value: val),
                      ),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (val.length < 10) return 'Enter a valid phone number';
                        return null;
                      },
                    ),

                    sizedBoxH(12),

                    // ── Email ────────────────────────────────────────
                    GlobalTextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      titleText: 'Email',
                      hintText: 'Enter Your Email',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.grey.withValues(alpha: 0.2),
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (val) => context.read<UpdateProfileBloc>().add(
                        UpdateProfileFieldChanged(
                            field: UpdateProfileField.email, value: val),
                      ),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_dobFocus),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Email is required';
                        final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(val)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(12),

                    // ── Date of Birth (Date Picker) ──────────────────
                    GlobalTextFormField(
                      controller: _dobController,
                      focusNode: _dobFocus,
                      titleText: 'Date of Birth',
                      hintText: 'YYYY-MM-DD',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      readOnly: true,
                      sufixIcon: GestureDetector(
                        onTap: (){
                          _pickDate(context);
                        },
                        child: const Icon(Icons.calendar_today,
                            size: 18, color: ColorRes.grey),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Date of birth is required';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(12),

                    // ── Age (auto-filled, editable) ──────────────────
                    GlobalTextFormField(
                      controller: _ageController,
                      focusNode: _ageFocus,
                      titleText: 'Age',
                      hintText: 'Age',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) {
                        final age = int.tryParse(val);
                        if (age != null) {
                          context.read<UpdateProfileBloc>().add(
                            UpdateProfileFieldChanged(
                                field: UpdateProfileField.age, value: age),
                          );
                        }
                      },
                      onFieldSubmitted: (_) => _submit(context),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Age is required';
                        }
                        if (int.tryParse(val) == null) {
                          return 'Enter a valid age';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(32),

                    // ── Submit Button ────────────────────────────────
                    GlobalButtonWidget(
                      str: 'UPDATE PROFILE',
                      height: 45,
                      buttomColor: ColorRes.appColor,
                      onTap: () => _submit(context),
                    ),

                    sizedBoxH(30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}