
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global/constants/colors_resources.dart';
import '../../global/global_widget/global_text.dart';
import 'bloc/bottom_nav_bar_bloc.dart';
import 'bloc/bottom_nav_bar_event.dart';
import 'bloc/bottom_nav_bar_state.dart';
import 'dart:math';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BottomNavBarBloc>();
    return BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFE8F5E0), // হালকা সবুজ background
          body: Stack(
            children: [
              Positioned.fill(
                bottom: 80,
                child: IndexedStack(
                  index: state.selectedIndex,
                  children: bloc.screens,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomNavBar(
                  selectedIndex: state.selectedIndex,
                  bloc: bloc,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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

    return SizedBox(
      height: 90 + bottomPad,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ── Bar with center bump ──────────────────────────────────
          Positioned(
            bottom: bottomPad,
            left: 16,
            right: 16,
            child: CustomPaint(
              painter: _BumpedPillPainter(color: Colors.white),
              child: SizedBox(
                height: 68,
                child: Row(
                  children: [
                    Expanded(
                      child: _NavItem(
                        icon: Icons.people_alt_rounded,
                        label: 'Make Relationship',
                        isActive: selectedIndex == 1,
                        onTap: () => context
                            .read<BottomNavBarBloc>()
                            .add(BottomNavBarTabChanged(1)),
                      ),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      child: _NavItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        isActive: selectedIndex == 2,
                        onTap: () => context
                            .read<BottomNavBarBloc>()
                            .add(BottomNavBarTabChanged(2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Floating FAB ──────────────────────────────────────────
          Positioned(
            bottom: bottomPad + 28,
            child: GestureDetector(
              onTap: () => context
                  .read<BottomNavBarBloc>()
                  .add(BottomNavBarTabChanged(0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: ColorRes.appColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ColorRes.appColor.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_tree,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GlobalText(
                    str: 'Family Tree',
                    fontSize: 10,
                    fontWeight: selectedIndex == 0
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: selectedIndex == 0
                        ? ColorRes.appColor
                        : Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bumped Pill Painter ──────────────────────────────────────────────────────
class _BumpedPillPainter extends CustomPainter {
  final Color color;
  const _BumpedPillPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final double r = size.height / 2; // pill radius = 34
    final double cx = size.width / 2;

    final path = Path();

    // Start bottom-left, go counter-clockwise for pill shape
    // Left pill end (semi-circle)
    path.addArc(
      Rect.fromLTWH(0, 0, size.height, size.height),
      pi / 2,
      pi,
    );

    final double notchDepth = 46.0;
    final double notchStartLeft = cx - 50.0;
    final double notchEndRight = cx + 50.0;

    // Top-left to bump start
    path.lineTo(notchStartLeft, 0);

    // Bump curve going DOWN (notch)
    path.cubicTo(
      notchStartLeft + 12, 0,
      cx - 32, notchDepth,
      cx, notchDepth,
    );
    path.cubicTo(
      cx + 32, notchDepth,
      notchEndRight - 12, 0,
      notchEndRight, 0,
    );

    // Top-right to right pill end
    path.lineTo(size.width - r, 0);

    // Right pill end (semi-circle)
    path.arcTo(
      Rect.fromLTWH(size.width - size.height, 0, size.height, size.height),
      -pi / 2,
      pi,
      false,
    );

    // Bottom line back to start
    path.lineTo(r, size.height);

    path.close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BumpedPillPainter old) => old.color != color;
}

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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? ColorRes.appColor : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          GlobalText(
            str: label,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? ColorRes.appColor : Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}