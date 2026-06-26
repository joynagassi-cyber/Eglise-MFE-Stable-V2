import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider pour gérer le basculement (switch) entre la vue professionnelle (Admin/Leader) 
/// et la vue personnelle (Membre). 
/// Si true, l'utilisateur voit son Dashboard Membre et sa propre navbar.
final memberViewModeProvider = StateProvider<bool>((ref) => false);