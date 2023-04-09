import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceSettings extends StatelessWidget {
  final Map device;
  final bool reorderEnabled;

  const DeviceSettings({super.key, required this.device, required this.reorderEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xB1FFFFFF),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(children: [
          Center(
            child: Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Color(0xCC141414),
              ),
              child: Center(
                child: Icon(
                  IconData(device["icon"], fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage),
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              device["name"],
              style: GoogleFonts.heebo(
                color: const Color(0xff333333),
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (reorderEnabled)
            Icon(
              Icons.drag_indicator,
              size: 35,
              color: Colors.grey[850],
            ),
        ]),
      ),
    );
  }
}
