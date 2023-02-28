import 'dart:math';
import 'package:ava_app/initSocket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../addons/custom_slider_shape.dart';
import '../../addons/custom_slider_shape_ctt.dart';

typedef CallbackType = void Function(dynamic val, String status, bool emit);

class CttDevice extends StatefulWidget {
  final Map device;
  final CallbackType deviceCallback;

  const CttDevice({
    super.key,
    required this.device,
    required this.deviceCallback,
  });

  @override
  State<CttDevice> createState() => _CttDeviceState();
}

class _CttDeviceState extends State<CttDevice> {
  bool lightState = false;
  double sliderValue = 0;
  int warmLight = 127;
  int coldLight = 128;
  bool autoLight = false;

  void sendData(bool emit) {
    String status = '';

    if (lightState) {
      int distance = 1000;
      var lights = [
        {"name": "Very cold", "warmLight": 0, "color": Colors.blue[300]},
        {"name": "Cold", "warmLight": 32, "color": Colors.blue[100]},
        {"name": "Daylight", "warmLight": 100, "color": Colors.blue[50]},
        {"name": "Warm", "warmLight": 140, "color": Colors.yellow[400]},
        {"name": "Cosy", "warmLight": 200, "color": Colors.orange[400]},
        {"name": "Ambient", "warmLight": 255, "color": Colors.red[400]},
      ];
      for (Map light in lights) {
        if (sqrt(pow((warmLight - light['warmLight']), 2)) < distance) {
          distance = sqrt(pow((warmLight - light['warmLight']), 2)).toInt();
          status = light['name'];
        }
      }
      status = '$status, ${(sliderValue * 100).round()}%';
    } else {
      status = "Off";
    }

    widget.deviceCallback({'state': lightState, "auto": autoLight, 'brightness': sliderValue, "cold": coldLight, "warm": warmLight}, status, emit);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.device["settings"] != null) {
        sliderValue = widget.device['settings']['brightness'];
        lightState = widget.device["settings"]['state'];
        autoLight = widget.device["settings"]['auto'];
        warmLight = widget.device["settings"]['warm'];
        coldLight = widget.device["settings"]['cold'];
      }
    });

    socket.on("stateChanged", (data) {
      if (data["mqtt_Id"] == widget.device["mqtt_Id"] && mounted) {
        setState(() {
          sliderValue = widget.device['settings']['brightness'];
          lightState = widget.device["settings"]['state'];
          autoLight = widget.device["settings"]['auto'];
          warmLight = widget.device["settings"]['warm'];
          coldLight = widget.device["settings"]['cold'];
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
        ),
      ),
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
                            sendData(true);
                          },
                          backgroundColor: autoLight ? Colors.purpleAccent[400] : Colors.grey[800],
                          child: Center(child: Icon(Icons.auto_awesome, size: 30, color: autoLight ? Colors.white : Colors.greenAccent)),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Set color temperature",
                  style: GoogleFonts.heebo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        activeColor: lightState && !autoLight ? Colors.white : Colors.grey[800],
                        inactiveColor: Colors.grey[800],
                        onChangeStart: ((value) {
                          setState(() => autoLight = false);
                        }),
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                            lightState = value == 0 ? false : true;
                          });

                          sendData(false);
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            sliderValue = value;
                            lightState = value == 0 ? false : true;
                          });
                          sendData(true);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 350,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 110,
                      thumbShape: SliderComponentShape.noOverlay,
                      overlayShape: SliderComponentShape.noOverlay,
                      valueIndicatorShape: SliderComponentShape.noOverlay,
                      trackShape: const CustomRoundedRectSliderTrackShapeCCT(Radius.circular(20)),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: coldLight.toDouble(),
                        min: 0,
                        max: 255,
                        activeColor: lightState && !autoLight ? Colors.white : Colors.grey[400],
                        onChangeStart: ((value) {
                          setState(() {
                            autoLight = false;
                            lightState = true;
                          });
                        }),
                        onChanged: (value) {
                          setState(() {
                            coldLight = value.toInt();
                            warmLight = (255 - value).toInt();
                          });
                          sendData(false);
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            coldLight = value.toInt();
                            warmLight = (255 - value).toInt();
                          });
                          sendData(true);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl(
                    padding: const EdgeInsets.all(7),
                    thumbColor: Colors.white,
                    children: {
                      "on": SizedBox(
                        width: 200,
                        child: Text(
                          "On",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.heebo(fontSize: 20, fontWeight: FontWeight.w500, color: !lightState ? Colors.white : const Color(0xff1e1e1e)),
                        ),
                      ),
                      "off": SizedBox(
                        width: 200,
                        child: Text(
                          "Off",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.heebo(fontSize: 20, fontWeight: FontWeight.w500, color: lightState ? Colors.white : const Color(0xff1e1e1e)),
                        ),
                      ),
                    },
                    groupValue: !lightState ? "off" : "on",
                    onValueChanged: (value) {
                      setState(() {
                        lightState = value == "on" ? true : false;
                      });
                      sendData(true);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
