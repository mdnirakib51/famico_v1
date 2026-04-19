
// ── Create Family Member Bottom Sheet ─────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../global/constants/colors_resources.dart';
import '../../../../global/constants/input_decoration.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../../../global/global_widget/global_textform_field.dart';
import '../../data/model/family_name_model.dart';
import '../../family_name/bloc/family_name_bloc.dart';
import '../../family_name/bloc/family_name_state.dart';
import '../bloc/family_member_bloc.dart';
import '../bloc/family_member_event.dart';
import '../bloc/family_member_state.dart';

class CreateFamilyMemberSheet extends StatefulWidget {
  const CreateFamilyMemberSheet({super.key});

  @override
  State<CreateFamilyMemberSheet> createState() =>
      _CreateFamilyMemberSheetState();
}

class _CreateFamilyMemberSheetState
    extends State<CreateFamilyMemberSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // Present Address
  final _pStreetCtrl = TextEditingController();
  final _pCityCtrl = TextEditingController();
  final _pStateCtrl = TextEditingController();
  final _pZipCtrl = TextEditingController();
  final _pCountryCtrl = TextEditingController();

  // Permanent Address
  final _pmStreetCtrl = TextEditingController();
  final _pmCityCtrl = TextEditingController();
  final _pmStateCtrl = TextEditingController();
  final _pmZipCtrl = TextEditingController();
  final _pmCountryCtrl = TextEditingController();

  Families? _selectedFamily;
  String _selectedStatus = 'Live';
  bool _sameAsPresent = false;

  static const List<String> _statusOptions = ['Live', 'Deceased', 'Unknown'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _pStreetCtrl.dispose();
    _pCityCtrl.dispose();
    _pStateCtrl.dispose();
    _pZipCtrl.dispose();
    _pCountryCtrl.dispose();
    _pmStreetCtrl.dispose();
    _pmCityCtrl.dispose();
    _pmStateCtrl.dispose();
    _pmZipCtrl.dispose();
    _pmCountryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
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
      _dobCtrl.text =
      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}T00:00:00.000Z';
      setState(() {});
    }
  }

  void _copySameAsPresent() {
    _pmStreetCtrl.text = _pStreetCtrl.text;
    _pmCityCtrl.text = _pCityCtrl.text;
    _pmStateCtrl.text = _pStateCtrl.text;
    _pmZipCtrl.text = _pZipCtrl.text;
    _pmCountryCtrl.text = _pCountryCtrl.text;
  }

  void _submit() {
    if (_selectedFamily == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a family'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    context.read<FamilyMemberBloc>().add(
      FamilyMemberCreateSubmitted(
        familyId: int.parse(_selectedFamily!.id.toString()),
        name: _nameCtrl.text.trim(),
        dob: _dobCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty
            ? null
            : _emailCtrl.text.trim(),
        status: _selectedStatus,
        presentStreet: _pStreetCtrl.text.trim(),
        presentCity: _pCityCtrl.text.trim(),
        presentState: _pStateCtrl.text.trim(),
        presentZip: _pZipCtrl.text.trim(),
        presentCountry: _pCountryCtrl.text.trim(),
        permanentStreet: _pmStreetCtrl.text.trim(),
        permanentCity: _pmCityCtrl.text.trim(),
        permanentState: _pmStateCtrl.text.trim(),
        permanentZip: _pmZipCtrl.text.trim(),
        permanentCountry: _pmCountryCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilyMemberBloc, FamilyMemberState>(
      listenWhen: (prev, curr) =>
      prev.mutationStatus != curr.mutationStatus,
      listener: (context, state) {
        if (state.mutationStatus == FamilyMemberMutationStatus.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Family member added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state.mutationStatus == FamilyMemberMutationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.mutationError ?? 'Something went wrong'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<FamilyMemberBloc, FamilyMemberState>(
        builder: (context, memberState) {
          final isLoading = memberState.mutationStatus ==
              FamilyMemberMutationStatus.loading;

          return Container(
            decoration: const BoxDecoration(
              color: ColorRes.appBackColor,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ProgressHUD(
              inAsyncCall: isLoading,
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.92,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                builder: (_, scrollCtrl) => SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Handle ──
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: ColorRes.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        sizedBoxH(16),

                        // ── Title ──
                        const GlobalText(
                          str: 'Add Family Member',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        sizedBoxH(20),

                        // ── Family Dropdown ──
                        BlocBuilder<FamilyNameBloc, FamilyNameState>(
                          builder: (context, nameState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const GlobalText(
                                  str: 'Family',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                sizedBoxH(6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: ColorRes.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: ColorRes.grey
                                            .withOpacity(0.3)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Families>(
                                      value: _selectedFamily,
                                      isExpanded: true,
                                      hint: const Text(
                                        'Select Family',
                                        style: TextStyle(
                                            color: ColorRes.grey,
                                            fontSize: 14),
                                      ),
                                      items: nameState.families
                                          .map((f) => DropdownMenuItem(
                                        value: f,
                                        child: Text(
                                            f.name ?? '—'),
                                      ))
                                          .toList(),
                                      onChanged: (val) => setState(
                                              () => _selectedFamily = val),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        sizedBoxH(14),

                        // ── Basic Info ──
                        _buildField(
                          ctrl: _nameCtrl,
                          label: 'Full Name',
                          hint: 'Enter full name',
                          action: TextInputAction.next,
                          validator: (v) => (v?.isEmpty ?? true)
                              ? 'Name is required'
                              : null,
                        ),
                        sizedBoxH(12),

                        // DOB
                        GlobalTextFormField(
                          controller: _dobCtrl,
                          titleText: 'Date of Birth',
                          hintText: 'Select date of birth',
                          decoration: glassInputDecoration,
                          filled: true,
                          fillColor: ColorRes.white,
                          readOnly: true,
                          suffixIcon: GestureDetector(
                            onTap: _pickDob,
                            child: const Icon(Icons.calendar_today,
                                size: 18, color: ColorRes.grey),
                          ),
                          validator: (v) => (v?.isEmpty ?? true)
                              ? 'Date of birth is required'
                              : null,
                        ),
                        sizedBoxH(12),

                        _buildField(
                          ctrl: _phoneCtrl,
                          label: 'Phone',
                          hint: 'Enter phone number',
                          keyboard: TextInputType.phone,
                          action: TextInputAction.next,
                          validator: (v) => (v?.isEmpty ?? true)
                              ? 'Phone is required'
                              : null,
                        ),
                        sizedBoxH(12),

                        _buildField(
                          ctrl: _emailCtrl,
                          label: 'Email (optional)',
                          hint: 'Enter email address',
                          keyboard: TextInputType.emailAddress,
                          action: TextInputAction.next,
                        ),
                        sizedBoxH(12),

                        // Status Dropdown
                        const GlobalText(
                          str: 'Status',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        sizedBoxH(6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14),
                          decoration: BoxDecoration(
                            color: ColorRes.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: ColorRes.grey.withOpacity(0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedStatus,
                              isExpanded: true,
                              items: _statusOptions
                                  .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                                  .toList(),
                              onChanged: (val) => setState(
                                      () => _selectedStatus = val!),
                            ),
                          ),
                        ),
                        sizedBoxH(20),

                        // ── Present Address ──
                        const GlobalText(
                          str: 'Present Address',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        sizedBoxH(10),
                        _buildAddressFields(
                          streetCtrl: _pStreetCtrl,
                          cityCtrl: _pCityCtrl,
                          stateCtrl: _pStateCtrl,
                          zipCtrl: _pZipCtrl,
                          countryCtrl: _pCountryCtrl,
                        ),
                        sizedBoxH(16),

                        // ── Same as Present checkbox ──
                        Row(
                          children: [
                            Checkbox(
                              value: _sameAsPresent,
                              activeColor: ColorRes.appColor,
                              onChanged: (val) {
                                setState(
                                        () => _sameAsPresent = val ?? false);
                                if (val == true) _copySameAsPresent();
                              },
                            ),
                            const GlobalText(
                              str: 'Permanent same as present',
                              fontSize: 13,
                              color: ColorRes.grey,
                            ),
                          ],
                        ),
                        sizedBoxH(8),

                        // ── Permanent Address ──
                        const GlobalText(
                          str: 'Permanent Address',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        sizedBoxH(10),
                        _buildAddressFields(
                          streetCtrl: _pmStreetCtrl,
                          cityCtrl: _pmCityCtrl,
                          stateCtrl: _pmStateCtrl,
                          zipCtrl: _pmZipCtrl,
                          countryCtrl: _pmCountryCtrl,
                          readOnly: _sameAsPresent,
                        ),
                        sizedBoxH(28),

                        // ── Submit ──
                        GlobalButtonWidget(
                          str: 'ADD MEMBER',
                          height: 48,
                          buttomColor: ColorRes.appColor,
                          onTap: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Address Fields Helper ──
  Widget _buildAddressFields({
    required TextEditingController streetCtrl,
    required TextEditingController cityCtrl,
    required TextEditingController stateCtrl,
    required TextEditingController zipCtrl,
    required TextEditingController countryCtrl,
    bool readOnly = false,
  }) {
    return Column(
      children: [
        _buildField(
          ctrl: streetCtrl,
          label: 'Street',
          hint: 'Enter street',
          readOnly: readOnly,
          action: TextInputAction.next,
          validator: (v) =>
          (v?.isEmpty ?? true) ? 'Street is required' : null,
        ),
        sizedBoxH(10),
        Row(
          children: [
            Expanded(
              child: _buildField(
                ctrl: cityCtrl,
                label: 'City',
                hint: 'City',
                readOnly: readOnly,
                action: TextInputAction.next,
                validator: (v) =>
                (v?.isEmpty ?? true) ? 'Required' : null,
              ),
            ),
            sizedBoxW(10),
            Expanded(
              child: _buildField(
                ctrl: stateCtrl,
                label: 'State',
                hint: 'State',
                readOnly: readOnly,
                action: TextInputAction.next,
                validator: (v) =>
                (v?.isEmpty ?? true) ? 'Required' : null,
              ),
            ),
          ],
        ),
        sizedBoxH(10),
        Row(
          children: [
            Expanded(
              child: _buildField(
                ctrl: zipCtrl,
                label: 'ZIP',
                hint: 'ZIP code',
                readOnly: readOnly,
                keyboard: TextInputType.number,
                action: TextInputAction.next,
                validator: (v) =>
                (v?.isEmpty ?? true) ? 'Required' : null,
              ),
            ),
            sizedBoxW(10),
            Expanded(
              child: _buildField(
                ctrl: countryCtrl,
                label: 'Country',
                hint: 'Country',
                readOnly: readOnly,
                action: TextInputAction.next,
                validator: (v) =>
                (v?.isEmpty ?? true) ? 'Required' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Single Field Helper ──
  Widget _buildField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    TextInputAction action = TextInputAction.done,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return GlobalTextFormField(
      controller: ctrl,
      titleText: label,
      hintText: hint,
      decoration: glassInputDecoration,
      filled: true,
      fillColor: readOnly
          ? ColorRes.grey.withOpacity(0.1)
          : ColorRes.white,
      readOnly: readOnly,
      keyboardType: keyboard,
      textInputAction: action,
      validator: validator,
    );
  }
}