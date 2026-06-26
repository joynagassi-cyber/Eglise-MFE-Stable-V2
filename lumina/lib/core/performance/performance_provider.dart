import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'performance_monitor.dart';

part 'performance_provider.g.dart';

@riverpod
class SystemPerformance extends _$SystemPerformance {
  @override
  PerformanceStats build() {
    final monitor = PerformanceMonitor();

    monitor.setStatsListener((fps, memoryMb) {
      updateStats(fps: fps, memoryMb: memoryMb);
    });

    return const PerformanceStats(
      fps: 60,
      memoryMb: 0,
      isVisible: true,
      isExpanded: true,
      position: Offset(10, 50), // Position par défaut (droite, haut)
    );
  }

  void updateStats({double? fps, int? memoryMb}) {
    state = state.copyWith(
      fps: fps ?? state.fps,
      memoryMb: memoryMb ?? state.memoryMb,
    );
  }

  void toggleVisibility() {
    state = state.copyWith(isVisible: !state.isVisible);
  }

  void toggleExpansion() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  void updatePosition(Offset delta, Size screenSize) {
    // Calcul de la nouvelle position avec limites
    double newX = state.position.dx - delta.dx; // Car on part de la droite
    double newY = state.position.dy + delta.dy;

    // Limites de l'écran (approximatives)
    newX = newX.clamp(10.0, screenSize.width - 50.0);
    newY = newY.clamp(30.0, screenSize.height - 100.0);

    state = state.copyWith(position: Offset(newX, newY));
  }
}

class PerformanceStats {
  final double fps;
  final int memoryMb;
  final bool isVisible;
  final bool isExpanded;
  final Offset position;

  const PerformanceStats({
    required this.fps,
    required this.memoryMb,
    required this.isVisible,
    required this.isExpanded,
    required this.position,
  });

  PerformanceStats copyWith({
    double? fps,
    int? memoryMb,
    bool? isVisible,
    bool? isExpanded,
    Offset? position,
  }) {
    return PerformanceStats(
      fps: fps ?? this.fps,
      memoryMb: memoryMb ?? this.memoryMb,
      isVisible: isVisible ?? this.isVisible,
      isExpanded: isExpanded ?? this.isExpanded,
      position: position ?? this.position,
    );
  }
}
