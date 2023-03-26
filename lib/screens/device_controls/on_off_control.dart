import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../addons/init_socket.dart';

typedef CallbackType = void Function(dynamic val, String status, bool emit);

class OnOffDevice extends StatefulWidget {
  final Map device;
  final CallbackType deviceCallback;

  const OnOffDevice({
    super.key,
    required this.device,
    required this.deviceCallback,
  });

  @override
  State<OnOffDevice> createState() => _OnOffDeviceState();
}

class _OnOffDeviceState extends State<OnOffDevice> {
  bool lightState = false;
  bool autoLight = false;

  void setDeviceState(bool state) {
    setState(() {
      lightState = state;
      autoLight = false;
    });
    widget.deviceCallback({'state': state, "auto": autoLight}, state ? "On" : "Off", true);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.device["settings"] != {}) {
        lightState = widget.device["settings"]['state'] ?? false;
        autoLight = widget.device["settings"]['auto'] ?? false;
      }
    });

    socket.on("stateChanged", (data) {
      if (data["mqtt_Id"] == widget.device["mqtt_Id"] && mounted) {
        setState(() {
          lightState = data['settings']['state'];
          autoLight = widget.device["settings"]['auto'];
        });
      }
    });

    socket.onDisconnect((data) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xff1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          )),
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.device["name"],
                        style: GoogleFonts.heebo(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 45,
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() => autoLight = !autoLight);
                            widget.deviceCallback({'state': lightState, "auto": autoLight}, lightState ? "On" : "Off", true);
                          },
                          backgroundColor: autoLight ? Colors.purpleAccent[400] : Colors.grey[800],
                          child: Center(child: Icon(Icons.auto_awesome, size: 30, color: autoLight ? Colors.white : Colors.greenAccent)),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Turn on and off",
                  style: GoogleFonts.heebo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            RotatedBox(
              quarterTurns: 3,
              child: CupertinoSlidingSegmentedControl(
                padding: const EdgeInsets.all(10),
                thumbColor: Colors.white,
                children: {
                  "on": Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        "On",
                        style: GoogleFonts.heebo(fontSize: 28, fontWeight: FontWeight.w500, color: !lightState ? Colors.white : const Color(0xff1e1e1e)),
                      ),
                    ),
                  ),
                  "off": Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        "Off",
                        style: GoogleFonts.heebo(fontSize: 28, fontWeight: FontWeight.w500, color: lightState ? Colors.white : const Color(0xff1e1e1e)),
                      ),
                    ),
                  ),
                },
                groupValue: !lightState ? "off" : "on",
                onValueChanged: (value) {
                  setDeviceState(value == "on" ? true : false);
                },
              ),
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
