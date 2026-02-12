
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../global/constants/colors_resources.dart';
import '../../../../../global/global_widget/global_sized_box.dart';

class AuthBackGroundCom extends StatefulWidget {
  final List<Widget> children;
  const AuthBackGroundCom({
    super.key,
    this.children = const <Widget>[]
  });

  @override
  State<AuthBackGroundCom> createState() => _AuthBackGroundComState();
}

class _AuthBackGroundComState extends State<AuthBackGroundCom> with TickerProviderStateMixin {

  late AnimationController _fishController;
  late AnimationController _bubbleController;
  late AnimationController _waveController;
  late AnimationController _plantController;

  late Animation<double> _fishAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _plantAnimation;

  @override
  void initState() {
    super.initState();

    // Fish swimming animation
    _fishController = AnimationController(
      duration: Duration(seconds: 12),
      vsync: this,
    );
    _fishAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _fishController, curve: Curves.linear)
    );

    // Bubble floating animation
    _bubbleController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    );
    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _bubbleController, curve: Curves.linear)
    );

    // Water wave animation
    _waveController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _waveController, curve: Curves.linear)
    );

    // Plant sway animation
    _plantController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _plantAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _plantController, curve: Curves.easeInOut)
    );

    _fishController.repeat();
    _bubbleController.repeat();
    _waveController.repeat();
    _plantController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fishController.dispose();
    _bubbleController.dispose();
    _waveController.dispose();
    _plantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size(context).height,
      width: size(context).width,
      color: Colors.white,
      child: Stack(
        children: [
          // Deep ocean gradient background
          Container(
            height: size(context).height,
            width: size(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1215), // Deep dark at top
                  Color(0xFF0D1A1F), // Slightly lighter
                  Color(0xFF0E2028), // Middle ocean
                  Color(0xFF102530), // Bottom lighter
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Animated underwater effects
          AnimatedBuilder(
            animation: Listenable.merge([
              _fishAnimation,
              _bubbleAnimation,
              _waveAnimation,
              _plantAnimation,
            ]),
            builder: (context, child) => Stack(
              children: [
                // Light rays from top
                _buildLightRays(context),

                // Underwater plants at bottom
                _buildUnderwaterPlants(context),

                // Floating bubbles
                ..._buildBubbles(context),

                // Swimming fish
                ..._buildFish(context),

                // Water surface waves
                _buildWaterSurface(context),

                // Water particles
                ..._buildWaterParticles(context),

                // Subtle shimmer effect
                _buildShimmerEffect(context),
              ],
            ),
          ),

          // Content overlay
          Positioned(
            left: 10,
            right: 10,
            bottom: 0,
            top: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }

  // Build light rays from surface
  Widget _buildLightRays(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: LightRaysPainter(
          _waveAnimation.value,
          ColorRes.appButtonColor,
        ),
      ),
    );
  }

  // Build underwater plants
  Widget _buildUnderwaterPlants(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CustomPaint(
        size: Size(size(context).width, 200),
        painter: UnderwaterPlantsPainter(
          _plantAnimation.value,
          ColorRes.appButtonColor,
        ),
      ),
    );
  }

  // Build floating bubbles
  List<Widget> _buildBubbles(BuildContext context) {
    return List.generate(20, (index) {
      double animOffset = (index * 0.15) % 1.0;
      double progress = (_bubbleAnimation.value + animOffset) % 1.0;

      double xBase = (index * size(context).width * 0.055) % size(context).width;
      double drift = sin(progress * pi * 3 + index) * 25;

      double yPos = size(context).height - (progress * (size(context).height + 100)) + 50;

      return Positioned(
        left: xBase + drift,
        top: yPos,
        child: Opacity(
          opacity: (sin(progress * pi) * 0.5 + 0.3).clamp(0.2, 0.7),
          child: Container(
            width: 6 + (index % 5) * 3.0,
            height: 6 + (index % 5) * 3.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  ColorRes.appButtonColor.withValues(alpha: 0.4),
                  ColorRes.appButtonColor.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorRes.appButtonColor.withValues(alpha: 0.2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Build swimming fish
  List<Widget> _buildFish(BuildContext context) {
    return List.generate(6, (index) {
      double animOffset = (index * 0.2) % 1.0;
      double progress = (_fishAnimation.value + animOffset) % 1.0;

      // Alternate direction
      bool leftToRight = index % 2 == 0;
      double startX = leftToRight ? -120 : size(context).width + 120;
      double endX = leftToRight ? size(context).width + 120 : -120;
      double xPos = startX + (endX - startX) * progress;

      // Vertical position with wave motion
      double yBase = 80 + (index * 110);
      double yWave = sin(progress * pi * 4 + index) * 35;
      double yPos = yBase + yWave;

      // Fish size variation
      double fishSize = 50 + (index % 3) * 15.0;

      // Fish colors
      Color fishColor;
      switch (index % 4) {
        case 0:
          fishColor = ColorRes.appButtonColor; // Cyan
          break;
        case 1:
          fishColor = Color(0xFF00D9FF); // Light cyan
          break;
        case 2:
          fishColor = Color(0xFF0077B6); // Deep blue
          break;
        default:
          fishColor = Color(0xFF48CAE4); // Sky blue
      }

      return Positioned(
        left: xPos - fishSize / 2,
        top: yPos - fishSize / 2,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(leftToRight ? 1.0 : -1.0, 1.0),
          child: Opacity(
            opacity: 0.5 + (sin(progress * pi) * 0.3),
            child: CustomPaint(
              size: Size(fishSize, fishSize * 0.6),
              painter: FishPainter(color: fishColor),
            ),
          ),
        ),
      );
    });
  }

  // Build water surface waves
  Widget _buildWaterSurface(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: CustomPaint(
        size: Size(size(context).width, 150),
        painter: WaterSurfacePainter(
          _waveAnimation.value,
          ColorRes.appButtonColor,
        ),
      ),
    );
  }

  // Build water particles (small debris)
  List<Widget> _buildWaterParticles(BuildContext context) {
    return List.generate(30, (index) {
      double progress = (_fishAnimation.value + index * 0.1) % 1.0;

      double xPos = (index * size(context).width * 0.04) % size(context).width;
      double yPos = (size(context).height * 0.2) + (progress * size(context).height * 0.6);

      double drift = sin(progress * pi * 6 + index) * 15;

      return Positioned(
        left: xPos + drift,
        top: yPos,
        child: Opacity(
          opacity: 0.15 + (sin(progress * pi) * 0.1),
          child: Container(
            width: 2 + (index % 3),
            height: 2 + (index % 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorRes.appButtonColor.withValues(alpha: 0.3),
            ),
          ),
        ),
      );
    });
  }

  // Build shimmer effect
  Widget _buildShimmerEffect(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: ShimmerEffectPainter(
          _waveAnimation.value,
          ColorRes.appButtonColor,
        ),
      ),
    );
  }
}

// Fish painter
class FishPainter extends CustomPainter {
  final Color color;

  FishPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Main body
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.75, size.height * 0.5);
    bodyPath.quadraticBezierTo(
      size.width * 0.55, size.height * 0.15,
      size.width * 0.25, size.height * 0.25,
    );
    bodyPath.quadraticBezierTo(
      size.width * 0.05, size.height * 0.5,
      size.width * 0.25, size.height * 0.75,
    );
    bodyPath.quadraticBezierTo(
      size.width * 0.55, size.height * 0.85,
      size.width * 0.75, size.height * 0.5,
    );
    bodyPath.close();

    canvas.drawPath(bodyPath, paint);

    // Tail
    final tailPath = Path();
    tailPath.moveTo(size.width * 0.75, size.height * 0.5);
    tailPath.lineTo(size.width * 0.95, size.height * 0.2);
    tailPath.quadraticBezierTo(
      size.width * 0.88, size.height * 0.5,
      size.width * 0.95, size.height * 0.8,
    );
    tailPath.close();

    canvas.drawPath(tailPath, paint);

    // Top fin
    final topFinPath = Path();
    topFinPath.moveTo(size.width * 0.45, size.height * 0.35);
    topFinPath.quadraticBezierTo(
      size.width * 0.35, size.height * 0.05,
      size.width * 0.5, size.height * 0.25,
    );
    canvas.drawPath(topFinPath, paint);

    // Eye
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.42),
      size.width * 0.055,
      eyePaint,
    );

    // Pupil
    final pupilPaint = Paint()
      ..color = Color(0xFF0B1215)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.42),
      size.width * 0.025,
      pupilPaint,
    );

    // Body scales pattern
    final scalesPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.35 + i * 0.1), size.height * 0.5),
        size.width * 0.04,
        scalesPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Underwater plants painter
class UnderwaterPlantsPainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;

  UnderwaterPlantsPainter(this.animationValue, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw multiple seaweed plants
    for (int i = 0; i < 10; i++) {
      double xPos = (size.width / 11) * (i + 0.5);
      double sway = sin(animationValue * pi + i * 0.5) * 12;

      // Plant color variation
      Color plantColor = i % 3 == 0
          ? accentColor.withValues(alpha: 0.3)
          : Color(0xFF1B4D3E).withValues(alpha: 0.5);

      paint.color = plantColor;
      paint.strokeWidth = 4 + (i % 3) * 2;

      final plantPath = Path();
      plantPath.moveTo(xPos, size.height);

      // Draw wavy plant stem
      for (double y = size.height; y > size.height * 0.2; y -= 12) {
        double heightFactor = 1 - (y / size.height);
        double swayAmount = sway * heightFactor;
        plantPath.lineTo(xPos + swayAmount, y);
      }

      canvas.drawPath(plantPath, paint);

      // Draw leaves
      paint.style = PaintingStyle.fill;
      for (double y = size.height - 25; y > size.height * 0.3; y -= 30) {
        double heightFactor = 1 - (y / size.height);
        double swayAmount = sway * heightFactor;

        // Left leaf
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(xPos + swayAmount - 12, y),
            width: 16,
            height: 8,
          ),
          paint,
        );

        // Right leaf
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(xPos + swayAmount + 12, y - 8),
            width: 16,
            height: 8,
          ),
          paint,
        );
      }
      paint.style = PaintingStyle.stroke;
    }

    // Add some coral-like structures
    paint.style = PaintingStyle.fill;
    paint.color = accentColor.withValues(alpha: 0.2);

    for (int i = 0; i < 5; i++) {
      double xPos = size.width * (0.15 + i * 0.18);
      canvas.drawCircle(
        Offset(xPos, size.height - 10),
        8 + (i % 3) * 4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Light rays painter
class LightRaysPainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;

  LightRaysPainter(this.animationValue, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw light rays from top
    for (int i = 0; i < 5; i++) {
      double xStart = size.width * (0.15 + i * 0.18);
      double wobble = sin(animationValue * pi * 2 + i) * 20;

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accentColor.withValues(alpha: 0.08),
          accentColor.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
      );

      paint.shader = gradient.createShader(
        Rect.fromLTWH(xStart + wobble - 30, 0, 60, size.height * 0.6),
      );

      final rayPath = Path();
      rayPath.moveTo(xStart + wobble - 15, 0);
      rayPath.lineTo(xStart + wobble + 15, 0);
      rayPath.lineTo(xStart + wobble + 45, size.height * 0.6);
      rayPath.lineTo(xStart + wobble - 45, size.height * 0.6);
      rayPath.close();

      canvas.drawPath(rayPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Water surface painter
class WaterSurfacePainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;

  WaterSurfacePainter(this.animationValue, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Multiple wave layers
    for (int layer = 0; layer < 4; layer++) {
      paint.color = accentColor.withValues(alpha: 0.1 - layer * 0.02);

      final path = Path();
      double yBase = 30 + layer * 25;
      double offset = animationValue * 100 * (layer % 2 == 0 ? 1 : -1);

      for (double x = 0; x <= size.width; x += 8) {
        double y = yBase +
            18 * sin((x + offset) * 0.018) +
            8 * sin((x + offset) * 0.04);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Shimmer effect painter
class ShimmerEffectPainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;

  ShimmerEffectPainter(this.animationValue, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Diagonal shimmer moving across screen
    for (int i = 0; i < 2; i++) {
      double xPos = -200 + (animationValue * (size.width + 400)) - (i * 300);

      final gradient = LinearGradient(
        colors: [
          Colors.transparent,
          accentColor.withValues(alpha: 0.05),
          Colors.transparent,
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromLTWH(xPos, 0, 150, size.height),
      );

      final shimmerPath = Path();
      shimmerPath.moveTo(xPos, 0);
      shimmerPath.lineTo(xPos + 150, 0);
      shimmerPath.lineTo(xPos + 250, size.height);
      shimmerPath.lineTo(xPos + 100, size.height);
      shimmerPath.close();

      canvas.drawPath(shimmerPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../../../../global/constants/colors_resources.dart';
// import '../../../../../global/global_widget/global_sized_box.dart';
//
// class AuthBackGroundCom extends StatefulWidget {
//   final List<Widget> children;
//   const AuthBackGroundCom({
//     super.key,
//     this.children = const <Widget>[]
//   });
//
//   @override
//   State<AuthBackGroundCom> createState() => _AuthBackGroundComState();
// }
//
// class _AuthBackGroundComState extends State<AuthBackGroundCom> with TickerProviderStateMixin {
//
//   late AnimationController _particleController;
//   late AnimationController _waveController;
//   late AnimationController _glowController;
//   late AnimationController _floatController;
//
//   late Animation<double> _particleAnimation;
//   late Animation<double> _waveAnimation;
//   late Animation<double> _glowAnimation;
//   late Animation<double> _floatAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Floating particles animation
//     _particleController = AnimationController(
//       duration: Duration(seconds: 8),
//       vsync: this,
//     );
//     _particleAnimation = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _particleController, curve: Curves.linear)
//     );
//
//     // Wave animation
//     _waveController = AnimationController(
//       duration: Duration(seconds: 6),
//       vsync: this,
//     );
//     _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _waveController, curve: Curves.linear)
//     );
//
//     // Glow pulse animation
//     _glowController = AnimationController(
//       duration: Duration(seconds: 3),
//       vsync: this,
//     );
//     _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _glowController, curve: Curves.easeInOut)
//     );
//
//     // Float up and down animation
//     _floatController = AnimationController(
//       duration: Duration(seconds: 4),
//       vsync: this,
//     );
//     _floatAnimation = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _floatController, curve: Curves.easeInOut)
//     );
//
//     _particleController.repeat();
//     _waveController.repeat();
//     _glowController.repeat(reverse: true);
//     _floatController.repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _particleController.dispose();
//     _waveController.dispose();
//     _glowController.dispose();
//     _floatController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: size(context).height,
//       width: size(context).width,
//       color: Colors.white,
//       child: Stack(
//         children: [
//           // Deep dark gradient background
//           Container(
//             height: size(context).height,
//             width: size(context).width,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFF0B1215), // Main dark color
//                   Color(0xFF1A2428), // Slightly lighter
//                   Color(0xFF0B1215), // Back to main
//                   Color(0xFF0D1518), // Subtle variation
//                 ],
//                 stops: [0.0, 0.3, 0.7, 1.0],
//               ),
//             ),
//           ),
//
//           // Animated effects layer
//           AnimatedBuilder(
//             animation: Listenable.merge([
//               _particleAnimation,
//               _waveAnimation,
//               _glowAnimation,
//               _floatAnimation,
//             ]),
//             builder: (context, child) => Stack(
//               children: [
//                 // Animated gradient orbs
//                 ..._buildGradientOrbs(context),
//
//                 // Floating particles
//                 ..._buildFloatingParticles(context),
//
//                 // Animated waves
//                 _buildAnimatedWaves(context),
//
//                 // Glow effects
//                 ..._buildGlowEffects(context),
//
//                 // Grid pattern overlay
//                 _buildGridPattern(context),
//
//                 // Shimmer lines
//                 ..._buildShimmerLines(context),
//               ],
//             ),
//           ),
//
//           // Content overlay
//           Positioned(
//             left: 10,
//             right: 10,
//             bottom: 0,
//             top: 0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: widget.children,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Build gradient orbs (cyan accent moving circles)
//   List<Widget> _buildGradientOrbs(BuildContext context) {
//     return List.generate(3, (index) {
//       double progress = (_floatAnimation.value + index * 0.33) % 1.0;
//       double sized = 200 + (index * 80);
//
//       double xPos = size(context).width * (0.2 + index * 0.3);
//       double yPos = size(context).height * (0.2 + index * 0.25) +
//           (sin(progress * pi * 2) * 50);
//
//       return Positioned(
//         left: xPos - sized / 2,
//         top: yPos - sized / 2,
//         child: Container(
//           width: sized,
//           height: sized,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: RadialGradient(
//               colors: [
//                 ColorRes.appButtonColor.withValues(alpha: 0.15 + (_glowAnimation.value * 0.1)),
//                 ColorRes.appButtonColor.withValues(alpha: 0.05),
//                 Colors.transparent,
//               ],
//               stops: [0.0, 0.5, 1.0],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   // Build floating particles
//   List<Widget> _buildFloatingParticles(BuildContext context) {
//     return List.generate(25, (index) {
//       double animOffset = (index * 0.15) % 1.0;
//       double progress = (_particleAnimation.value + animOffset) % 1.0;
//
//       double xStart = (index * size(context).width * 0.05) % size(context).width;
//       double yProgress = progress * (size(context).height + 100) - 50;
//
//       double drift = sin(progress * pi * 4) * 30;
//
//       return Positioned(
//         left: xStart + drift,
//         top: yProgress,
//         child: Opacity(
//           opacity: (sin(progress * pi) * 0.6).clamp(0.2, 0.6),
//           child: Container(
//             width: 3 + (index % 5),
//             height: 3 + (index % 5),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: index % 3 == 0
//                   ? ColorRes.appButtonColor.withValues(alpha: 0.8)
//                   : ColorRes.cyan.withValues(alpha: 0.6),
//               boxShadow: [
//                 BoxShadow(
//                   color: ColorRes.appButtonColor.withValues(alpha: 0.3),
//                   blurRadius: 8,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   // Build animated waves
//   Widget _buildAnimatedWaves(BuildContext context) {
//     return Positioned.fill(
//       child: CustomPaint(
//         painter: DarkWavePainter(
//           _waveAnimation.value,
//           ColorRes.appButtonColor,
//         ),
//       ),
//     );
//   }
//
//   // Build glow effects
//   List<Widget> _buildGlowEffects(BuildContext context) {
//     return List.generate(4, (index) {
//       double progress = (_glowAnimation.value + index * 0.25) % 1.0;
//       double intensity = sin(progress * pi);
//
//       return Positioned(
//         left: size(context).width * (0.15 + index * 0.2),
//         top: size(context).height * (0.3 + index * 0.15),
//         child: Container(
//           width: 150 + (index * 30),
//           height: 150 + (index * 30),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: RadialGradient(
//               colors: [
//                 ColorRes.appButtonColor.withValues(alpha: 0.1 * intensity),
//                 Colors.transparent,
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   // Build grid pattern
//   Widget _buildGridPattern(BuildContext context) {
//     return Positioned.fill(
//       child: CustomPaint(
//         painter: GridPatternPainter(
//           _waveAnimation.value,
//           ColorRes.appButtonColor,
//         ),
//       ),
//     );
//   }
//
//   // Build shimmer lines
//   List<Widget> _buildShimmerLines(BuildContext context) {
//     return List.generate(6, (index) {
//       double progress = (_particleAnimation.value + index * 0.2) % 1.0;
//       double xPos = -200 + (progress * (size(context).width + 400));
//
//       return Positioned(
//         left: xPos,
//         top: size(context).height * (0.2 + index * 0.13),
//         child: Transform.rotate(
//           angle: -0.3,
//           child: Container(
//             width: 150,
//             height: 2,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   ColorRes.appButtonColor.withValues(alpha: 0.4),
//                   Colors.transparent,
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: ColorRes.appButtonColor.withValues(alpha: 0.2),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
//
// // Dark wave painter
// class DarkWavePainter extends CustomPainter {
//   final double animationValue;
//   final Color accentColor;
//
//   DarkWavePainter(this.animationValue, this.accentColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     // Multiple wave layers
//     for (int layer = 0; layer < 5; layer++) {
//       double alpha = 0.08 - (layer * 0.015);
//       paint.color = accentColor.withValues(alpha: alpha);
//
//       final path = Path();
//       double yBase = size.height * (0.2 + layer * 0.15);
//       double offset = animationValue * 100 * (layer % 2 == 0 ? 1 : -1);
//
//       for (double x = 0; x <= size.width; x += 8) {
//         double y = yBase +
//             20 * sin((x + offset) * 0.015) +
//             10 * sin((x + offset) * 0.03);
//
//         if (x == 0) {
//           path.moveTo(x, y);
//         } else {
//           path.lineTo(x, y);
//         }
//       }
//
//       canvas.drawPath(path, paint);
//     }
//
//     // Diagonal waves
//     for (int i = 0; i < 3; i++) {
//       paint.color = accentColor.withValues(alpha: 0.05);
//       paint.strokeWidth = 0.5;
//
//       final path = Path();
//       double xStart = -100 + (animationValue * 200) + (i * 150);
//
//       for (double y = 0; y <= size.height; y += 10) {
//         double x = xStart + (y * 0.3) + 30 * sin(y * 0.02);
//
//         if (y == 0) {
//           path.moveTo(x, y);
//         } else {
//           path.lineTo(x, y);
//         }
//       }
//
//       canvas.drawPath(path, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
//
// // Grid pattern painter
// class GridPatternPainter extends CustomPainter {
//   final double animationValue;
//   final Color accentColor;
//
//   GridPatternPainter(this.animationValue, this.accentColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = accentColor.withValues(alpha: 0.03)
//       ..strokeWidth = 0.5
//       ..style = PaintingStyle.stroke;
//
//     double spacing = 50;
//     double offset = animationValue * spacing;
//
//     // Vertical lines
//     for (double x = -spacing + offset; x < size.width + spacing; x += spacing) {
//       canvas.drawLine(
//         Offset(x, 0),
//         Offset(x, size.height),
//         paint,
//       );
//     }
//
//     // Horizontal lines
//     for (double y = -spacing + offset; y < size.height + spacing; y += spacing) {
//       canvas.drawLine(
//         Offset(0, y),
//         Offset(size.width, y),
//         paint,
//       );
//     }
//
//     // Highlight some grid intersections
//     paint.style = PaintingStyle.fill;
//     paint.color = accentColor.withValues(alpha: 0.1);
//
//     for (int i = 0; i < 20; i++) {
//       double x = (i * spacing * 1.5 + offset * 2) % size.width;
//       double y = (i * spacing * 2 + offset * 1.5) % size.height;
//
//       double pulseSize = 2 + (sin(animationValue * 6.28 + i) * 1);
//       canvas.drawCircle(Offset(x, y), pulseSize, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }