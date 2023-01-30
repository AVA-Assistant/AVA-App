import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnknownDevice extends StatelessWidget {
  final Map device;
  const UnknownDevice({super.key, required this.device});

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
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              device["name"],
              style: GoogleFonts.heebo(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 200),
            Text(
              "Unknown device type!",
              style: GoogleFonts.heebo(fontSize: 35, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              "Scann QR code again.",
              style: GoogleFonts.heebo(fontSize: 26, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
