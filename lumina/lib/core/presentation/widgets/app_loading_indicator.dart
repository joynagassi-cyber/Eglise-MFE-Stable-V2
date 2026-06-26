import 'package:flutter/material.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FireShimmer(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white12
                : Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
