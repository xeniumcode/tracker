import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getOrCreateUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('userId');

  if (id == null) {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      id = androidInfo.id;
      await prefs.setString('userId', id);
    } catch (e) {
      id = Uuid().v4();
      await prefs.setString('userId', id);
    }
  }
  return id;
}
