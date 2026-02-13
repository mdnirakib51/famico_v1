
import 'dart:math';
import 'package:flutter/material.dart';
import '../../global/constants/colors_resources.dart';

class ContainerSpaceBackWidget extends StatefulWidget {
  final Widget child;
  const ContainerSpaceBackWidget({
    super.key,
    required this.child
  });

  @override
  State<ContainerSpaceBackWidget> createState() => _ContainerSpaceBackWidgetState();
}

class _ContainerSpaceBackWidgetState extends State<ContainerSpaceBackWidget> with TickerProviderStateMixin {

  late AnimationController _cloudController;
  late AnimationController _starController;
  late AnimationController _gentleWaveController;
  late AnimationController _heartBeatController;

  late Animation<double> _cloudAnimation;
  late Animation<double> _starAnimation;
  late Animation<double> _gentleWaveAnimation;
  late Animation<double> _heartBeatAnimation;

  @override
  void initState() {
    super.initState();

    // Gentle cloud floating animation
    _cloudController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _cloudAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeInOut,
    ));

    // Soft twinkling stars animation
    _starController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _starAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _starController,
      curve: Curves.easeInOutSine,
    ));

    // Gentle wave animation
    _gentleWaveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _gentleWaveAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _gentleWaveController,
      curve: Curves.linear,
    ));

    // Soft heartbeat/pulse animation for family warmth
    _heartBeatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _heartBeatAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _heartBeatController,
      curve: Curves.easeInOut,
    ));

    // Start all animations
    _cloudController.repeat();
    _starController.repeat(reverse: true);
    _gentleWaveController.repeat();
    _heartBeatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _starController.dispose();
    _gentleWaveController.dispose();
    _heartBeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(15),
        //     topRight: Radius.circular(15)
        // ),
        color: ColorRes.appBackColor, // White background
      ),
      child: Stack(
        children: [
          // Animated gentle wave pattern overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gentleWaveAnimation,
              builder: (context, child) => CustomPaint(
                painter: FamilyWavePatternPainter(_gentleWaveAnimation.value),
              ),
            ),
          ),

          // Large soft cloud - top right
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) => Positioned(
              top: 30 + (sin(_cloudAnimation.value * 2 * pi) * 15),
              right: -40 + (cos(_cloudAnimation.value * 2 * pi) * 10),
              child: AnimatedBuilder(
                animation: _heartBeatAnimation,
                builder: (context, child) => Opacity(
                  opacity: 0.25,
                  child: Transform.scale(
                    scale: _heartBeatAnimation.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            ColorRes.appColor.withValues(alpha: 0.5),
                            ColorRes.appColor.withValues(alpha: 0.3),
                            ColorRes.appColor.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Medium cloud - top left
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) => Positioned(
              top: 60 + (sin(_cloudAnimation.value * 2 * pi + 1) * 12),
              left: -30 + (cos(_cloudAnimation.value * 2 * pi + 1) * 8),
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ColorRes.appColor.withValues(alpha: 0.45),
                        ColorRes.appColor.withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Twinkling stars scattered around
          ...List.generate(8, (index) {
            final positions = [
              {'top': 50.0, 'left': 60.0, 'size': 8.0},
              {'top': 90.0, 'right': 80.0, 'size': 6.0},
              {'top': 130.0, 'left': 100.0, 'size': 7.0},
              {'top': 70.0, 'right': 120.0, 'size': 5.0},
              {'bottom': 180.0, 'left': 50.0, 'size': 6.0},
              {'bottom': 140.0, 'right': 70.0, 'size': 7.0},
              {'top': 110.0, 'left': 40.0, 'size': 5.0},
              {'bottom': 200.0, 'right': 110.0, 'size': 6.0},
            ];

            return AnimatedBuilder(
              animation: _starAnimation,
              builder: (context, child) {
                // Stagger the star animations
                double staggeredOpacity = _starAnimation.value;
                if (index % 2 == 0) {
                  staggeredOpacity = 1 - _starAnimation.value + 0.3;
                }

                return Positioned(
                  top: positions[index]['top'],
                  left: positions[index]['left'],
                  right: positions[index]['right'],
                  bottom: positions[index]['bottom'],
                  child: Opacity(
                    opacity: staggeredOpacity.clamp(0.0, 1.0),
                    child: CustomPaint(
                      size: Size(positions[index]['size'] as double,
                          positions[index]['size'] as double),
                      painter: StarPainter(
                        color: ColorRes.appColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Soft floating bubbles for playful touch
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) => Positioned(
              top: 150 + (sin(_cloudAnimation.value * 2 * pi + 2) * 20),
              right: 50 + (cos(_cloudAnimation.value * 2 * pi + 2) * 15),
              child: AnimatedBuilder(
                animation: _heartBeatAnimation,
                builder: (context, child) => Opacity(
                  opacity: 0.18,
                  child: Transform.scale(
                    scale: _heartBeatAnimation.value * 0.95,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            ColorRes.appColor.withValues(alpha: 0.4),
                            ColorRes.appColor.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) => Positioned(
              bottom: 120 + (sin(_cloudAnimation.value * 2 * pi + 3) * 18),
              left: 40 + (cos(_cloudAnimation.value * 2 * pi + 3) * 12),
              child: Opacity(
                opacity: 0.15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ColorRes.appColor.withValues(alpha: 0.35),
                        ColorRes.appColor.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Small decorative circles
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) => Positioned(
              bottom: 160 + (sin(_cloudAnimation.value * 2 * pi + 4) * 10),
              right: 60,
              child: AnimatedBuilder(
                animation: _heartBeatAnimation,
                builder: (context, child) => Opacity(
                  opacity: 0.2,
                  child: Transform.scale(
                    scale: _heartBeatAnimation.value,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorRes.appColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Gentle corner accents
          Positioned(
            top: 100,
            left: 25,
            child: AnimatedBuilder(
              animation: _starAnimation,
              builder: (context, child) => Opacity(
                opacity: 0.15 + (_starAnimation.value * 0.1),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorRes.appColor.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 180,
            right: 90,
            child: AnimatedBuilder(
              animation: _starAnimation,
              builder: (context, child) => Opacity(
                opacity: 0.12 + ((1 - _starAnimation.value) * 0.1),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: ColorRes.appColor.withValues(alpha: 0.22),
                  ),
                ),
              ),
            ),
          ),

          // Main content with proper constraints
          Positioned.fill(
            top: 0,
            left: 0,
            right: 0,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

// Custom painter for gentle wave patterns
class FamilyWavePatternPainter extends CustomPainter {
  final double animationValue;

  FamilyWavePatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorRes.appColor.withValues(alpha: 0.12)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Create smooth, gentle wave patterns
    for (int i = 0; i < 3; i++) {
      final path = Path();
      double yOffset = size.height * 0.25 + (i * 60);
      double waveOffset = animationValue * 60;

      for (double x = 0; x <= size.width; x += 1) {
        double frequency = 0.015 - (i * 0.002);
        double amplitude = 12 + (i * 4);

        double y = yOffset +
            amplitude * sin((x + waveOffset) * frequency) *
                (0.8 + 0.2 * sin(animationValue * 2 * pi));

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    // Add gentle floating dots
    final dotPaint = Paint()
      ..color = ColorRes.appColor.withValues(alpha: 0.15 + (sin(animationValue * 2 * pi) * 0.05))
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      double x = (size.width / 12) * i + (sin(animationValue * 2 * pi + i) * 25);
      double y = size.height * 0.5 + (cos(animationValue * 2 * pi + i * 0.5) * 30);
      double radius = 2.5 + (sin(animationValue * 4 * pi + i) * 0.8);

      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for star shapes
class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Create a simple 4-pointed star
    for (int i = 0; i < 4; i++) {
      final angle = (i * pi / 2) - pi / 2;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Add inner point
      final innerAngle = angle + pi / 4;
      final innerRadius = radius * 0.4;
      final innerX = centerX + innerRadius * cos(innerAngle);
      final innerY = centerY + innerRadius * sin(innerAngle);
      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
