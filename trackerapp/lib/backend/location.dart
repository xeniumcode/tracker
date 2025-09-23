import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:tracker/backend/token.dart';

var client = http.Client();
Location location = Location();
final url = "http://10.0.2.2:8000/api/location";

Future<void> uploadLocation() async {
  location.onLocationChanged.listen((LocationData currentLocation) async {
    final locData = {
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
      'timestamp': currentLocation.time?.toInt(),
    };
    var token = await authToken();
    if (token != null) {
      await sendLocation(locData, token);
    }
  });
}

Future<void> sendLocation(Map<String, dynamic> locData, String token) async {
  var result = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(locData),
  );
  if (result.statusCode == 401) {
    final newToken = await authToken();
    if (newToken != null) {
      result = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $newToken',
        },
        body: jsonEncode(locData),
      );
    }
  }
  if (result.statusCode != 200) {
    if (kDebugMode) {
      print("Upload failed: ${result.statusCode} ${result.body}");
    }
  }
}

Future<void> checkLocationPrem() async {
  bool serviceEnabled;

  PermissionStatus permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  location.enableBackgroundMode(enable: true);
}
