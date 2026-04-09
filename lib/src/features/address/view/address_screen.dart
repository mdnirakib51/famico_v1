import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../global/components/global_appbar.dart';
import '../../../global/constants/colors_resources.dart';
import '../../../global/constants/input_decoration.dart';
import '../../../global/global_widget/global_bottom_widget.dart';
import '../../../global/global_widget/global_progress_hub.dart';
import '../../../global/global_widget/global_sized_box.dart';
import '../../../global/global_widget/global_text.dart';
import '../../../global/global_widget/global_textform_field.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import '../data/model/address_list_model.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(FetchAddressList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listenWhen: (prev, curr) =>
      curr.mutationStatus != prev.mutationStatus,
      listener: (context, state) {
        if (state.mutationStatus == AddressMutationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Done successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state.mutationStatus == AddressMutationStatus.failure &&
            state.mutationError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.mutationError!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isMutating =
            state.mutationStatus == AddressMutationStatus.loading;

        return Scaffold(
          backgroundColor: ColorRes.appBackColor,
          appBar: GlobalAppBar(
            title: 'My Addresses',
            actions: [
              GestureDetector(
                onTap: () => _showAddressSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: ColorRes.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: ColorRes.white, size: 14),
                      sizedBoxW(3),
                      GlobalText(
                        str: 'Add Address',
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
            inAsyncCall:
            state.status == AddressStatus.loading || isMutating,
            child: state.status == AddressStatus.failure
                ? _buildError(context, state.errorMessage)
                : state.addresses.isEmpty &&
                state.status == AddressStatus.success
                ? _buildEmpty(context)
                : _buildList(context, state.addresses),
          ),
        );
      },
    );
  }

  // ── Address List ───────────────────────────────────────────────────────────
  Widget _buildList(BuildContext context, List<Addresses> addresses) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      separatorBuilder: (_, __) => sizedBoxH(12),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _AddressCard(
          address: address,
          onEdit: () => _showAddressSheet(context, address: address),
          onDelete: () => _confirmDelete(context, address),
        );
      },
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined,
              size: 64, color: ColorRes.grey.withOpacity(0.5)),
          sizedBoxH(16),
          const GlobalText(
            str: 'No addresses found',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorRes.grey,
          ),
          sizedBoxH(12),
          ElevatedButton.icon(
            onPressed: () => _showAddressSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.appColor,
              foregroundColor: ColorRes.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error State ────────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, String? message) {
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
                context.read<AddressBloc>().add(FetchAddressList()),
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

  // ── Delete Confirm Dialog ──────────────────────────────────────────────────
  void _confirmDelete(BuildContext context, Addresses address) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Address'),
        content: Text(
          'Are you sure you want to delete "${address.street}, ${address.city}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (address.id != null) {
                context.read<AddressBloc>().add(AddressDeleteRequested(address.id!));
              }
            },
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Add / Edit Bottom Sheet ────────────────────────────────────────────────
  void _showAddressSheet(BuildContext context, {Addresses? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AddressBloc>(),
        child: _AddressFormSheet(address: address),
      ),
    );
  }
}

