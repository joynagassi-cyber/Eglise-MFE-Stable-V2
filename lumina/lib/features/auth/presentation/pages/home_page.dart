// lib/features/auth/presentation/pages/home_page.dart
//
// Page d'accueil — Redesign Premium "Fire & Gospel" v3.0
// Variante Bicolore : Header Orange avec Particules & Body Blanc avec grille en losanges.

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: Column(
        children: [
          // ─── HEADER ORANGE ───────────────────────────────────────────
          _buildHeaderSection(size, isSmallScreen),

          // ─── BODY BLANC ──────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 10.0 : 20.0),
                        child: _buildDiamondGrid(),
                      ),
                    ),
                  ),
                ),
                _buildBottomSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(Size size, bool isSmallScreen) {
    // Hauteur proportionnelle pour le header (moins haut sur petits écrans)
    final headerHeight =
        isSmallScreen ? size.height * 0.40 : size.height * 0.45;

    return Container(
      width: double.infinity,
      height: headerHeight,
      decoration: BoxDecoration(
        gradient: context.colors.brandGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        child: Stack(
          children: [
            // Particules et motifs décoratifs
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SparksPainter(progress: _controller.value, sparkColor: context.colors.textInverse),
                  );
                },
              ),
            ),

            // Contenu du Header
            SafeArea(
              bottom: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Logo de l'église MFE-JC ──
                    Container(
                      width: isSmallScreen ? 90 : 110,
                      height: isSmallScreen ? 90 : 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.15),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.35),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.2),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icon/church_logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback icône feu si l'image n'est pas trouvée
                              return Icon(
                                Icons.local_fire_department_rounded,
                                size: isSmallScreen ? 40 : 50,
                                color: Theme.of(context).colorScheme.onPrimary,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 20),

                    // Titres
                    Text(
                      'BIENVENUE SUR',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text(
                      'LUMINA',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: isSmallScreen ? 34 : 42,
                        fontWeight: FontWeight.w900,
                        fontFamily: LuminaFont.display,
                        letterSpacing: 4.0,
                      ),
                    ),
                    Container(
                      height: 3,
                      width: 60,
                      margin:
                          EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // MFE-JC (nom de l'église)
                    Text(
                      'MFE-JC',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.85),
                        fontSize: isSmallScreen ? 16 : 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6,
                      ),
                    ),

                    // Slogan
                    Padding(
                      padding: EdgeInsets.only(
                          top: isSmallScreen ? 6.0 : 12.0, left: 32, right: 32),
                      child: Text(
                        "Mission du Feu Évangélique\nJésus-Christ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.7),
                          fontSize: isSmallScreen ? 11 : 13,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiamondGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 0,
        runSpacing: -35,
        alignment: WrapAlignment.center,
        children: [
          _buildDiamondCard(Icons.church_rounded, 'Église'),
          _buildDiamondCard(Icons.account_balance_rounded, 'Caisse'),
          _buildDiamondCard(Icons.insert_chart_rounded, 'Rapports'),
          _buildDiamondCard(Icons.volunteer_activism_rounded, 'Portefeuille'),
          _buildDiamondCard(Icons.groups_rounded, 'Membres'),
          _buildDiamondCard(Icons.hub_rounded, 'Communauté'),
        ],
      ),
    );
  }

  Widget _buildDiamondCard(IconData icon, String title) {
    // La taille visuelle du losange
    const double size = 80.0;
    // Bounding box d'un carré tourné de 45° : d = côté * sqrt(2) ≈ size * 1.414
    const double boundingBoxSize = size * 1.414;

    return SizedBox(
      width: boundingBoxSize,
      height: boundingBoxSize,
      child: Center(
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: context.colors.bgCard,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: context.colors.brandPrimary.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(3, 3), // L'ombre tournera aussi
                ),
              ],
              border: Border.all(
                  color: context.colors.brandPrimary.withOpacity(0.15), width: 1.5),
            ),
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: context.colors.brandPrimary, size: 28),
                  SizedBox(height: 6),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.0,
        right: 32.0,
        bottom: MediaQuery.of(context).padding.bottom + 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton Principal
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: context.colors.brandGradient,
              boxShadow: [
                BoxShadow(
                  color: context.colors.brandPrimary.withOpacity(0.3),
                  blurRadius: 12.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () =>
                  context.go(AppRoutes.register),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'COMMENCER',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          // Bouton Secondaire (Discret)
          TextButton(
            onPressed: () =>
                context.go(AppRoutes.login),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.brandPrimary,
            ),
            child: Text(
              'SE CONNECTER',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SparksPainter extends CustomPainter {
  final double progress;
  final Color sparkColor;
  SparksPainter({required this.progress, required this.sparkColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Fond de base (Lueurs massives)
    _drawBaseGlows(canvas, size);

    // 2. Grandes formes géométriques translucides (Triangles, Cercles)
    _drawGeometricShapes(canvas, size);

    // 3. Motif de croix subtil
    _drawCrossPattern(canvas, size);

    // 4. Rayons de lumière (Light rays)
    _drawLightRays(canvas, size);

    // 5. Particules dynamiques (Étoiles animées et losanges)
    _drawDynamicParticles(canvas, size);
  }

  void _drawBaseGlows(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = sparkColor.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    // Lueur centrale derrière le logo
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.3),
      size.width * 0.6,
      glowPaint,
    );

    // Lueur pulsante en haut à droite
    canvas.drawCircle(
      Offset(size.width * 0.9,
          size.height * 0.1 + math.sin(progress * math.pi * 2) * 15),
      size.width * 0.4,
      Paint()
        ..color = sparkColor
            .withOpacity(0.05 + (math.sin(progress * math.pi) * 0.03))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0),
    );
  }

  void _drawGeometricShapes(Canvas canvas, Size size) {
    // Grand cercle fin à gauche
    final circlePaint = Paint()
      ..color = sparkColor.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5),
        size.width * 0.4, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5),
        size.width * 0.45, circlePaint..strokeWidth = 1);

    // Grand triangle translucide pivoté
    final path = Path();
    canvas.save();
    canvas.translate(size.width * 0.8, size.height * 0.6);
    canvas.rotate(math.pi / 6 + (progress * 0.1)); // Rotation très lente

    path.moveTo(0, -size.width * 0.3);
    path.lineTo(size.width * 0.25, size.width * 0.2);
    path.lineTo(-size.width * 0.25, size.width * 0.2);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = sparkColor.withOpacity(0.03)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = sparkColor.withOpacity(0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.restore();
  }

  void _drawCrossPattern(Canvas canvas, Size size) {
    final crossPaint = Paint()
      ..color = sparkColor.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 100.0;
    const crossSize = 25.0;

    for (var x = 0.0; x < size.width + spacing; x += spacing) {
      for (var y = 0.0; y < size.height + spacing; y += spacing) {
        // Décalage pour créer un motif en quinconce
        final offsetX = (y / spacing) % 2 == 0 ? 0.0 : spacing / 2;
        final px = x + offsetX;

        // Disparition progressive vers le bas
        final opacity = (1.0 - (y / size.height)).clamp(0.0, 1.0) * 0.04;
        crossPaint.color = sparkColor.withOpacity(opacity);

        canvas.drawLine(Offset(px - crossSize / 2, y),
            Offset(px + crossSize / 2, y), crossPaint);
        canvas.drawLine(Offset(px, y - crossSize / 2),
            Offset(px, y + crossSize / 2), crossPaint);
      }
    }
  }

  void _drawLightRays(Canvas canvas, Size size) {
    final center =
        Offset(size.width * 0.5, size.height * 0.25); // Centre du logo
    final rayPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          sparkColor.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width))
      ..style = PaintingStyle.fill;

    final random = math.Random(123);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress *
        math.pi *
        2 *
        0.05); // Rotation très lente du faisceau global

    for (var i = 0; i < 12; i++) {
      canvas.rotate(math.pi * 2 / 12);

      final path = Path();
      final width = 20.0 + random.nextDouble() * 30.0;
      final length = size.width * (0.8 + random.nextDouble() * 0.4);

      path.moveTo(-width / 2, 0);
      path.lineTo(width / 2, 0);
      path.lineTo(width * 2, length);
      path.lineTo(-width * 2, length);
      path.close();

      canvas.drawPath(path, rayPaint);
    }
    canvas.restore();
  }

  void _drawDynamicParticles(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    // 1. Étoiles à 4 branches (Astres)
    for (var i = 0; i < 15; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final scale = 0.5 + random.nextDouble() * 2.0;

      // Scintillement (twinkle)
      final twinkle = math.sin(progress * math.pi * 8 + i) * 0.5 + 0.5;
      final opacity = 0.1 + (twinkle * 0.3); // Effet de clignotement

      paint.color = sparkColor
          .withOpacity(opacity * (1.0 - startY / size.height).clamp(0.0, 1.0));

      _drawStarShape(canvas, Offset(startX, startY), 12 * scale, paint);
    }

    // 2. Particules ascendantes (Losanges de feu)
    for (var i = 0; i < 35; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final speed = 0.2 + random.nextDouble() * 0.8;
      final scale = 0.3 + random.nextDouble() * 1.0;

      // Mouvement vers le haut
      final currentY =
          (startY - (progress * size.height * speed)) % size.height;
      // Oscilliation horizontale légère
      final currentX =
          startX + math.sin(progress * math.pi * 4 * speed + i) * 15;

      final fadeOut = (currentY / size.height).clamp(0.0, 1.0);
      paint.color = sparkColor.withOpacity(0.2 * fadeOut);

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(math.pi / 4 +
          (progress * 2 * math.pi * speed)); // Tourne sur elle-même
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset.zero, width: 8 * scale, height: 8 * scale),
          paint);
      canvas.restore();
    }
  }

  // Helper pour dessiner une étoile à 4 branches (Star/Sparkle)
  void _drawStarShape(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final halfSize = size / 2;

    path.moveTo(center.dx, center.dy - halfSize);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx + halfSize, center.dy);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx, center.dy + halfSize);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx - halfSize, center.dy);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx, center.dy - halfSize);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparksPainter oldDelegate) => true;
}
