import 'package:ava_app/tiles/device_settings.dart';
import 'package:flutter/material.dart';

class DevicesScreen extends StatefulWidget {
  final List devices;

  const DevicesScreen({super.key, required this.devices});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Devices"),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.add),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.devices.length,
          itemBuilder: (_, index) {
            return DeviceSettings(device: widget.devices[index]);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 9 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
        ),
      ),
    );
  }
}
