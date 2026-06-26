import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'device_service.g.dart';

@Riverpod(keepAlive: true)
DeviceService deviceService(DeviceServiceRef ref) => DeviceService();

/// Service d'identification de l'appareil.
///
/// Génère et persiste un UUID unique par installation.
/// Utilisable en mode statique dans les isolates background.
class DeviceService {
  static const _key = 'lumina_device_id';

  /// Méthode d'instance — à utiliser via Riverpod (ref.read)
  Future<String> getDeviceId() => DeviceService.getDeviceIdStatic();

  /// Méthode statique — utilisable dans les isolates Workmanager
  static Future<String> getDeviceIdStatic() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_key);
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString(_key, id);
    }
    return id;
  }
}

