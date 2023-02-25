import 'package:ava_app/screens/device_controls/brightness_control.dart';
import 'package:ava_app/screens/device_controls/onOff_control.dart';
import 'package:ava_app/screens/device_controls/unknown_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef CallbackType = void Function(dynamic val, String status, bool emit);

class Device extends StatelessWidget {
  final Map device;
  final CallbackType deviceCallback;

  const Device({
    super.key,
    required this.device,
    required this.deviceCallback,
  });

  _setTypeOfTile() {
    if (device["type"] == "brht") {
      return BrigtnessDevice(
        device: device,
        deviceCallback: deviceCallback,
      );
    } else if (device["type"] == "onf") {
      return OnOffDevice(
        device: device,
        deviceCallback: deviceCallback,
      );
    } else {
      return UnknownDevice(device: device);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (device["status"] == "Off" && device["status"] != null) {
          device['settings']['status'] = true;
          deviceCallback(device['settings'], "On", true);
        } else if (device["status"] != null) {
          device['settings']['status'] = false;
          deviceCallback(device['settings'], "Off", true);
        }
      },
      onLongPress: () => device["status"] != null
          ? showBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              builder: (context) => _setTypeOfTile(),
            )
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: device["status"] == "Off" || device["status"] == null ? const Color(0x99141414) : const Color(0xB1FFFFFF),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(children: [
            Center(
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), color: Color(0xCC141414)),
                child: Center(
                  child: Icon(
                    IconData(device["icon"], fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage),
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  device["name"],
                  style: GoogleFonts.heebo(
                    color: device["status"] == "Off" || device["status"] == null ? const Color(0xFFFFFFFF) : const Color(0xff333333),
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  device["status"] ?? "Loading...",
                  style: GoogleFonts.heebo(
                    color: device["status"] == "Off" || device["status"] == null ? const Color(0xB1FFFFFF) : const Color(0xff333333),
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
