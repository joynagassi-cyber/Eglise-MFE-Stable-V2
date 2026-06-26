import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_typography.dart';

class PremiumSplashScreen extends ConsumerStatefulWidget {
  const PremiumSplashScreen({super.key});

  @override
  ConsumerState<PremiumSplashScreen> createState() =>
      _PremiumSplashScreenState();
}

class _PremiumSplashScreenState extends ConsumerState<PremiumSplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: isDark
                  ? RadialGradient(
                      center: Alignment.center,
                      radius: 1.5,
                      colors: [
                        context.colors.bgCard,
                        context.colors.bgPage,
                      ],
                    )
                  : RadialGradient(
                      center: Alignment.center,
                      radius: 1.5,
                      colors: [
                        context.colors.brandPrimary.withValues(alpha: 0.05),
                        context.colors.bgPage,
                      ],
                    ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo statique (haute qualité)
                Semantics(
                  label: 'Logo Lumina',
                  image: true,
                  child: Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'assets/icon/launcher_icon.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Semantics(
                  header: true,
                  label: 'Lumina Application',
                  child: Text(
                    'LUMINA',
                    style: AppTypography.headlineLarge.copyWith(
                      color: context.colors.brandPrimary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8,
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms),
                SizedBox(height: 24),
                const ShimmerBox(
                  width: 40,
                  height: 4,
                  borderRadius: 2,
                ).animate(onPlay: (c) => c.repeat()).shimmer(
                      duration: 1500.ms,
                      color: context.colors.brandPrimary.withValues(alpha: 0.2),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
