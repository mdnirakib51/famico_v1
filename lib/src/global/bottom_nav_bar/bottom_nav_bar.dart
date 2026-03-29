import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global/constants/colors_resources.dart';
import '../../global/global_widget/global_text.dart';
import 'bloc/bottom_nav_bar_bloc.dart';
import 'bloc/bottom_nav_bar_event.dart';
import 'bloc/bottom_nav_bar_state.dart';

// ─── Dashboard Bottom Navigation Bar ─────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BottomNavBarBloc>();

    return BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: state.selectedIndex,
            children: bloc.screens,
          ),
          bottomNavigationBar: _BottomNavBar(
            selectedIndex: state.selectedIndex,
            bloc: bloc,
          ),
        );
      },
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final BottomNavBarBloc bloc;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPad + 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: List.generate(bloc.navItems.length, (i) {
          return _NavItem(
            icon: bloc.navItems[i].icon,
            label: bloc.navItems[i].title,
            isActive: selectedIndex == i,
            onTap: () => context.read<BottomNavBarBloc>().add(BottomNavBarTabChanged(i)),
          );
        }),
      ),
    );
  }
}

// ─── Single Nav Item ──────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
              decoration: BoxDecoration(
                color: isActive
                    ? ColorRes.appColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isActive ? ColorRes.appColor : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 3),
            GlobalText(
              str: label,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? ColorRes.appColor : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}