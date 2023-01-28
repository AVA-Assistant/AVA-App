import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef StringCallback = void Function(String val, int index);

class Device extends StatelessWidget {
  final Map device;
  final StringCallback callback;
  final int index;

  const Device({
    super.key,
    required this.device,
    required this.callback,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (device["state"] == "off" && device["state"] != null) {
          callback("auto", index);
        } else {
          callback("off", index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: device["state"] == "off" || device["state"] == null ? const Color(0x99141414) : const Color(0xB1FFFFFF),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  device["name"],
                  style: GoogleFonts.heebo(
                    color: device["state"] == "off" || device["state"] == null ? const Color(0xFFFFFFFF) : const Color(0xff333333),
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  device["state"] == null ? "Loading..." : device["state"].toString(),
                  style: GoogleFonts.heebo(
                    color: device["state"] == "off" || device["state"] == null ? const Color(0xB1FFFFFF) : const Color(0xff333333),
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
