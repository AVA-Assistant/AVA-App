import 'package:ava_app/addons/initSocket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../addons/custom_slider_shape.dart';

typedef CallbackType = void Function(dynamic val, String status, bool emit);

class BrigtnessDevice extends StatefulWidget {
  final Map device;
  final CallbackType deviceCallback;

  const BrigtnessDevice({
    super.key,
    required this.device,
    required this.deviceCallback,
  });

  @override
  State<BrigtnessDevice> createState() => _BrigtnessDeviceState();
}

class _BrigtnessDeviceState extends State<BrigtnessDevice> {
  double sliderValue = 0;
  bool sliderState = false;
  bool autoLight = false;

  void setSliderState(bool state) {
    setState(() {
      sliderState = state;
      autoLight = false;
    });

    widget.deviceCallback({'state': state, 'brightness': sliderValue, "auto": autoLight}, state ? "${(sliderValue * 100).toStringAsFixed(1)}%" : "Off", true);
  }

  void setSliderValue(double state, bool emit) {
    if (state == 0) {
      setState(() {
        sliderState = false;
        sliderValue = state;
        autoLight = false;
      });

      widget.deviceCallback({'state': sliderState, 'brightness': state, "auto": autoLight}, "Off", emit);
    } else {
      setState(() {
        sliderState = true;
        autoLight = false;
        sliderValue = state;
      });

      widget.deviceCallback({'state': sliderState, 'brightness': state, "auto": autoLight}, '${(state * 100).toStringAsFixed(1)}%', emit);
    }
  }

  @override
  void initState() {
    if (widget.device["settings"] != {}) {
      setState(() {
        sliderValue = widget.device["settings"]['brightness'] ?? 0;
        sliderState = widget.device["settings"]['state'] ?? false;
        autoLight = widget.device["settings"]['auto'] ?? false;
      });
    }

    socket.on("stateChanged", (data) {
      if (data["mqtt_Id"] == widget.device["mqtt_Id"] && mounted) {
        setState(() {
          sliderValue = data['settings']['brightness'];
          sliderState = data['settings']['state'];
          autoLight = widget.device["settings"]['auto'];
        });
      }
    });
    socket.onDisconnect((data) => Navigator.pop(context));

    super.initState();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            widget.deviceCallback({'state': sliderState, 'brightness': sliderValue, "auto": autoLight}, sliderState ? "${(sliderValue * 100).toStringAsFixed(1)}%" : "Off", true);
                          },
                          backgroundColor: autoLight ? Colors.purpleAccent[400] : Colors.grey[800],
                          child: Center(child: Icon(Icons.auto_awesome, size: 30, color: autoLight ? Colors.white : Colors.greenAccent)),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Set brightness",
                  style: GoogleFonts.heebo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 350,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 110,
                  thumbShape: SliderComponentShape.noOverlay,
                  overlayShape: SliderComponentShape.noOverlay,
                  valueIndicatorShape: SliderComponentShape.noOverlay,
                  trackShape: const CustomRoundedRectSliderTrackShape(Radius.circular(20)),
                ),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: sliderValue,
                    min: 0,
                    max: 1,
                    activeColor: sliderState ? Colors.white : Colors.grey[600],
                    inactiveColor: Colors.grey[800],
                    onChanged: (value) => setSliderValue(value, false),
                    onChangeEnd: (value) => setSliderValue(value, true),
                  ),
                ),
              ),
            ),
            CupertinoSlidingSegmentedControl(
              padding: const EdgeInsets.all(7),
              thumbColor: Colors.white,
              children: {
                "on": Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    "On",
                    style: GoogleFonts.heebo(fontSize: 20, fontWeight: FontWeight.w500, color: !sliderState ? Colors.white : const Color(0xff1e1e1e)),
                  ),
                ),
                "off": Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Text(
                    "Off",
                    style: GoogleFonts.heebo(fontSize: 20, fontWeight: FontWeight.w500, color: sliderState ? Colors.white : const Color(0xff1e1e1e)),
                  ),
                ),
              },
              groupValue: !sliderState ? "off" : "on",
              onValueChanged: (value) {
                setSliderState(value == "on" ? true : false);
              },
            )
          ],
        ),
      ),
    );
  }
}
