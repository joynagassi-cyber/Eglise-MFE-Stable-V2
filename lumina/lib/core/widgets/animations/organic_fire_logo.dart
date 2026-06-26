import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class OrganicFireLogo extends StatefulWidget {
  final double size;
  final String imagePath; // Path to the logo to use as a mask

  const OrganicFireLogo({
    super.key,
    this.size = 200,
    required this.imagePath,
  });

  @override
  State<OrganicFireLogo> createState() => _OrganicFireLogoState();
}

class _OrganicFireLogoState extends State<OrganicFireLogo>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late _FireEngine _engine;

  @override
  void initState() {
    super.initState();
    // LIMIT TO 200 PARTICLES FOR PERFORMANCE GUARANTEE
    _engine = _FireEngine(particleCount: 200);
    _ticker = createTicker((elapsed) {
      if (mounted) {
        setState(() {
          _engine.update(0.016); // Simulate ~60fps step
        });
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    // CRITICAL SAFETY CHECK: Kill ticker immediately on unmount
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      // The ShaderMask carves the fire animation into the shape of the logo
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          // Fallback radial gradient if something goes wrong, but BlendMode.dstIn
          // relies primarily on the alpha channel of the child image.
          return RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [Colors.white, Colors.white.withOpacity(0.1)],
            stops: const [0.5, 1.0],
          ).createShader(bounds);
        },
        // dstIn means: only show the CustomPaint (fire) where the child (Image) is NOT transparent
        blendMode: BlendMode.dstIn,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The fire animation
            Positioned.fill(
              child: CustomPaint(
                painter: _OrganicFirePainter(_engine, context.colors),
              ),
            ),
            // The logo image that provides the alpha mask
            // We use color: Colors.black to make sure it's solid for the mask,
            // though dstIn uses its alpha channel.
            Image.asset(
              widget.imagePath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
              // Use black with standard srcIn to create a solid silhouette mask
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  double x, y;
  double vx, vy;
  double life, maxLife;
  double size;
  double phase;
  double heatOffset;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    required this.maxLife,
    required this.size,
  })  : phase = Random().nextDouble() * 2 * pi,
        heatOffset = Random().nextDouble();
}

class _FireEngine {
  final List<_Particle> particles = [];
  final Random _rnd = Random();
  final int particleCount;

  _FireEngine({this.particleCount = 200}) {
    for (int i = 0; i < particleCount; i++) {
      particles.add(_spawnParticle(true));
    }
  }

  _Particle _spawnParticle(bool randomY) {
    // Spawn spread across the bottom width to fill the logo area
    final startX = _rnd.nextDouble();

    return _Particle(
      x: startX,
      // start slightly below the logo to avoid a hard cut-off line
      y: randomY ? _rnd.nextDouble() : 1.0 + _rnd.nextDouble() * 0.1,
      vx: (_rnd.nextDouble() - 0.5) * 0.15,
      vy: -0.3 - _rnd.nextDouble() * 0.6, // Fast rising
      life: 1.0,
      maxLife: 0.6 + _rnd.nextDouble() * 1.8,
      size: 15.0 + _rnd.nextDouble() * 35.0, // Larger particles
    );
  }

  void update(double dt) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];

      p.x += p.vx * dt;
      p.y += p.vy * dt;

      // Wind/Noise
      final heightFactor = 1.0 - p.y;
      p.vx += sin(p.y * 15.0 + p.phase) * dt * 0.8 * heightFactor;

      // Shrink
      p.size -= dt * 5.0;
      p.life -= (dt / p.maxLife);

      if (p.life <= 0 || p.y < -0.2 || p.size <= 0) {
        particles[i] = _spawnParticle(false);
      }
    }
  }
}

class _OrganicFirePainter extends CustomPainter {
  final _FireEngine engine;
  final LuminaColorsExtension colors;

  _OrganicFirePainter(this.engine, this.colors);

  Color _getTemperatureColor(double life, double heatOffset) {
    double t = life * 0.8 + heatOffset * 0.2;
    t = t.clamp(0.0, 1.0);

    if (t > 0.8) {
      return Color.lerp(colors.brandSecondary, Colors.white, (t - 0.8) / 0.2)!;
    } else if (t > 0.5) {
      return Color.lerp(
          LuminaBrand.orange, colors.brandSecondary, (t - 0.5) / 0.3)!;
    } else if (t > 0.2) {
      return Color.lerp(colors.brandPrimaryDark.withOpacity(0.67),
          LuminaBrand.orange, (t - 0.2) / 0.3)!;
    } else {
      return Color.lerp(Colors.transparent,
          colors.brandPrimaryDark.withOpacity(0.67), t / 0.2)!;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Ambient glow
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.bottomCenter,
        radius: 0.9,
        colors: [
          LuminaBrand.orange.withOpacity(0.33),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
      ..blendMode = BlendMode.screen;

    for (final p in engine.particles) {
      if (p.size <= 0) continue;

      final fade = max(0.0, p.life);
      paint.color =
          _getTemperatureColor(p.life, p.heatOffset).withOpacity(fade);

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrganicFirePainter oldDelegate) => true;
}
