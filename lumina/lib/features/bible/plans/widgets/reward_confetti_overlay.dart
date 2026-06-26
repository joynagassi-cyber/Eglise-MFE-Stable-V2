import 'package:confetti/confetti.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';


/// Full-screen confetti overlay for plan completion celebrations.
/// Usage: `RewardConfettiOverlay.show(context, onDismiss: () {...})`
class RewardConfettiOverlay extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onDismiss;

  const RewardConfettiOverlay({
    super.key,
    this.title = '🎉 Félicitations !',
    this.subtitle = 'Plan de lecture complété avec succès',
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    String title = '🎉 Félicitations !',
    String subtitle = 'Plan de lecture complété avec succès',
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RewardConfettiOverlay(
        title: title,
        subtitle: subtitle,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<RewardConfettiOverlay> createState() => _RewardConfettiOverlayState();
}

class _RewardConfettiOverlayState extends State<RewardConfettiOverlay> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Dark overlay
        GestureDetector(
          onTap: _dismiss,
          child: Container(color: Colors.black54),
        ),

        // Confetti from top center
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 30,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.2,
            colors: [
              Colors.amber,
              Colors.orange,
              Colors.deepOrange,
              colors.brandPrimary,
              colors.brandSecondary,
              Colors.yellow,
            ],
          ),
        ),

        // Content card
        Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: colors.brandPrimary.withValues(alpha: 0.3),
                  blurRadius: 12.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade400, Colors.orange.shade600],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: _dismiss,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.brandPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Continuer', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _dismiss() {
    Navigator.pop(context);
    widget.onDismiss?.call();
  }
}
