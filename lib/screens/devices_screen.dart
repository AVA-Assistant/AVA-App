import 'package:ava_app/tiles/device_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

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
      backgroundColor: const Color(0xFF222222),
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, widget.devices),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        middle: const Text("Devices", style: TextStyle(color: Colors.white, fontSize: 22)),
        trailing: IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: ReorderableGridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => DeviceSettings(
              device: widget.devices[index],
              key: ValueKey(index),
            ),
            itemCount: widget.devices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 9 / 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final item = widget.devices.removeAt(oldIndex);
                widget.devices.insert(newIndex, item);
              });
            },
          ),
        ),
      ),
    );
  }
}
