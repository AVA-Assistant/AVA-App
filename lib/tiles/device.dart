import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Device extends StatefulWidget {
  final Map device;

  const Device({super.key, required this.device});

  @override
  State<Device> createState() {
    return _DeviceState(state: device['state']);
  }
}

class _DeviceState extends State<Device> {
  String state;

  _DeviceState({required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (state == "off") {
          setState(() {
            state = "auto";
          });
        } else {
          setState(() {
            state = "off";
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: state == "off" ? const Color(0x99141414) : const Color(0xB1FFFFFF),
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
                  widget.device["icon"],
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.device["name"],
                  style: GoogleFonts.heebo(
                    color: state == "off" ? const Color(0xFFFFFFFF) : const Color(0xff333333),
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  state,
                  style: GoogleFonts.heebo(
                    color: state == "off" ? const Color(0xB1FFFFFF) : const Color(0xff333333),
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
