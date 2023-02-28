import 'package:ava_app/initSocket.dart';
import 'package:ava_app/screens/devices_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';
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
  late Box appBox;
  List? devices = [];

  @override
  void initState() {
    super.initState();

    socket = initSocket();
    appBox = Hive.box('appBox');
    // appBox.put('devices', [
    //   {'id': '003', 'name': 'Ambient leds', 'mqtt_Id': 'cct_003', 'icon': 23190, 'type': 'cct'},
    //   {'id': '002', 'name': 'Main leds', 'mqtt_Id': 'rgb_002', 'icon': 63190, 'type': 'rgb'},
    //   {'id': '001', 'name': 'Main lights', 'mqtt_Id': 'brth_001', 'icon': 63198, 'type': 'brht'},
    // ]);
    var newDevices = appBox.get("devices");

    if (newDevices != null) {
      for (var tempDevice in newDevices) {
        tempDevice["status"] = null;
      }
      setState(() => devices = newDevices);
    }

    socket.onConnect((data) => socket.emit("setupDevices", [appBox.get("devices")]));

    socket.on("setupDevices", (data) => setState(() => devices = data));

    socket.once("stateChanged", (data) {
      var updatedDevice = devices!.where((dev) => dev["mqtt_Id"] == data["mqtt_Id"]).first;
      setState(() {
        updatedDevice['settings'] = data['settings'];
        updatedDevice['status'] = data['status'];
      });
    });

    socket.onDisconnect((data) {
      setState(() {
        for (var tempDevice in devices!) {
          tempDevice["status"] = null;
        }
      });
    });
  }

  void setStats(val, index, status, emit) {
    setState(() => devices![index]["settings"] = val);
    setState(() => devices![index]["status"] = status);
    var device = devices![index];
    socket.emit("changeState", {
      'id': device['id'],
      "type": device['type'],
      "mqtt_Id": device['mqtt_Id'],
      'settings': val,
      'status': status,
      "emit": emit,
    });
  }

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
                List? newDevices = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DevicesScreen(
                      devices: devices!,
                    ),
                  ),
                );

                setState(() {
                  if (newDevices != null) devices = newDevices;
                });

                appBox.put("devices", devices);
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
          if (devices!.isNotEmpty)
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: devices?.length,
              itemBuilder: (_, index) {
                return Device(
                  device: devices![index],
                  deviceCallback: (val, status, emit) => setStats(val, index, status, emit),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 9 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
              ),
            ),
        ],
      ),
    );
  }
}
