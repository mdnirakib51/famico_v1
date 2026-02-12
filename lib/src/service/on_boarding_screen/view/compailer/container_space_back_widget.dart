import 'dart:math';

import 'package:flutter/material.dart';

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

  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation for bubbles
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation for abstract shapes
    _rotationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Pulse animation for circles
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Wave animation
    _waveController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));

    // Start all animations
    _floatingController.repeat(reverse: true);
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF006A8E), // Darker shade
            Color(0xFF0096C7), // Your main color
            Color(0xFF38BDF8), // Lighter aqua
            Color(0xFF90E0EF), // Very light aqua
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),

      child: Stack(
        children: [
          // Animated floating bubbles/circles
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              top: 20 + _floatingAnimation.value,
              right: -50,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Large background circle with glow effect and floating animation
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              top: 50 + (_floatingAnimation.value * 0.7),
              left: -60,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value * 0.9,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.12),
                          Colors.white.withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.1),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Medium floating elements with different animation timing
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              top: 80 + (_floatingAnimation.value * -0.8),
              right: 60,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: 1 + (_pulseAnimation.value - 1) * 0.5,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Small accent circles with floating animation
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              top: 120 + (_floatingAnimation.value * 0.6),
              left: 50,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value * 0.95,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom decorative elements with floating animation
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              bottom: 140 + (_floatingAnimation.value * -0.5),
              left: 20,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: 1 + (_pulseAnimation.value - 1) * 0.3,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.12),
                          Colors.white.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              bottom: 160 + (_floatingAnimation.value * 0.4),
              right: 30,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value * 0.9,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Abstract shapes with rotation and floating animation
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              top: 40 + (_floatingAnimation.value * 0.3),
              left: 30,
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) => Transform.rotate(
                  angle: 0.5 + (_rotationAnimation.value * 3.14159),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              top: 90 + (_floatingAnimation.value * -0.4),
              right: 20,
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) => Transform.rotate(
                  angle: -0.3 + (_rotationAnimation.value * -3.14159),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Additional floating decorative elements
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              top: 150 + (_floatingAnimation.value * 0.8),
              right: 80,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: 1 + (_pulseAnimation.value - 1) * 0.4,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) => Positioned(
              bottom: 100 + (_floatingAnimation.value * -0.6),
              right: 120,
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) => Transform.rotate(
                  angle: _rotationAnimation.value * 3.14159 * 0.5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Animated wave pattern overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) => CustomPaint(
                painter: AnimatedWavePatternPainter(_waveAnimation.value),
              ),
            ),
          ),

          // Main content with enhanced styling
          Positioned(
            top: 15,
            left: 20,
            right: 20,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class AnimatedWavePatternPainter extends CustomPainter {
  final double animationValue;

  AnimatedWavePatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Create animated wave patterns
    for (int i = 0; i < 4; i++) {
      final path = Path();
      double yOffset = size.height * 0.2 + (i * 45);
      double waveOffset = animationValue * 40; // Wave movement

      path.moveTo(0, yOffset);

      for (double x = 0; x <= size.width; x += 15) {
        double y = yOffset + (8 * (i + 1)) *
            (0.5 + 0.5 * ((x + waveOffset) / size.width)) *
            (1 + 0.3 * ((x + waveOffset) / 80)) *
            (1 + 0.2 * (animationValue * 2 - 1));

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    // Add animated dots
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04 + (animationValue * 0.02))
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 10; i++) {
      double x = (size.width / 10) * i + (animationValue * 20);
      double y = size.height * 0.4 + (i % 2) * 40 + (animationValue * 15);
      double radius = 1 + (animationValue * 0.5);

      if (x >= 0 && x <= size.width) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Enhanced wave pattern painter with shimmer effects
class EnhancedWavePatternPainter extends CustomPainter {
  final double animationValue;
  final double shimmerValue;
  final bool isTopArea;

  EnhancedWavePatternPainter(this.animationValue, this.shimmerValue, {required this.isTopArea});

  @override
  void paint(Canvas canvas, Size size) {
    // Multiple wave layers with different opacities
    final waveConfigs = [
      {'strokeWidth': 2.0, 'alpha': 0.08, 'frequency': 0.8},
      {'strokeWidth': 1.5, 'alpha': 0.06, 'frequency': 1.2},
      {'strokeWidth': 1.0, 'alpha': 0.04, 'frequency': 1.6},
    ];

    for (int layer = 0; layer < waveConfigs.length; layer++) {
      final config = waveConfigs[layer];
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: config['alpha']! + (shimmerValue * 0.02))
        ..strokeWidth = config['strokeWidth']!
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < 4; i++) {
        final path = Path();
        double baseYOffset = isTopArea
            ? size.height * 0.15 + (i * 30)
            : size.height * 0.5 + (i * 25);

        double waveOffset = animationValue * (isTopArea ? 40 : -40) * config['frequency']!;
        double amplitude = (8 + (i * 2)) * (layer + 1);

        path.moveTo(0, baseYOffset);

        for (double x = 0; x <= size.width; x += 10) {
          double y = baseYOffset +
              amplitude * sin((x + waveOffset) * 0.02 * config['frequency']!) +
              (amplitude * 0.3) * sin((x + waveOffset) * 0.05 * config['frequency']!);

          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }

        canvas.drawPath(path, paint);
      }
    }

    // Enhanced animated dots with glow
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06 + (shimmerValue * 0.04))
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03 + (shimmerValue * 0.02))
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      double x = (size.width / 12) * i + (animationValue * (isTopArea ? 20 : -20));
      double y = isTopArea
          ? size.height * 0.25 + (i % 3) * 25 + (shimmerValue * 12)
          : size.height * 0.65 + (i % 3) * 20 + (shimmerValue * -12);

      double radius = 1.5 + (shimmerValue * 0.8);
      double glowRadius = radius * 3;

      if (x >= -glowRadius && x <= size.width + glowRadius) {
        // Draw glow
        canvas.drawCircle(Offset(x, y), glowRadius, glowPaint);
        // Draw dot
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// New shimmer effect painter
class ShimmerEffectPainter extends CustomPainter {
  final double animationValue;

  ShimmerEffectPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.03 + (animationValue * 0.02)),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create diagonal shimmer bands
    for (int i = 0; i < 3; i++) {
      final path = Path();
      double bandWidth = 60;
      double spacing = 150;
      double x = -bandWidth + (animationValue * (size.width + bandWidth * 2)) - (i * spacing);

      path.moveTo(x, 0);
      path.lineTo(x + bandWidth, 0);
      path.lineTo(x + bandWidth + size.height * 0.3, size.height);
      path.lineTo(x + size.height * 0.3, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Light rays painter for connecting effects
class LightRaysPainter extends CustomPainter {
  final double animationValue;

  LightRaysPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04 + (animationValue * 0.02))
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw connecting rays between top and bottom purple areas
    for (int i = 0; i < 6; i++) {
      double startX = size.width * 0.1 + (i * size.width * 0.15);
      double startY = size.height * 0.3;
      double endX = size.width * 0.2 + (i * size.width * 0.12);
      double endY = size.height * 0.7;

      // Add some wave motion to the rays
      double midX = (startX + endX) / 2 + (20 * sin(animationValue * 6.28 + i));
      double midY = (startY + endY) / 2;

      final path = Path();
      path.moveTo(startX, startY);
      path.quadraticBezierTo(midX, midY, endX, endY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
