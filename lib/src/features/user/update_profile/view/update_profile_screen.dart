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
  final UserInfo profile;

  const UpdateProfileScreen({super.key, required this.profile});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _ageController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();

  // Dropdown values
  String _selectedDialCode = '+880';
  String? _selectedGender;

  static const List<String> _dialCodes = ['+880', '+91', '+1', '+44', '+61'];
  static const List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.details?.name ?? '');
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _dobController = TextEditingController(text: widget.profile.details?.dob ?? '');
    _ageController = TextEditingController(text: widget.profile.details?.age?.toString() ?? '');

    // Pre-fill gender if exists
    final existingGender = widget.profile.details?.gender;
    if (existingGender != null && _genderOptions.contains(existingGender)) {
      _selectedGender = existingGender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _ageFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender'), backgroundColor: Colors.red),
        );
        return;
      }
      context.read<UpdateProfileBloc>().add(
        UpdateProfileSubmitted(
          name: _nameController.text.trim(),
          dialCode: _selectedDialCode,
          phone: _phoneController.text.trim(),
          gender: _selectedGender!,
          dob: _dobController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
        ),
      );
    }
  }

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
      // ISO 8601 format — API এর dob format অনুযায়ী
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}T00:00:00.000Z';
      _dobController.text = formatted;

      // Auto-calculate age
      final now = DateTime.now();
      int age = now.year - picked.year;
      if (now.month < picked.month ||
          (now.month == picked.month && now.day < picked.day)) {
        age--;
      }
      _ageController.text = age.toString();

      context.read<UpdateProfileBloc>()..add(
          UpdateProfileFieldChanged(field: UpdateProfileField.dob, value: formatted))
        ..add(UpdateProfileFieldChanged(
            field: UpdateProfileField.age, value: age));
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
          appBar: GlobalAppBar(title: 'Update Profile'),
          body: ProgressHUD(
            inAsyncCall: state.status == UpdateProfileStatus.loading,
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Avatar ──────────────────────────────────
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor:
                            ColorRes.appColor.withOpacity(0.15),
                            backgroundImage: (widget.profile.details?.image
                                ?.isNotEmpty ??
                                false)
                                ? NetworkImage(
                                widget.profile.details!.image!)
                                : null,
                            child: (widget.profile.details?.image
                                ?.isEmpty ??
                                true)
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
                                border: Border.all(
                                    color: ColorRes.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 14, color: ColorRes.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    sizedBoxH(28),

                    // ── Username (read-only) ─────────────────────
                    GlobalTextFormField(
                      controller: TextEditingController(
                          text: widget.profile.username ?? ''),
                      titleText: 'Username',
                      hintText: 'Username',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.grey.withOpacity(0.15),
                      enabled: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),

                    sizedBoxH(12),

                    // ── Email (read-only) ────────────────────────
                    GlobalTextFormField(
                      controller: TextEditingController(
                          text: widget.profile.email ?? ''),
                      titleText: 'Email',
                      hintText: 'Email',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.grey.withOpacity(0.15),
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),

                    sizedBoxH(12),

                    // ── Full Name ────────────────────────────────
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
                      onChanged: (val) =>
                          context.read<UpdateProfileBloc>().add(
                            UpdateProfileFieldChanged(
                                field: UpdateProfileField.name,
                                value: val),
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

                    // ── Dial Code + Phone ────────────────────────
                    GlobalText(
                      str: 'Phone Number',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ColorRes.black,
                    ),
                    sizedBoxH(6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dial Code Dropdown
                        Container(
                          height: 50,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: ColorRes.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: ColorRes.grey.withOpacity(0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDialCode,
                              items: _dialCodes
                                  .map((code) => DropdownMenuItem(
                                value: code,
                                child: Text(code,
                                    style: const TextStyle(
                                        fontSize: 14)),
                              ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedDialCode = val);
                                  context
                                      .read<UpdateProfileBloc>()
                                      .add(UpdateProfileFieldChanged(
                                    field: UpdateProfileField.dialCode,
                                    value: val,
                                  ));
                                }
                              },
                            ),
                          ),
                        ),

                        sizedBoxW(8),

                        // Phone Number
                        Expanded(
                          child: GlobalTextFormField(
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            hintText: 'Phone Number',
                            decoration: glassInputDecoration,
                            filled: true,
                            fillColor: ColorRes.white,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onChanged: (val) =>
                                context.read<UpdateProfileBloc>().add(
                                  UpdateProfileFieldChanged(
                                      field: UpdateProfileField.phone,
                                      value: val),
                                ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Phone is required';
                              }
                              if (val.length < 10) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    sizedBoxH(12),

                    // ── Gender Dropdown ──────────────────────────
                    GlobalText(
                      str: 'Gender',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ColorRes.black,
                    ),
                    sizedBoxH(6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: ColorRes.grey.withOpacity(0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGender,
                          hint: const Text(
                            'Select Gender',
                            style: TextStyle(
                                color: ColorRes.grey, fontSize: 14),
                          ),
                          isExpanded: true,
                          items: _genderOptions
                              .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g),
                          ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedGender = val);
                              context.read<UpdateProfileBloc>().add(
                                UpdateProfileFieldChanged(
                                    field: UpdateProfileField.gender,
                                    value: val),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    sizedBoxH(12),

                    // ── Date of Birth ────────────────────────────
                    GlobalTextFormField(
                      controller: _dobController,
                      titleText: 'Date of Birth',
                      hintText: 'Select Date of Birth',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      readOnly: true,
                      suffixIcon: GestureDetector(
                        onTap: () => _pickDate(context),
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

                    // ── Age (auto-filled) ────────────────────────
                    GlobalTextFormField(
                      controller: _ageController,
                      focusNode: _ageFocus,
                      titleText: 'Age',
                      hintText: 'Age',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.grey.withOpacity(0.1),
                      enabled: false, // DOB থেকে auto-calculate হবে
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Age is required';
                        }
                        return null;
                      },
                    ),

                    sizedBoxH(32),

                    // ── Submit ───────────────────────────────────
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