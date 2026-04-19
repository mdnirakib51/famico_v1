import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../data/model/family_member_model.dart';
import '../../data/model/relation_ship_model.dart';
import '../bloc/make_relationship_bloc.dart';
import '../bloc/make_relationship_event.dart';
import '../bloc/make_relationship_state.dart';

class MakeRelationshipScreen extends StatefulWidget {
  const MakeRelationshipScreen({super.key});

  @override
  State<MakeRelationshipScreen> createState() => _MakeRelationshipScreenState();
}

class _MakeRelationshipScreenState extends State<MakeRelationshipScreen> {
  Members? _selectedMember;
  Members? _selectedRelative;
  Relationships? _selectedRelation;
  Relationships? _selectedRelationship;

  @override
  void initState() {
    super.initState();
    context.read<MakeRelationshipBloc>().add(
      FetchRelationshipFormData(familyId: 2),
    );
  }

  void _submit(MakeRelationshipState state) {
    if (_selectedMember == null || _selectedRelative == null || _selectedRelation == null || _selectedRelationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedMember!.id == _selectedRelative!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Member and relative cannot be the same person'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<MakeRelationshipBloc>().add(
      MakeRelationshipSubmitted(
        familyId: 2,
        memberId: int.parse(_selectedMember!.id.toString()),
        relativeId: int.parse(_selectedRelative!.id.toString()),
        relationId: _selectedRelation!.id!,
        relationshipId: _selectedRelationship!.id!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MakeRelationshipBloc, MakeRelationshipState>(
      listener: (context, state) {
        if (state.mutationStatus == MakeRelationshipMutationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Relationship created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
        if (state.mutationStatus == MakeRelationshipMutationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.mutationError ?? 'Something went wrong'),
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
            foregroundColor: ColorRes.white,
            title: const GlobalText(
              str: 'Make Relationship',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorRes.white,
            ),
            centerTitle: true,
          ),
          body: ProgressHUD(
            inAsyncCall:
            state.status == MakeRelationshipStatus.loading ||
                state.mutationStatus == MakeRelationshipMutationStatus.loading,
            child: state.status == MakeRelationshipStatus.loading
                ? const SizedBox.shrink()
                : state.status == MakeRelationshipStatus.failure
                ? _ErrorView(
              message: state.errorMessage,
              onRetry: () => context
                  .read<MakeRelationshipBloc>()
                  .add(FetchRelationshipFormData(
                  familyId: 2)),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── First Member ──
                  _SectionLabel(label: 'First Member'),
                  sizedBoxH(6),
                  _MemberDropdown(
                    hint: 'Select first member',
                    members: state.members,
                    value: _selectedMember,
                    excludeId: _selectedRelative?.id,
                    onChanged: (val) =>
                        setState(() => _selectedMember = val),
                  ),
                  sizedBoxH(16),

                  // ── Relation Type (sibling/parent etc.) ──
                  _SectionLabel(label: 'Relation Type'),
                  sizedBoxH(6),
                  _RelationDropdown(
                    hint: 'e.g. Sibling, Parent, Spouse',
                    items: state.relations,
                    value: _selectedRelation,
                    onChanged: (val) =>
                        setState(() => _selectedRelation = val),
                  ),
                  sizedBoxH(16),

                  // ── Second Member (relative) ──
                  _SectionLabel(label: 'Second Member (Relative)'),
                  sizedBoxH(6),
                  _MemberDropdown(
                    hint: 'Select second member',
                    members: state.members,
                    value: _selectedRelative,
                    excludeId: _selectedMember?.id,
                    onChanged: (val) =>
                        setState(() => _selectedRelative = val),
                  ),
                  sizedBoxH(16),

                  // ── Relationship Nature (direct/indirect etc.) ──
                  _SectionLabel(label: 'Relationship Nature'),
                  sizedBoxH(6),
                  _RelationDropdown(
                    hint: 'e.g. Direct, Indirect',
                    items: state.relationships,
                    value: _selectedRelationship,
                    onChanged: (val) =>
                        setState(() => _selectedRelationship = val),
                  ),
                  sizedBoxH(32),

                  // ── Preview Card ──
                  if (_selectedMember != null &&
                      _selectedRelative != null &&
                      _selectedRelation != null)
                    _RelationPreviewCard(
                      member: _selectedMember!.name ?? '—',
                      relative: _selectedRelative!.name ?? '—',
                      relation:
                      _selectedRelation!.relationship ?? '—',
                    ),

                  sizedBoxH(24),

                  // ── Submit ──
                  GlobalButtonWidget(
                    str: 'CREATE RELATIONSHIP',
                    height: 48,
                    buttomColor: ColorRes.appColor,
                    onTap: () => _submit(state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return GlobalText(
      str: label,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: ColorRes.black,
    );
  }
}

// ── Member Dropdown ───────────────────────────────────────────────────────────
class _MemberDropdown extends StatelessWidget {
  final String hint;
  final List<Members> members;
  final Members? value;
  final String? excludeId; // selected এর opposite টা exclude করবে
  final ValueChanged<Members?> onChanged;

  const _MemberDropdown({
    required this.hint,
    required this.members,
    required this.value,
    required this.onChanged,
    this.excludeId,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = members
        .where((m) => excludeId == null || m.id != excludeId)
        .toList();

    return _DropdownContainer(
      child: DropdownButton<Members>(
        value: value,
        isExpanded: true,
        hint: Text(hint,
            style: const TextStyle(color: ColorRes.grey, fontSize: 14)),
        underline: const SizedBox.shrink(),
        items: filtered
            .map((m) => DropdownMenuItem(
          value: m,
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                ColorRes.appColor.withOpacity(0.12),
                backgroundImage: (m.image?.isNotEmpty ?? false)
                    ? NetworkImage(m.image!)
                    : null,
                child: (m.image?.isEmpty ?? true)
                    ? const Icon(Icons.person,
                    size: 14, color: ColorRes.appColor)
                    : null,
              ),
              sizedBoxW(8),
              Text(m.name ?? '—',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ── Relation Dropdown ─────────────────────────────────────────────────────────
class _RelationDropdown extends StatelessWidget {
  final String hint;
  final List<Relationships> items;
  final Relationships? value;
  final ValueChanged<Relationships?> onChanged;

  const _RelationDropdown({
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _DropdownContainer(
      child: DropdownButton<Relationships>(
        value: value,
        isExpanded: true,
        hint: Text(hint,
            style: const TextStyle(color: ColorRes.grey, fontSize: 14)),
        underline: const SizedBox.shrink(),
        items: items
            .map((r) => DropdownMenuItem(
          value: r,
          child: Text(r.relationship ?? '—',
              style: const TextStyle(fontSize: 14)),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ── Dropdown Container ────────────────────────────────────────────────────────
class _DropdownContainer extends StatelessWidget {
  final Widget child;
  const _DropdownContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3)),
      ),
      child: child,
    );
  }
}

// ── Relation Preview Card ─────────────────────────────────────────────────────
class _RelationPreviewCard extends StatelessWidget {
  final String member;
  final String relative;
  final String relation;

  const _RelationPreviewCard({
    required this.member,
    required this.relative,
    required this.relation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.appColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.appColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GlobalText(
              str: member,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const Icon(Icons.compare_arrows_rounded,
                    color: ColorRes.appColor, size: 22),
                GlobalText(
                  str: relation,
                  fontSize: 11,
                  color: ColorRes.appColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Expanded(
            child: GlobalText(
              str: relative,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ErrorView({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          sizedBoxH(12),
          GlobalText(
            str: message ?? 'Something went wrong',
            fontSize: 14,
            color: ColorRes.grey,
          ),
          sizedBoxH(16),
          TextButton(
            onPressed: onRetry,
            child: const GlobalText(
              str: 'Retry',
              fontSize: 14,
              color: ColorRes.appColor,
            ),
          ),
        ],
      ),
    );
  }
}