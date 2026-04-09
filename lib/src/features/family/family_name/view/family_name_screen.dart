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
import '../../data/model/family_name_model.dart';
import '../bloc/family_name_bloc.dart';
import '../bloc/family_name_event.dart';
import '../bloc/family_name_state.dart';

class FamilyNameScreen extends StatefulWidget {
  const FamilyNameScreen({super.key});

  @override
  State<FamilyNameScreen> createState() => _FamilyNameScreenState();
}

class _FamilyNameScreenState extends State<FamilyNameScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyNameBloc>().add(FetchFamilyNameList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyNameBloc, FamilyNameState>(
      listenWhen: (prev, curr) =>
      curr.mutationStatus != prev.mutationStatus,
      listener: (context, state) {
        if (state.mutationStatus == FamilyNameMutationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Family name added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state.mutationStatus == FamilyNameMutationStatus.failure &&
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
            state.mutationStatus == FamilyNameMutationStatus.loading;

        return Scaffold(
          backgroundColor: ColorRes.appBackColor,
          appBar: GlobalAppBar(
            title: 'Family Names',
            isBackIc: false,
            actions: [
              GestureDetector(
                onTap: () => _showAddSheet(context),
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
                        str: 'Add Family',
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
            state.status == FamilyNameStatus.loading || isMutating,
            child: state.status == FamilyNameStatus.failure
                ? _buildError(context, state.errorMessage)
                : state.families.isEmpty &&
                state.status == FamilyNameStatus.success
                ? _buildEmpty(context)
                : _buildList(context, state.families),
          ),
        );
      },
    );
  }

  // ── List ───────────────────────────────────────────────────────────────────
  Widget _buildList(BuildContext context, List<Families> families) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: families.length,
      separatorBuilder: (_, __) => sizedBoxH(12),
      itemBuilder: (_, index) => _FamilyNameCard(family: families[index]),
    );
  }

  // ── Empty ──────────────────────────────────────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline,
              size: 64, color: ColorRes.grey.withOpacity(0.5)),
          sizedBoxH(16),
          const GlobalText(
            str: 'No family names found',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorRes.grey,
          ),
          sizedBoxH(12),
          ElevatedButton.icon(
            onPressed: () => _showAddSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Family Name'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.appColor,
              foregroundColor: ColorRes.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ──────────────────────────────────────────────────────────────────
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
                context.read<FamilyNameBloc>().add(FetchFamilyNameList()),
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

  // ── Add Bottom Sheet ───────────────────────────────────────────────────────
  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<FamilyNameBloc>(),
        child: const _AddFamilyNameSheet(),
      ),
    );
  }
}

// ─── Family Name Card ──────────────────────────────────────────────────────────
class _FamilyNameCard extends StatelessWidget {
  final Families family;

  const _FamilyNameCard({required this.family});

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
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ColorRes.appColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.people_outline,
              color: ColorRes.appColor, size: 22),
        ),
        title: GlobalText(
          str: family.name ?? '—',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: ColorRes.black,
        ),
        subtitle: family.createdAt != null
            ? GlobalText(
          str: 'Created: ${family.createdAt!}',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: ColorRes.grey,
        )
            : null,
        trailing: const Icon(Icons.chevron_right,
            size: 20, color: ColorRes.grey),
      ),
    );
  }
}

// ─── Add Family Name Bottom Sheet ─────────────────────────────────────────────
class _AddFamilyNameSheet extends StatefulWidget {
  const _AddFamilyNameSheet();

  @override
  State<_AddFamilyNameSheet> createState() => _AddFamilyNameSheetState();
}

class _AddFamilyNameSheetState extends State<_AddFamilyNameSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<FamilyNameBloc>().add(
      FamilyNameCreateSubmitted(
        familyName: _nameCtrl.text.trim(),
      ),
    );
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ───────────────────────────────────────────────────
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
              str: 'Add Family Name',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorRes.black,
            ),

            sizedBoxH(16),

            // ── Family Name Input ─────────────────────────────────────────
            GlobalTextFormField(
              controller: _nameCtrl,
              titleText: 'Family Name',
              hintText: 'Enter Family Name',
              decoration: glassInputDecoration,
              filled: true,
              fillColor: ColorRes.white,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Family name is required'
                  : null,
            ),

            sizedBoxH(24),

            // ── Submit ────────────────────────────────────────────────────
            GlobalButtonWidget(
              str: 'ADD FAMILY NAME',
              height: 45,
              buttomColor: ColorRes.appColor,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}