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
  late Socket socket;

  @override
  void initState() {
    super.initState();

    socket = io("http://192.168.1.191:2500", <String, dynamic>{
      'force new connection': true,
      "transports": ['websocket']
    });

    appBox = Hive.box('appBox');
    var newDevices = appBox.get("devices");
    for (var tempDevice in newDevices) {
      tempDevice["status"] = null;
    }
    setState(() => devices = newDevices);

    socket.emit("setup", [appBox.get("devices")]);
    socket.on("setup", (data) => setState(() => devices = data));
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
          // const Device(),
          if (devices != null)
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: devices!.length,
              itemBuilder: (_, index) {
                return Device(
                  device: devices![index],
                  index: index,
                  callback: (val, index) => setState(() => devices![index]["status"] = val),
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
