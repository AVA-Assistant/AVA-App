import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef DeviceCallback = void Function(dynamic val);

class OnOffDevice extends StatefulWidget {
  final Map device;
  final DeviceCallback statusCallback;
  final DeviceCallback stateCallback;

  const OnOffDevice({
    super.key,
    required this.device,
    required this.statusCallback,
    required this.stateCallback,
  });

  @override
  State<OnOffDevice> createState() => _OnOffDeviceState();
}

class _OnOffDeviceState extends State<OnOffDevice> {
  bool sliderState = false;

  void setDeviceState(bool state) {
    setState(() => sliderState = state);
    widget.statusCallback(state ? "On" : "Off");
    widget.stateCallback({'status': state});
  }

  @override
  void initState() {
    setState(() {
      sliderState = widget.device["state"]['status'];
    });
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        style: GoogleFonts.heebo(fontSize: 24, fontWeight: FontWeight.w500, color: !sliderState ? Colors.white : const Color(0xff1e1e1e)),
                      ),
                    ),
                  ),
                  "off": Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        "Off",
                        style: GoogleFonts.heebo(fontSize: 24, fontWeight: FontWeight.w500, color: sliderState ? Colors.white : const Color(0xff1e1e1e)),
                      ),
                    ),
                  ),
                },
                groupValue: !sliderState ? "off" : "on",
                onValueChanged: (value) {
                  setState(() => sliderState = value == "on" ? true : false);
                  setDeviceState(value == "on" ? true : false);
                },
              ),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
