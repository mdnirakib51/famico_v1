
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../../../global/global_widget/global_sized_box.dart';
import '../../../../global/global_widget/global_text.dart';
import '../../data/model/family_member_model.dart';
import '../../family_name/bloc/family_name_bloc.dart';
import '../../family_name/bloc/family_name_event.dart';
import '../bloc/family_member_bloc.dart';
import '../bloc/family_member_event.dart';
import '../bloc/family_member_state.dart';
import 'create_family_member.dart';

class FamilyMemberScreen extends StatefulWidget {
  const FamilyMemberScreen({super.key});

  @override
  State<FamilyMemberScreen> createState() => _FamilyMemberScreenState();
}

class _FamilyMemberScreenState extends State<FamilyMemberScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyMemberBloc>().add(const FetchFamilyMemberList());
    context.read<FamilyNameBloc>().add(FetchFamilyNameList());
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<FamilyMemberBloc>()),
          BlocProvider.value(value: context.read<FamilyNameBloc>()),
        ],
        child: const CreateFamilyMemberSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.appBackColor,
      appBar: AppBar(
        backgroundColor: ColorRes.appColor,
        foregroundColor: ColorRes.white,
        title: const GlobalText(
          str: 'Family Members',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ColorRes.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openCreateSheet,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Add Member',
          ),
        ],
      ),
      body: BlocBuilder<FamilyMemberBloc, FamilyMemberState>(
        builder: (context, state) {
          if (state.status == FamilyMemberStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorRes.appColor),
            );
          }

          if (state.status == FamilyMemberStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 48),
                  sizedBoxH(12),
                  GlobalText(
                    str: state.errorMessage ?? 'Something went wrong',
                    fontSize: 14,
                    color: ColorRes.grey,
                  ),
                  sizedBoxH(16),
                  TextButton(
                    onPressed: () => context
                        .read<FamilyMemberBloc>()
                        .add(const FetchFamilyMemberList()),
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

          if (state.members.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_outlined,
                      size: 64, color: ColorRes.grey.withOpacity(0.5)),
                  sizedBoxH(12),
                  const GlobalText(
                    str: 'No family members yet',
                    fontSize: 15,
                    color: ColorRes.grey,
                  ),
                  sizedBoxH(8),
                  TextButton.icon(
                    onPressed: _openCreateSheet,
                    icon: const Icon(Icons.add, color: ColorRes.appColor),
                    label: const GlobalText(
                      str: 'Add Member',
                      fontSize: 14,
                      color: ColorRes.appColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.members.length,
            separatorBuilder: (_, __) => sizedBoxH(10),
            itemBuilder: (_, index) =>
                _MemberCard(member: state.members[index]),
          );
        },
      ),
    );
  }
}

// ── Member Card ───────────────────────────────────────────────────────────────
class _MemberCard extends StatelessWidget {
  final Members member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 26,
            backgroundColor: ColorRes.appColor.withOpacity(0.12),
            backgroundImage: (member.image?.isNotEmpty ?? false)
                ? NetworkImage(member.image!)
                : null,
            child: (member.image?.isEmpty ?? true)
                ? const Icon(Icons.person,
                size: 26, color: ColorRes.appColor)
                : null,
          ),
          sizedBoxW(12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  str: member.name ?? '—',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                sizedBoxH(3),
                if (member.phone != null)
                  GlobalText(
                    str: member.phone!,
                    fontSize: 13,
                    color: ColorRes.grey,
                  ),
                if (member.email != null)
                  GlobalText(
                    str: member.email!,
                    fontSize: 13,
                    color: ColorRes.grey,
                  ),
              ],
            ),
          ),
          // Status badge
          if (member.status != null)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: member.status == 'Live'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GlobalText(
                str: member.status!,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: member.status == 'Live'
                    ? Colors.green
                    : ColorRes.grey,
              ),
            ),
        ],
      ),
    );
  }
}
