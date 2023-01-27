import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceSettings extends StatelessWidget {
  final Map device;

  const DeviceSettings({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xB1FFFFFF),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(children: [
          Center(
            child: Container(
              height: 38,
              width: 38,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Color(0xCC141414),
              ),
              child: Icon(
                device["icon"],
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            device["name"],
            style: GoogleFonts.heebo(
              color: const Color(0xff333333),
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          )
        ]),
      ),
    );
  }
}
