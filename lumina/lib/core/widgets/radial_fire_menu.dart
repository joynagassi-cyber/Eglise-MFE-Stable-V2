import 'dart:math' as math;
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'apple_style_widgets.dart';
import 'duo_tone_icon.dart';

class RadialMenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  RadialMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class RadialFireMenu extends StatefulWidget {
  final List<RadialMenuItem> items;
  final double radius;

  const RadialFireMenu({
    super.key,
    required this.items,
    this.radius = 110.0,
  });

  @override
  State<RadialFireMenu> createState() => _RadialFireMenuState();
}

class _RadialFireMenuState extends State<RadialFireMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // Overlay pour fermer le menu si on clique ailleurs
        if (_isOpen)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),

        // Les items du menu radial
        ...List.generate(widget.items.length, (index) {
          return _buildRadialItem(index);
        }),

        // Le bouton central "+" enflammé
        ElasticPressable(
          onTap: _toggleMenu,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  context.colors.warningText,
                  Colors.orangeAccent,
                  context.colors.warningText,
                ],
                transform: GradientRotation(_controller.value * math.pi * 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colors.warningText.withValues(alpha: 0.5),
                  blurRadius: 12.0,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: _isOpen ? 0.125 : 0, // 45 degrés
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadialItem(int index) {
    // Calcul de l'angle pour chaque item sur 180 degrés
    // On commence à 180° (gauche) et on finit à 0° (droite)
    // Pour 3 items : 150°, 90°, 30°
    final double angleStep = 180 / (widget.items.length + 1);
    final double angleInDegrees = 180 - (angleStep * (index + 1));
    final double angleInRadians = angleInDegrees * (math.pi / 180);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.elasticOut,
          ),
        ).value;

        final double x = progress * widget.radius * math.cos(angleInRadians);
        final double y = progress * widget.radius * math.sin(angleInRadians);

        return Positioned(
          bottom: 32 + y, // On part du centre du bouton "plus"
          left: (MediaQuery.of(context).size.width / 2) +
              x -
              28, // 28 = rayon de l'item (56 / 2)
          child: Opacity(
            opacity: progress.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: progress,
              child: child,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElasticPressable(
            onTap: () {
              widget.items[index].onTap();
              _toggleMenu();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.6),
                border: Border.all(
                  color: widget.items[index].color.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.items[index].color.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: DuoToneIcon(
                  icon: widget.items[index].icon,
                  size: 24,
                  color: widget.items[index].color,
                  isFlamboyant: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Material(
            color: Colors.transparent,
            child: Text(
              widget.items[index].label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
