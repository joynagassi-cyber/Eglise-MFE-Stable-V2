import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:lumina/main.dart' as app;

// IMPORTANT: Ce test utilise Patrol. 
// Pour le lancer sur un émulateur, tapez : patrol test integration_test/auth_dashboard_test.dart

void main() {
  patrolTest(
    'Scénario E2E : Connexion et Navigation Dashboard',
    config: const PatrolTesterConfig(),
    ($) async {
      // 1. Démarrer l'application (comme un vrai utilisateur)
      app.main();
      
      // On attend une longue période pour l'initialisation de Firebase/Supabase (Boot)
      await Future.delayed(const Duration(seconds: 3));
      await $.pumpAndSettle();

      // Vérifier visuellement si on est sur la page de connexion
      // Normalement on a un champ pour l'Email ou le téléphone
      // Le texte exact dépend de l'UI. Cherchons le TextField de l'email
      // Ex: await $(TextField).first.enterText('testeur@lumina.com');
      
      // -- NOTE SUR LES DONNÉES DE TEST --
      // Si l'utilisateur est DÉJÀ connecté (parce que le token Supabase 
      // est stocké localement dans l'émulateur), nous serons redirigés 
      // directement sur le Dashboard.
      
      // Vérifions d'abord où nous sommes
      final isLoginPage = $(TextField).exists;
      
      if (isLoginPage) {
        // Remplir les identifiants
        await $(TextField).at(0).enterText('joynagassi.mfe@gmail.com'); // Mettre un email de Admin test
        await $(TextField).at(1).enterText('password123'); // Remplacer par un password de test
        
        // Cliquer sur le bouton Connexion
        // Vous devez adapter ce texte au vrai texte du bouton
        await $('Se connecter').tap();
        await $.pumpAndSettle();
      }

      // Attendre que le Dashboard charge et vérifier la présence d'un composant
      // Par exemple on vérifie que le texte "Dashboard" (ou le perspective switcher 'GLOBAL') s'affiche
      expect($('GLOBAL'), findsOneWidget);

      // Clic sur l'onglet 'GROUPES' (Perspective Switcher) s'il existe
      if ($( 'GROUPES' ).exists) {
        await $('GROUPES').tap();
        await $.pumpAndSettle();
        // On devrait y voir les groupes
      }

      // Retour sur GLOBAL
      await $('GLOBAL').tap();
      await $.pumpAndSettle();

      // Scénario complété avec succès !
    },
  );
}
