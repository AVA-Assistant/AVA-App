import 'dart:math';
import 'package:ava_app/addons/initSocket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../addons/custom_slider_shape.dart';

typedef CallbackType = void Function(dynamic val, String status, bool emit);

class RgbDevice extends StatefulWidget {
  final Map device;
  final CallbackType deviceCallback;

  const RgbDevice({
    super.key,
    required this.device,
    required this.deviceCallback,
  });

  @override
  State<RgbDevice> createState() => _RgbDeviceState();
}

class _RgbDeviceState extends State<RgbDevice> {
  bool lightState = false;
  double sliderValue = 0;
  String lightMode = "color";
  Color lightColor = Colors.white;
  List<ColorToName> colorChoices = <ColorToName>[];

  String createStatus() {
    if (lightMode == 'disco') {
      return 'Disco, ${(sliderValue * 100).round()}%';
    } else if (lightMode == 'wave') {
      return "Wave, ${(sliderValue * 100).round()}%";
    } else {
      return '${predictColorName(lightColor.red, lightColor.green, lightColor.blue)}, ${(sliderValue * 100).round()}%';
    }
  }

  void sendData(bool emit) {
    widget.deviceCallback({'state': lightState, "mode": lightMode, 'brightness': sliderValue, "red": lightColor.red, "green": lightColor.green, "blue": lightColor.blue}, lightState ? createStatus() : "Off", emit);
  }

  String predictColorName(int red, int green, int blue) {
    double dist = double.infinity;
    String closestName = '';
    for (var choice in colorChoices) {
      if (red == choice.red && blue == choice.blue && green == choice.green) {
        return choice.name;
      } else {
        double colorDist = sqrt(pow((choice.red - red), 2) + pow((choice.green - green), 2) + pow((choice.blue - blue), 2));
        if (colorDist < dist) {
          dist = colorDist;
          closestName = choice.name;
        }
      }
    }
    return closestName;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      final preProcessedColorStrings = colorFile.split('\n');

      preProcessedColorStrings.forEach((colorStr) {
        var split = colorStr.split('\t');
        final name = split[split.length - 1];
        var colors = colorStr.replaceAll('\t', ' ').split(' ')
          ..removeWhere((str) {
            return int.tryParse(str) == null;
          });
        colorChoices.add(ColorToName(name, int.parse(colors[0]), int.parse(colors[1]), int.parse(colors[2])));
      });

      if (widget.device["settings"] != null) {
        sliderValue = widget.device['settings']['brightness'];
        lightState = widget.device["settings"]['state'];
        lightMode = widget.device["settings"]['mode'];
        lightColor = Color.fromARGB(255, widget.device["settings"]['red'], widget.device["settings"]['green'], widget.device["settings"]['blue']);
      }
    });

    socket.on("stateChanged", (data) {
      if (data["mqtt_Id"] == widget.device["mqtt_Id"] && mounted) {
        setState(() {
          sliderValue = widget.device['settings']['brightness'];
          lightState = widget.device["settings"]['state'];
          lightMode = widget.device["settings"]['mode'];
          lightColor = Color.fromARGB(255, widget.device["settings"]['red'], widget.device["settings"]['green'], widget.device["settings"]['blue']);
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
                  child: Text(
                    widget.device["name"],
                    style: GoogleFonts.heebo(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Set RGB lights",
                  style: GoogleFonts.heebo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            Opacity(
              opacity: lightState && lightMode == 'color' ? (sliderValue < 0.95 ? sliderValue + 0.05 : sliderValue) : 0.05,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.8,
                  child: ColorPicker(
                    paletteType: PaletteType.hueWheel,
                    onColorChanged: (color) {
                      if (lightMode == 'color' && lightState) {
                        setState(() => lightColor = color);
                      } else {
                        setState(() {
                          lightState = true;
                          lightMode = 'color';
                          lightColor = color;
                        });
                      }
                      sendData(true);
                    },
                    enableAlpha: false,
                    labelTypes: const [],
                    pickerColor: Color.fromARGB(255, (lightColor.red * 1).toInt(), (lightColor.green * 1).toInt(), (lightColor.blue * 1).toInt()),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 40,
                      thumbShape: SliderComponentShape.noOverlay,
                      overlayShape: SliderComponentShape.noOverlay,
                      valueIndicatorShape: SliderComponentShape.noOverlay,
                      trackShape: const CustomRoundedRectSliderTrackShape(Radius.circular(10)),
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: 0,
                      max: 1,
                      activeColor: lightState ? Colors.white : Colors.grey[800],
                      inactiveColor: Colors.grey[800],
                      onChanged: (value) {
                        if (lightState) {
                          setState(() => sliderValue = value);
                          sendData(false);
                        }
                      },
                      onChangeEnd: (value) {
                        if (lightState) {
                          setState(() => sliderValue = value);
                          sendData(true);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoSlidingSegmentedControl(
                    padding: const EdgeInsets.all(7),
                    thumbColor: Colors.white,
                    children: {
                      "color": SizedBox(
                        width: 200,
                        child: Text(
                          "Color",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.heebo(fontSize: 20, fontWeight: FontWeight.w500, color: lightMode == 'color' ? const Color(0xff1e1e1e) : Colors.white),
                        ),
                      ),
                      "wave": SizedBox(
                        width: 200,
                        child: Text(
                          "Wave",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.heebo(fontSize: 20, fontWeight: FontWeight.w500, color: lightMode == 'wave' ? const Color(0xff1e1e1e) : Colors.white),
                        ),
                      ),
                      "disco": SizedBox(
                        width: 200,
                        child: Text(
                          "Disco",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.heebo(fontSize: 20, fontWeight: FontWeight.w500, color: lightMode == 'disco' ? const Color(0xff1e1e1e) : Colors.white),
                        ),
                      ),
                    },
                    groupValue: lightMode,
                    onValueChanged: (value) {
                      setState(() {
                        lightMode = value!;
                        lightState = true;
                      });
                      sendData(true);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
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

class ColorToName {
  String name;
  int red;
  int green;
  int blue;
  ColorToName(this.name, this.red, this.green, this.blue);

  @override
  String toString() {
    return "($red,$green,$blue) = $name";
  }
}

const colorFile = """
255 218 185		Peach
255 250 205		Lemon
245 255 250		Mint
240 255 255		Azure
255 228 225		Rose
255 255 255		White
250 128 114		Salmon
220  20  60		Crimson
  0   0   0		Black
 47  79  79		Dark grey
105 105 105		Dim grey
211 211 211		Light gray
  0   0 128		Navy blue
  0   0 255		Blue
 64 224 208		Turquoise
  0 255 255		Cyan
  0 255   0		Green
 50 205  50		Lime
255 255   0		Yellow
255 215   0 	Gold
165  42  42		Brown
255 165   0		Orange
255   0   0		Red
 75   0 130   Indigo
255 192 203		Pink
176  48  96		Maroon
255   0 255		Magenta
238 130 238		Violet
221 160 221		Plum
160  32 240		Purple
169 169 169		Dark grey
  0   0 139   Dark blue
  0 139 139   Dark cyan
139   0   0		Dark red
144 238 144		Light green""";
