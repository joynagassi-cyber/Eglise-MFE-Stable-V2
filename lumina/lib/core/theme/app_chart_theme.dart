import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Thème unifié pour tous les graphiques fl_chart
///
/// Fournit une palette de couleurs cohérente, des styles de texte standardisés,
/// et des configurations réutilisables pour garantir la cohérence visuelle
/// de tous les graphiques dans l'application.
class AppChartTheme {
  AppChartTheme._();

  // ============================================================================
  // PALETTE DE COULEURS UNIFIÉE
  // ============================================================================

  /// Palette de 8 couleurs pour les données des graphiques
  /// Ordre: Indigo, Purple, Pink, Amber, Emerald, Blue, Red, Teal
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFFEF4444), // Red
    Color(0xFF14B8A6), // Teal
  ];

  /// Couleur pour les revenus (vert)
  static Color incomeColor(BuildContext context) => context.colors.successIcon;

  /// Couleur pour les dépenses (rouge)
  static Color expenseColor(BuildContext context) => context.colors.errorText;

  /// Couleur pour les données positives
  static Color positiveColor(BuildContext context) => context.colors.successIcon;

  /// Couleur pour les données négatives
  static Color negativeColor(BuildContext context) => context.colors.errorText;

  /// Couleur pour les données neutres
  static Color neutralColor(BuildContext context) => context.colors.textTertiary;

  // ============================================================================
  // GRADIENTS
  // ============================================================================

  /// Crée un gradient pour zone sous courbe (line chart)
  static LinearGradient chartGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withOpacity(0.3),
        color.withOpacity(0.1),
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// Gradient pour barres (vertical)
  static LinearGradient barGradient(Color color) {
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        color,
        color.withOpacity(0.7),
      ],
    );
  }

  /// Gradient radial pour pie chart
  static RadialGradient pieGradient(Color color) {
    return RadialGradient(
      colors: [
        color,
        color.withOpacity(0.8),
      ],
    );
  }

  // ============================================================================
  // STYLES DE GRILLE
  // ============================================================================

  /// Couleur des lignes de grille
  static Color gridLineColor(BuildContext context) => context.colors.borderSubtle;

  /// Épaisseur des lignes de grille
  static const double gridLineWidth = 0.5;

  /// Dash array pour lignes pointillées
  static const List<int> gridDashArray = [5, 5];

  // ============================================================================
  // STYLES DE TEXTE
  // ============================================================================

  /// Style pour titres d'axes
  static TextStyle axisTitleStyle(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: context.colors.textSecondary,
      );

  /// Style pour labels d'axes
  static TextStyle axisLabelStyle(BuildContext context) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: context.colors.textTertiary,
      );

  /// Style pour texte dans tooltips
  static TextStyle tooltipTextStyle(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: context.colors.textPrimary,
      );

  /// Style pour légendes
  static TextStyle legendTextStyle(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: context.colors.textSecondary,
      );

  // ============================================================================
  // CONFIGURATIONS FL_CHART RÉUTILISABLES
  // ============================================================================

  /// Configuration des titres par défaut
  static FlTitlesData defaultTitlesData(BuildContext context) => FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(0),
              style: axisLabelStyle(context),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(0),
              style: axisLabelStyle(context),
            ),
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  /// Configuration des bordures par défaut
  static FlBorderData defaultBorderData(BuildContext context) => FlBorderData(
        show: true,
        border: Border.all(
          color: gridLineColor(context),
          width: 1,
        ),
      );

  /// Configuration de la grille par défaut
  static FlGridData defaultGridData(BuildContext context) => FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: null, // Auto
        verticalInterval: null, // Auto
        getDrawingHorizontalLine: (value) => FlLine(
          color: gridLineColor(context),
          strokeWidth: gridLineWidth,
          dashArray: gridDashArray,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: gridLineColor(context),
          strokeWidth: gridLineWidth,
          dashArray: gridDashArray,
        ),
      );

  // ============================================================================
  // LINE CHART - CONFIGURATION STANDARD
  // ============================================================================

  /// Configuration touch pour line chart
  static LineTouchData defaultLineTouchData({
    required BuildContext context,
    String Function(double)? valueFormatter,
  }) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => context.colors.bgCard.withOpacity(0.9),
        tooltipPadding: const EdgeInsets.all(12),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final value =
                valueFormatter?.call(spot.y) ?? spot.y.toStringAsFixed(0);
            return LineTooltipItem(
              value,
              tooltipTextStyle(context),
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: barData.color ?? chartColors[0],
              strokeWidth: 2,
              dashArray: [5, 5],
            ),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: context.colors.bgPage,
                  strokeWidth: 3,
                  strokeColor: barData.color ?? chartColors[0],
                );
              },
            ),
          );
        }).toList();
      },
    );
  }

  /// Crée un LineChartBarData standard
  static LineChartBarData createLineChartBar({
    required BuildContext context,
    required List<FlSpot> spots,
    required Color color,
    bool isCurved = true,
    double curveSmoothness = 0.35,
    double barWidth = 3,
    bool showDots = true,
    bool showBelowBar = true,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: isCurved,
      curveSmoothness: curveSmoothness,
      color: color,
      barWidth: barWidth,
      dotData: FlDotData(
        show: showDots,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: context.colors.bgPage,
            strokeWidth: 2,
            strokeColor: color,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: showBelowBar,
        gradient: chartGradient(color),
      ),
    );
  }

  // ============================================================================
  // BAR CHART - CONFIGURATION STANDARD
  // ============================================================================

  /// Configuration touch pour bar chart
  static BarTouchData defaultBarTouchData({
    required BuildContext context,
    String Function(double)? valueFormatter,
  }) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => context.colors.bgCard.withOpacity(0.9),
        tooltipPadding: const EdgeInsets.all(12),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final value =
              valueFormatter?.call(rod.toY) ?? rod.toY.toStringAsFixed(0);
          return BarTooltipItem(
            value,
            tooltipTextStyle(context),
          );
        },
      ),
      handleBuiltInTouches: true,
    );
  }

  /// Crée un BarChartRodData standard
  static BarChartRodData createBarChartRod({
    required double value,
    required Color color,
    double width = 22,
    BorderRadius? borderRadius,
    bool showGradient = true,
  }) {
    return BarChartRodData(
      toY: value,
      color: color,
      width: width,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      gradient: showGradient ? barGradient(color) : null,
    );
  }

  // ============================================================================
  // PIE CHART - CONFIGURATION STANDARD
  // ============================================================================

  /// Configuration touch pour pie chart
  static PieTouchData defaultPieTouchData() {
    return PieTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, pieTouchResponse) {
        // Géré par le widget parent
      },
    );
  }

  /// Crée un PieChartSectionData standard
  static PieChartSectionData createPieChartSection({
    required BuildContext context,
    required double value,
    required Color color,
    required String title,
    double radius = 60,
    bool isSelected = false,
    bool showTitle = true,
  }) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: showTitle ? title : '',
      radius: isSelected ? radius + 10 : radius,
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: context.colors.textPrimary,
      ),
      gradient: pieGradient(color),
    );
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Obtient une couleur de la palette par index (avec wrap)
  static Color getChartColor(int index) {
    return chartColors[index % chartColors.length];
  }

  /// Obtient une couleur selon valeur positive/négative
  static Color getColorByValue(BuildContext context, double value) {
    if (value > 0) return positiveColor(context);
    if (value < 0) return negativeColor(context);
    return neutralColor(context);
  }

  /// Formatte une valeur monétaire
  static String formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Formatte un pourcentage
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}