// ─── Address Card ─────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final Addresses address; // ← Addresses (not Address)
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
          // ── Header ──────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: ColorRes.appColor.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: ColorRes.appColor, size: 18),
                sizedBoxW(8),
                Expanded(
                  child: GlobalText(
                    str: address.addressType ?? 'Address',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ColorRes.appColor,
                  ),
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(Icons.edit_outlined,
                      size: 18, color: ColorRes.appColor),
                ),
                sizedBoxW(12),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline,
                      size: 18, color: Colors.red),
                ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _row(Icons.signpost_outlined, 'Street', address.street),
                _row(Icons.location_city_outlined, 'City', address.city),
                _row(Icons.map_outlined, 'State', address.state),
                _row(Icons.flag_outlined, 'Country', address.country),
                _row(
                    Icons.local_post_office_outlined, 'ZIP', address.zip),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: ColorRes.grey),
          sizedBoxW(8),
          Expanded(
            flex: 2,
            child: GlobalText(
              str: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorRes.grey,
            ),
          ),
          const GlobalText(
              str: ':',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorRes.grey),
          sizedBoxW(6),
          Expanded(
            flex: 3,
            child: GlobalText(
              str: value ?? '—',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorRes.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add / Edit Form Bottom Sheet ─────────────────────────────────────────────
class _AddressFormSheet extends StatefulWidget {
  final Addresses? address; // null = create, non-null = edit

  const _AddressFormSheet({this.address});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _streetCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _zipCtrl;
  late TextEditingController _countryCtrl;

  String _addressType = 'Present';
  final List<String> _addressTypes = [
    'Present',
    'Permanent',
    'Work',
    'Other',
  ];

  bool get _isEdit => widget.address != null;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _streetCtrl  = TextEditingController(text: a?.street ?? '');
    _cityCtrl    = TextEditingController(text: a?.city ?? '');
    _stateCtrl   = TextEditingController(text: a?.state ?? '');
    _zipCtrl     = TextEditingController(text: a?.zip ?? '');
    _countryCtrl = TextEditingController(text: a?.country ?? '');

    // Pre-fill address type (capitalise first letter to match dropdown)
    if (a?.addressType != null) {
      final type = _capitalize(a!.addressType!);
      _addressType =
      _addressTypes.contains(type) ? type : _addressTypes.first;
    }
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_isEdit) {
      context.read<AddressBloc>().add(AddressEditSubmitted(
        id: widget.address?.id ?? '',
        street: _streetCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        state: _stateCtrl.text.trim(),
        zip: _zipCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        addressType: _addressType,
      ));
    } else {
      context.read<AddressBloc>().add(AddressCreateSubmitted(
        street: _streetCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        state: _stateCtrl.text.trim(),
        zip: _zipCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        addressType: _addressType,
      ));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      decoration: const BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Sheet Handle ─────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorRes.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              sizedBoxH(16),

              GlobalText(
                str: _isEdit ? 'Edit Address' : 'Add Address',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorRes.black,
              ),

              sizedBoxH(16),

              // ── Address Type Dropdown ────────────────────────────────────
              DropdownButtonFormField<String>(
                value: _addressType,
                decoration: glassInputDecoration.copyWith(
                  labelText: 'Address Type',
                  filled: true,
                  fillColor: ColorRes.white,
                ),
                items: _addressTypes
                    .map((t) =>
                    DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _addressType = val!),
              ),

              sizedBoxH(12),

              // ── Street ───────────────────────────────────────────────────
              GlobalTextFormField(
                controller: _streetCtrl,
                titleText: 'Street',
                hintText: 'Enter Street',
                decoration: glassInputDecoration,
                filled: true,
                fillColor: ColorRes.white,
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Street is required'
                    : null,
              ),

              sizedBoxH(12),

              // ── City ─────────────────────────────────────────────────────
              GlobalTextFormField(
                controller: _cityCtrl,
                titleText: 'City',
                hintText: 'Enter City',
                decoration: glassInputDecoration,
                filled: true,
                fillColor: ColorRes.white,
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'City is required'
                    : null,
              ),

              sizedBoxH(12),

              // ── State & ZIP (side by side) ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GlobalTextFormField(
                      controller: _stateCtrl,
                      titleText: 'State',
                      hintText: 'State',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  sizedBoxW(10),
                  Expanded(
                    child: GlobalTextFormField(
                      controller: _zipCtrl,
                      titleText: 'ZIP',
                      hintText: 'ZIP',
                      decoration: glassInputDecoration,
                      filled: true,
                      fillColor: ColorRes.white,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),

              sizedBoxH(12),

              // ── Country ──────────────────────────────────────────────────
              GlobalTextFormField(
                controller: _countryCtrl,
                titleText: 'Country',
                hintText: 'Enter Country',
                decoration: glassInputDecoration,
                filled: true,
                fillColor: ColorRes.white,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Country is required'
                    : null,
              ),

              sizedBoxH(24),

              // ── Submit Button ─────────────────────────────────────────────
              GlobalButtonWidget(
                str: _isEdit ? 'UPDATE ADDRESS' : 'ADD ADDRESS',
                height: 45,
                buttomColor: ColorRes.appColor,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}