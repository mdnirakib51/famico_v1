import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/constants/colors_resources.dart';
import '../../data/model/family_tree_model.dart';
import '../../make_relationship/bloc/make_relationship_bloc.dart';
import '../../make_relationship/view/make_relationship_screen.dart';
import '../bloc/family_tree_bloc.dart';
import '../bloc/family_tree_event.dart';
import '../bloc/family_tree_state.dart';

class FamilyTreeScreen extends StatefulWidget {
  const FamilyTreeScreen({super.key});

  @override
  State<FamilyTreeScreen> createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyTreeBloc>().add(const FetchFamilyTree());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.appBackColor,
      appBar: AppBar(
        backgroundColor: ColorRes.appColor.withValues(alpha: 0.1),
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Family',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              TextSpan(
                text: 'meet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: ColorRes.appColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
        builder: (context, state) {
          if (state.status == FamilyTreeStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            );
          }

          if (state.status == FamilyTreeStatus.failure) {
            return _ErrorView(
              message: state.errorMessage,
              onRetry: () =>
                  context.read<FamilyTreeBloc>().add(const FetchFamilyTree()),
            );
          }

          if (state.familyMembers.isEmpty) {
            return const _EmptyTreeView();
          }

          return _FamilyTreeGraphView(members: state.familyMembers);
        },
      ),
    );
  }
}

// ── Empty Tree View ───────────────────────────────────────────────────────────
class _EmptyTreeView extends StatelessWidget {
  const _EmptyTreeView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to add member screen
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add You In Tree',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Family Tree Graph View ────────────────────────────────────────────────────
class _FamilyTreeGraphView extends StatelessWidget {
  final List<FamilyMembers> members;

  const _FamilyTreeGraphView({required this.members});

  /// Build a simple parent→children map based on relationships.
  /// Root nodes = members that are NOT a "relative" of anyone else.
  List<FamilyMembers> _getRoots() {
    final allRelativeIds = <String>{};
    for (final m in members) {
      for (final r in (m.relationships ?? [])) {
        if (r.relativeId != null) {
          allRelativeIds.add(r.relativeId!);
        }
      }
    }
    // Members not pointed to as relative by anyone — treat as roots
    final roots = members
        .where((m) => m.id != null && !allRelativeIds.contains(m.id))
        .toList();
    // Fallback: if all are connected, just take the first one
    return roots.isEmpty ? [members.first] : roots;
  }

  @override
  Widget build(BuildContext context) {
    final roots = _getRoots();

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(80),
      minScale: 0.5,
      maxScale: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: roots
              .map((root) => _TreeNodeWidget(
            member: root,
            allMembers: members,
            depth: 0,
          ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Tree Node Widget (recursive) ──────────────────────────────────────────────
class _TreeNodeWidget extends StatelessWidget {
  final FamilyMembers member;
  final List<FamilyMembers> allMembers;
  final int depth;

  const _TreeNodeWidget({
    required this.member,
    required this.allMembers,
    required this.depth,
  });

  List<FamilyMembers> get children {
    final childIds = (member.relationships ?? [])
        .map((r) => r.relativeId)
        .whereType<String>()
        .toSet();
    return allMembers.where((m) => childIds.contains(m.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final kids = children;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── The node itself ──
        _MemberNode(member: member),

        if (kids.isNotEmpty) ...[
          // Vertical line down from parent
          Container(width: 2, height: 24, color: const Color(0xFFBDBDBD)),

          // Horizontal connector + children
          _ChildrenRow(
            children: kids,
            allMembers: allMembers,
            depth: depth + 1,
          ),
        ],
      ],
    );
  }
}

// ── Children Row with horizontal connector line ───────────────────────────────
class _ChildrenRow extends StatelessWidget {
  final List<FamilyMembers> children;
  final List<FamilyMembers> allMembers;
  final int depth;

  const _ChildrenRow({
    required this.children,
    required this.allMembers,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    if (children.length == 1) {
      return _TreeNodeWidget(
        member: children.first,
        allMembers: allMembers,
        depth: depth,
      );
    }

    return CustomPaint(
      painter: _HorizontalLinePainter(childCount: children.length),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Short vertical from horizontal bar to child
                Container(
                    width: 2, height: 16, color: const Color(0xFFBDBDBD)),
                _TreeNodeWidget(
                  member: child,
                  allMembers: allMembers,
                  depth: depth,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Horizontal connector line painter ────────────────────────────────────────
class _HorizontalLinePainter extends CustomPainter {
  final int childCount;
  const _HorizontalLinePainter({required this.childCount});

  @override
  void paint(Canvas canvas, Size size) {
    if (childCount <= 1) return;
    final paint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw horizontal line across top
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Single Member Node ────────────────────────────────────────────────────────
class _MemberNode extends StatelessWidget {
  final FamilyMembers member;

  const _MemberNode({required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // + button on top
        _PlusButton(
          onTap: () => _navigateToMakeRelationship(context),
        ),
        const SizedBox(height: 4),

        // Avatar
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: (member.image?.isNotEmpty ?? false)
                ? Image.network(
              member.image!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _PlaceholderAvatar(name: member.name),
            )
                : _PlaceholderAvatar(name: member.name),
          ),
        ),

        const SizedBox(height: 6),

        // Name
        SizedBox(
          width: 80,
          child: Text(
            member.name ?? '—',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToMakeRelationship(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => MakeRelationshipBloc(),
          child: MakeRelationshipScreen(preselectedMember: member),
        ),
      ),
    );
  }
}

// ── Plus Button ───────────────────────────────────────────────────────────────
class _PlusButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PlusButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Color(0xFF4CAF50),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x554CAF50),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 16),
      ),
    );
  }
}

// ── Placeholder Avatar ────────────────────────────────────────────────────────
class _PlaceholderAvatar extends StatelessWidget {
  final String? name;
  const _PlaceholderAvatar({this.name});

  @override
  Widget build(BuildContext context) {
    final initials = (name?.isNotEmpty ?? false)
        ? name!.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';
    return Container(
      color: const Color(0xFFE8F5E9),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CAF50),
          ),
        ),
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
          const SizedBox(height: 12),
          Text(
            message ?? 'Something went wrong',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry',
                style: TextStyle(fontSize: 14, color: ColorRes.appColor)),
          ),
        ],
      ),
    );
  }
}