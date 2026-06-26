// lib/features/auth/presentation/widgets/3d_cross_visual.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class ThreeDCrossVisual extends StatefulWidget {
  const ThreeDCrossVisual({super.key});

  @override
  State<ThreeDCrossVisual> createState() => _ThreeDCrossVisualState();
}

class _ThreeDCrossVisualState extends State<ThreeDCrossVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Orbiting circles
            ...List.generate(4, (index) {
              final angle =
                  (_controller.value * 2 * math.pi) + (index * math.pi / 2);
              return Transform.translate(
                offset: Offset(
                  math.cos(angle) * (60 + index * 5),
                  math.sin(angle) * (60 + index * 5),
                ),
                child: Opacity(
                  opacity: 0.3 + (0.1 * index),
                  child: Container(
                    width: 20 + (index * 4),
                    height: 20 + (index * 4),
                    decoration: BoxDecoration(
                      color: AppColors.luminaBlue.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                    child: Icon(
                      _getIconForIndex(index),
                      size: 10 + (index * 2),
                      color: AppColors.luminaGold,
                    ),
                  ),
                ),
              );
            }),
            // Central Flaming Cross
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.luminaGold.withOpacity(0.1),
                    blurRadius: 12.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: CrossFlamePainter(_controller.value),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.people_outline;
      case 1:
        return Icons.auto_awesome;
      case 2:
        return Icons.calendar_today_outlined;
      case 3:
        return Icons.flash_on_outlined;
      default:
        return Icons.star_outline;
    }
  }
}

class CrossFlamePainter extends CustomPainter {
  final double progress;
  CrossFlamePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // Glass Cross Effect
    final crossPath = Path()
      ..moveTo(center.dx, center.dy - 50)
      ..lineTo(center.dx, center.dy + 50)
      ..moveTo(center.dx - 30, center.dy - 10)
      ..lineTo(center.dx + 30, center.dy - 10);

    paint.color = Colors.white.withOpacity(0.4);
    canvas.drawPath(crossPath, paint);

    // Inner Flame
    final flamePaint = Paint()
      ..color = AppColors.luminaGold.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawCircle(
      Offset(center.dx, center.dy - 10 + math.sin(progress * 2 * math.pi) * 5),
      12,
      flamePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CrossFlamePainter oldDelegate) => true;
}
