import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';

/// Widget Premium simulant un parchemin sacré pour les documents officiels,
/// les preuves de scellage (Sealing) et les certificats de sacrements.
class SacredScroll extends StatelessWidget {
  final Widget child;
  final String? sealLabel;
  final Color? sealColor;

  const SacredScroll({
    super.key,
    required this.child,
    this.sealLabel,
    this.sealColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5E6), // Couleur "Old Lace" (Papier ancien)
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.brown.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Texture de bordure (effet rouleau)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.brown.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 48,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Contenu du document
                DefaultTextStyle(
                  style: GoogleFonts.lora(
                    color: const Color(0xFF2C1E11),
                    fontSize: 16,
                    height: 1.6,
                  ),
                  child: child,
                ),
                
                if (sealLabel != null) ...[
                  const SizedBox(height: 40),
                  _WaxSeal(label: sealLabel!, color: sealColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sceau de cire numérique Lumina
class _WaxSeal extends StatelessWidget {
  final String label;
  final Color? color;

  const _WaxSeal({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? LuminaDesign.primary;
    
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: baseColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
          // Effet de relief (bordure interne)
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 0,
            spreadRadius: -4,
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
