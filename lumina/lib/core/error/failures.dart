// Fichier de re-export pour compatibilite ascendante.
//
// failures.dart a ete deplace de core/error/ vers core/errors/ (convention
// Dart au pluriel, regroupe avec error_handler.dart).
// Ce fichier preserve les imports existants vers l'ancien chemin.
//
// TODO: migrer progressivement les imports vers
// 'package:lumina/core/errors/failures.dart' puis supprimer ce fichier.
export 'package:lumina/core/errors/failures.dart';
