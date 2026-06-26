import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import '../extensions/context_extension.dart';

/// Bouton d'action social avec effet de "Glow" et particules de lumière.
/// Utilisé pour transformer le simple "Like" en une "Action de Grâce".
class LuminaGlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;

  const LuminaGlowButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.activeColor,
  });

  @override
  State<LuminaGlowButton> createState() => _LuminaGlowButtonState();
}

class _LuminaGlowButtonState extends State<LuminaGlowButton> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticHelper.medium();
    if (!widget.isActive) {
      _confettiController.play();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive 
        ? (widget.activeColor ?? LuminaDesign.primary) 
        : context.colors.textTertiary;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Particules de lumière (Confetti)
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            LuminaDesign.primary,
            LuminaDesign.secondary,
            Colors.white,
            Colors.amber,
          ],
          numberOfParticles: 15,
          gravity: 0.1,
        ),
        
        // Le bouton
        InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(LuminaDesign.radiusSm),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isActive ? color.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(LuminaDesign.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: color,
                ),
                SizedBox(width: 8),
                Text(
                  widget.label,
                  style: LuminaDesign.labelOf(context).copyWith(
                    color: color,
                    fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
