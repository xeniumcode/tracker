import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tracker/backend/uuid.dart';

String? _token;
Future<String?>? _refreshing;
final tokenUrl = "http://10.0.2.2:8000/api/get-token";

Future<String?> authToken() async {
  if (_token == null || willExpireInOneMinute(_token!)) {
    _refreshing ??= getToken().whenComplete(() => _refreshing = null);
    _token = await _refreshing;
  }
  return _token;
}

bool willExpireInOneMinute(String token) => JwtDecoder.getExpirationDate(
  token,
).isBefore(DateTime.now().toUtc().add(const Duration(minutes: 1)));

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("authToken");

  if (token == null || JwtDecoder.isExpired(token)) {
    final userId = await getOrCreateUserId();
    token = await fetchToken(userId);
    if (token != null) {
      await prefs.setString("authToken", token);
    }
  }
  return token;
}

Future<String?> fetchToken(String deviceId) async {
  final response = await http.post(
    Uri.parse(tokenUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'deviceId': deviceId}),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];
    return token;
  }
  return null;
}
