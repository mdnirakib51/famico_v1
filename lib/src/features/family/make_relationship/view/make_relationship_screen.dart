import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/global_widget/global_bottom_widget.dart';
import '../../../../global/global_widget/global_progress_hub.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../data/model/family_member_model.dart';
import '../../data/model/family_tree_model.dart' show FamilyMembers;
import '../../data/model/relation_ship_model.dart';
import '../bloc/make_relationship_bloc.dart';
import '../bloc/make_relationship_event.dart';
import '../bloc/make_relationship_state.dart';

class MakeRelationshipScreen extends StatefulWidget {
  /// Family Tree থেকে + button press করলে এই member pre-fill হবে
  final FamilyMembers? preselectedMember;

  const MakeRelationshipScreen({super.key, this.preselectedMember});

  @override
  State<MakeRelationshipScreen> createState() =>
      _MakeRelationshipScreenState();
}

class _MakeRelationshipScreenState extends State<MakeRelationshipScreen> {
  Members? _selectedMember;   // first member (locked if preselected)
  Members? _selectedRelative;
  Relationships? _selectedRelation;
  Relationships? _selectedRelationship;

  bool get _isFirstMemberLocked => widget.preselectedMember != null;

  @override
  void initState() {
    super.initState();
    context.read<MakeRelationshipBloc>().add(
      FetchRelationshipFormData(familyId: 2),
    );
  }

  /// State load হওয়ার পর preselectedMember কে _selectedMember এ match করা
  void _syncPreselected(List<Members> members) {
    if (!_isFirstMemberLocked) return;
    if (_selectedMember != null) return; // already synced

    final preId = widget.preselectedMember!.id;
    final match = members.where((m) => m.id == preId).toList();
    if (match.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedMember = match.first);
      });
    }
  }

  void _submit(MakeRelationshipState state) {
    if (_selectedMember == null ||
        _selectedRelative == null ||
        _selectedRelation == null ||
        _selectedRelationship == null) {
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
        // Sync preselected member once members list is loaded
        _syncPreselected(state.members);

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
                state.mutationStatus ==
                    MakeRelationshipMutationStatus.loading,
            child: state.status == MakeRelationshipStatus.loading
                ? const SizedBox.shrink()
                : state.status == MakeRelationshipStatus.failure
                ? _ErrorView(
              message: state.errorMessage,
              onRetry: () => context
                  .read<MakeRelationshipBloc>()
                  .add(FetchRelationshipFormData(familyId: 2)),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── First Member ──────────────────────────────
                  const _SectionLabel(label: 'First Member'),
                  sizedBoxH(6),
                  _isFirstMemberLocked
                      ? _LockedMemberCard(
                      member: widget.preselectedMember!)
                      : _MemberDropdown(
                    hint: 'Select first member',
                    members: state.members,
                    value: _selectedMember,
                    excludeId: _selectedRelative?.id,
                    onChanged: (val) => setState(
                            () => _selectedMember = val),
                  ),
                  sizedBoxH(16),

                  // ── Relation Type ─────────────────────────────
                  const _SectionLabel(label: 'Relation Type'),
                  sizedBoxH(6),
                  _RelationDropdown(
                    hint: 'e.g. Sibling, Parent, Spouse',
                    items: state.relations,
                    value: _selectedRelation,
                    onChanged: (val) =>
                        setState(() => _selectedRelation = val),
                  ),
                  sizedBoxH(16),

                  // ── Second Member ─────────────────────────────
                  const _SectionLabel(
                      label: 'Second Member (Relative)'),
                  sizedBoxH(6),
                  _MemberDropdown(
                    hint: 'Select second member',
                    members: state.members,
                    value: _selectedRelative,
                    excludeId: _isFirstMemberLocked
                        ? widget.preselectedMember!.id
                        : _selectedMember?.id,
                    onChanged: (val) =>
                        setState(() => _selectedRelative = val),
                  ),
                  sizedBoxH(16),

                  // ── Relationship Nature ───────────────────────
                  const _SectionLabel(label: 'Relationship Nature'),
                  sizedBoxH(6),
                  _RelationDropdown(
                    hint: 'e.g. Blood Related, Close Relatives',
                    items: state.relationships,
                    value: _selectedRelationship,
                    onChanged: (val) => setState(
                            () => _selectedRelationship = val),
                  ),
                  sizedBoxH(32),

                  // ── Preview Card ──────────────────────────────
                  if ((_isFirstMemberLocked ||
                      _selectedMember != null) &&
                      _selectedRelative != null &&
                      _selectedRelation != null)
                    _RelationPreviewCard(
                      member: _isFirstMemberLocked
                          ? (widget.preselectedMember!.name ?? '—')
                          : (_selectedMember!.name ?? '—'),
                      memberImage: _isFirstMemberLocked
                          ? widget.preselectedMember!.image
                          : _selectedMember!.image,
                      relative: _selectedRelative!.name ?? '—',
                      relativeImage: _selectedRelative!.image,
                      relation:
                      _selectedRelation!.relationship ?? '—',
                    ),

                  sizedBoxH(24),

                  // ── Submit ────────────────────────────────────
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

// ── Locked Member Card (non-editable) ─────────────────────────────────────────
class _LockedMemberCard extends StatelessWidget {
  final FamilyMembers member;
  const _LockedMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: ColorRes.appColor.withOpacity(0.12),
            backgroundImage: (member.image?.isNotEmpty ?? false)
                ? NetworkImage(member.image!)
                : null,
            child: (member.image?.isEmpty ?? true)
                ? const Icon(Icons.person,
                size: 18, color: ColorRes.appColor)
                : null,
          ),
          sizedBoxW(10),
          // Name
          Expanded(
            child: GlobalText(
              str: member.name ?? '—',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
          // Lock icon
          const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
        ],
      ),
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
  final String? excludeId;
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
    final filtered =
    members.where((m) => excludeId == null || m.id != excludeId).toList();

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
                backgroundImage:
                (m.image?.isNotEmpty ?? false)
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

// ── Relation Preview Card (updated with images) ───────────────────────────────
class _RelationPreviewCard extends StatelessWidget {
  final String member;
  final String? memberImage;
  final String relative;
  final String? relativeImage;
  final String relation;

  const _RelationPreviewCard({
    required this.member,
    required this.memberImage,
    required this.relative,
    required this.relativeImage,
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
          // Member
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: ColorRes.appColor.withOpacity(0.12),
                  backgroundImage: (memberImage?.isNotEmpty ?? false)
                      ? NetworkImage(memberImage!)
                      : null,
                  child: (memberImage?.isEmpty ?? true)
                      ? const Icon(Icons.person,
                      size: 22, color: ColorRes.appColor)
                      : null,
                ),
                sizedBoxH(6),
                GlobalText(
                  str: member,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Arrow + relation label
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

          // Relative
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: ColorRes.appColor.withOpacity(0.12),
                  backgroundImage: (relativeImage?.isNotEmpty ?? false)
                      ? NetworkImage(relativeImage!)
                      : null,
                  child: (relativeImage?.isEmpty ?? true)
                      ? const Icon(Icons.person,
                      size: 22, color: ColorRes.appColor)
                      : null,
                ),
                sizedBoxH(6),
                GlobalText(
                  str: relative,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ],
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