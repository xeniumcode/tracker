import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tracker/backend/location.dart';


class SystemInfoScreen extends StatefulWidget {
  const SystemInfoScreen({super.key});

  @override
  State<SystemInfoScreen> createState() => _SystemInfoScreenState();
}

class _SystemInfoScreenState extends State<SystemInfoScreen> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _androidInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchAndroidInfo();
    uploadLocation();
  }

  Future<void> _fetchAndroidInfo() async {
    try {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      setState(() {
        _androidInfo = {
          'Device': androidInfo.model,
          'Manufacturer': androidInfo.manufacturer,
          'Brand': androidInfo.brand,
          'Product Name':androidInfo.product,
          'Android Version': androidInfo.version.release,
          'Total physical RAM':(androidInfo.physicalRamSize/1000).toString(),
          'SDK Version': androidInfo.version.sdkInt.toString(),
          'Board': androidInfo.board,
          'Hardware': androidInfo.hardware,
          'Device ID': androidInfo.id,
          'Bootloader': androidInfo.bootloader,
          'Host': androidInfo.host,
          'Fingerprint': androidInfo.fingerprint,
          'Supported ABIs': androidInfo.supportedAbis.join(', '),
          'Is Physical Device': androidInfo.isPhysicalDevice.toString(),
        };
      });
    } catch (e) {
      setState(() {
        _androidInfo = {'Error': 'Failed to get device info: $e'};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _androidInfo.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Android System Info'),
      ),
      body: _androidInfo.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final key = entries[index].key;
                final value = entries[index].value;
                return ListTile(title: Text(key), subtitle: Text(value));
              },
            ),
    );
  }
}
