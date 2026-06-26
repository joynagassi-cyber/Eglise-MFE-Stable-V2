import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const FireLogoSandbox());
}

class FireLogoSandbox extends StatelessWidget {
  const FireLogoSandbox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fire Logo Preview',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1225),
      ),
      home: const Scaffold(
        body: Center(
          child: OrganicFireLogo(size: 200),
        ),
      ),
    );
  }
}

class OrganicFireLogo extends StatefulWidget {
  final double size;

  const OrganicFireLogo({
    super.key,
    this.size = 200,
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
    _engine = _FireEngine(particleCount: 200);
    _ticker = createTicker((elapsed) {
      setState(() {
        _engine.update(0.016); // Simulate ~60fps step
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.5, // Taller to allow fire to rise
      child: ShaderMask(
        shaderCallback: (bounds) {
          // L'effet d'émergence : au début, le masque est transparent (invisible), puis le logo apparaît en creux
          // Pour la démo, on utilise un dégradé ou une Shape simple si l'image n'est pas chargée.
          // Mais dans le vrai app, on utilisera une image comme masque.
          return RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [Colors.white, Colors.white.withOpacity(0.1)],
            stops: const [0.5, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: CustomPaint(
          painter: _OrganicFirePainter(_engine),
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
  double heatOffset; // Controls standard color temperature deviation

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

  _FireEngine({this.particleCount = 250}) {
    for (int i = 0; i < particleCount; i++) {
      particles.add(_spawnParticle(true));
    }
  }

  _Particle _spawnParticle(bool randomY) {
    // Les flammes naissent en bas au centre, avec une légère dispersion
    final startX = 0.5 + (_rnd.nextDouble() - 0.5) * 0.4;

    return _Particle(
      x: startX,
      y: randomY ? _rnd.nextDouble() : 0.95 + _rnd.nextDouble() * 0.1,
      vx: (_rnd.nextDouble() - 0.5) * 0.15, // Légère dérive initiale
      vy: -0.3 - _rnd.nextDouble() * 0.6, // Grosse vitesse ascendante
      life: 1.0,
      maxLife: 0.6 + _rnd.nextDouble() * 1.8,
      size: 10.0 + _rnd.nextDouble() * 30.0,
    );
  }

  void update(double dt) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];

      // Update position
      p.x += p.vx * dt;
      p.y += p.vy * dt;

      // Add wind/noise effect -> Organic movement
      // La force du vent augmente à mesure qu'on monte
      final heightFactor = 1.0 - p.y;
      p.vx += sin(p.y * 15.0 + p.phase) * dt * 0.8 * heightFactor;

      // Shrink effect
      p.size -= dt * 5.0;

      // Decrease life
      p.life -= (dt / p.maxLife);

      // Respawn if dead, out of bounds, or too small
      if (p.life <= 0 || p.y < -0.1 || p.size <= 0) {
        particles[i] = _spawnParticle(false);
      }
    }
  }
}

class _OrganicFirePainter extends CustomPainter {
  final _FireEngine engine;

  _OrganicFirePainter(this.engine);

  Color _getTemperatureColor(double life, double heatOffset) {
    // Plus la vie est proche de 1, plus c'est chaud (Blanc/Jaune)
    // Plus la vie approche 0, plus c'est froid (Rouge/Noir)

    // Ajout d'une petite variation aléatoire (heatOffset) pour éviter l'uniformité
    double t = life * 0.8 + heatOffset * 0.2;
    t = t.clamp(0.0, 1.0);

    if (t > 0.8) {
      return Color.lerp(const Color(0xFFFFD700), const Color(0xFFFFFFFF),
          (t - 0.8) / 0.2)!; // Yellow to White
    } else if (t > 0.5) {
      return Color.lerp(const Color(0xFFFF4500), const Color(0xFFFFD700),
          (t - 0.5) / 0.3)!; // Red-Orange to Yellow
    } else if (t > 0.2) {
      return Color.lerp(const Color(0xAA8B0000), const Color(0xFFFF4500),
          (t - 0.2) / 0.3)!; // Dark Red to Red-Orange
    } else {
      return Color.lerp(const Color(0x00000000), const Color(0xAA8B0000),
          t / 0.2)!; // Transparent to Dark Red
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Fond légèrement lumineux pour l'ambiance (Halo centré bas)
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.bottomCenter,
        radius: 0.8,
        colors: [
          Color(0x44FF4500),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Dessin des particules avec BlendMode.screen
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal, 12.0) // Flou pour l'aspect gaz/plasma
      ..blendMode =
          BlendMode.screen; // Addition de lumière cruciale pour le feu

    for (final p in engine.particles) {
      if (p.size <= 0) continue;

      // Opacité liée à la vie
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