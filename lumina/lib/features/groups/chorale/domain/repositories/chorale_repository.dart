import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/sheet_music.dart';
import '../entities/rehearsal.dart';

abstract class ChoraleRepository {
  /// Récupère toutes les partitions pour un groupe donné.
  Future<Either<Failure, List<SheetMusic>>> getSheetMusic(String groupId);

  /// Ajoute une nouvelle partition.
  Future<Either<Failure, SheetMusic>> addSheetMusic(SheetMusic sheetMusic);

  /// Supprime une partition par son ID.
  Future<Either<Failure, Unit>> deleteSheetMusic(String id, String churchId);

  /// Récupère toutes les répétitions pour un groupe donné.
  Future<Either<Failure, List<Rehearsal>>> getRehearsals(String groupId);

  /// Ajoute une nouvelle répétition.
  Future<Either<Failure, Rehearsal>> addRehearsal(Rehearsal rehearsal);

  /// Supprime une répétition par son ID.
  Future<Either<Failure, Unit>> deleteRehearsal(String id, String churchId);
}