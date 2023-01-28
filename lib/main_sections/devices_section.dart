import 'package:ava_app/screens/devices_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tiles/device_tile.dart';

class Devices extends StatefulWidget {
  final String time;

  const Devices({
    super.key,
    required this.time,
  });

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  List devices = [
    {
      'id': "dev_0",
      'name': "Main lights",
      'mqtt_id': "lights_1",
      'icon': Icons.lightbulb,
      'type': 'on_off',
      'state': null,
    },
    {
      'id': "dev_1",
      'name': "Main leds",
      'mqtt_id': "lights_1",
      'icon': Icons.light_mode_rounded,
      'type': 'on_off',
      'state': null,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () async {
                List newDevices = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DevicesScreen(
                      devices: devices,
                    ),
                  ),
                );
                setState(() {
                  devices = newDevices;
                });
              },
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    Text(
                      "Devices",
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: widget.time == "morning" ? const Color(0xff1e1e1e) : const Color(0xffffffff),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24,
                      color: widget.time == "morning" ? const Color(0xff1e1e1e) : const Color(0xffffffff),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // const Device(),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: devices.length,
            itemBuilder: (_, index) {
              return Device(
                device: devices[index],
                index: index,
                callback: (val, index) => setState(() => devices[index]["state"] = val),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 9 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
            ),
          )
        ],
      ),
    );
  }
}
