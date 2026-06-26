import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../data/services/events/event_report_service.dart';
import '../../../../core/utils/file_download_service.dart';
import '../../../../core/services/storage/report_storage_service.dart';

part 'event_report_provider.g.dart';

@riverpod
class EventReportGenerator extends _$EventReportGenerator {
  @override
  FutureOr<File?> build() => null;

  Future<File?> generateAndDownload({
    required String churchName,
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    bool saveToSupabase = false,
  }) async {
    state = const AsyncValue.loading();
    return await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      final events = await repository.getEvents(
        startDate: startDate,
        endDate: endDate,
      );

      final service = EventReportService();
      final file = await service.generateEventReport(
        events: events,
        churchName: churchName,
        startDate: startDate,
        endDate: endDate,
      );

      // Sauvegarder dans le dossier Téléchargements
      final savedFile = await FileDownloadService.saveToDownloads(
        file,
        file.path.split('/').last,
      );

      if (saveToSupabase) {
        await ReportStorageService().uploadReport(
          file: savedFile,
          churchId: churchId,
          type: 'event',
          title: 'Rapport Événements ${startDate.year}',
          startDate: startDate,
          endDate: endDate,
        );
      }

      // Ouvrir automatiquement le fichier
      await FileDownloadService.openFile(savedFile);

      return savedFile;
    }).then((result) {
      state = result;
      return result.value;
    });
  }
}
