import 'package:flutter/material.dart';

class RestorationWrapper extends StatefulWidget {
  final Widget child;
  const RestorationWrapper({super.key, required this.child});

  @override
  State<RestorationWrapper> createState() => _RestorationWrapperState();
}

class _RestorationWrapperState extends State<RestorationWrapper>
    with RestorationMixin {
  @override
  String? get restorationId => 'app_root';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // State restoration handled by GoRouter and providers
    // This ensures the restoration framework is active
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
