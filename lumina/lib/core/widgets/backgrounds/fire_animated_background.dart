import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:ui';

class FireAnimatedBackground extends StatefulWidget {
  final Widget? child;
  const FireAnimatedBackground({super.key, this.child});

  @override
  State<FireAnimatedBackground> createState() => _FireAnimatedBackgroundState();
}

class _FireAnimatedBackgroundState extends State<FireAnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // Animations pour les blobs
  late Animation<Offset> _blob1Anim;
  late Animation<Offset> _blob2Anim;
  late Animation<Offset> _blob3Anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _blob1Anim = Tween<Offset>(
      begin: const Offset(-0.2, -0.2),
      end: const Offset(0.2, 0.1),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    _blob2Anim = Tween<Offset>(
      begin: const Offset(1.1, 0.5),
      end: const Offset(0.8, 0.8),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    _blob3Anim = Tween<Offset>(
      begin: const Offset(0.5, 1.2),
      end: const Offset(0.2, 0.9),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Couleurs adaptées au thème mais gardant l'esprit "Feu"
    final bgBase = context.colors.bgPage;
    final color1 = context.colors.brandPrimary.withOpacity(0.4);
    final color2 = context.colors.brandSecondary.withOpacity(0.3);
    final color3 = Colors.purpleAccent.withOpacity(0.2); // Touche mystique

    return Stack(
      children: [
        // Fond uni
        Container(color: bgBase),

        // Blob 1 (Orange)
        SlideTransition(
          position: _blob1Anim,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color1,
              boxShadow: [
                BoxShadow(
                  color: color1,
                  blurRadius: 100,
                  spreadRadius: 2.0,
                ),
              ],
            ),
          ),
        ),

        // Blob 2 (Gold)
        SlideTransition(
          position: _blob2Anim,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color2,
                boxShadow: [
                  BoxShadow(
                    color: color2,
                    blurRadius: 120,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Blob 3 (Purple/Accent)
        SlideTransition(
          position: _blob3Anim,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color3,
                boxShadow: [
                  BoxShadow(
                    color: color3,
                    blurRadius: 12.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Glass Overlay pour unifier
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              color: Colors.transparent, // Nécessaire pour l'effet
            ),
          ),
        ),

        // Pattern léger ou grain ? (Optionnel)
        // ...

        if (widget.child != null) widget.child!,
      ],
    );
  }
}
