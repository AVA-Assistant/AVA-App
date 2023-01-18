import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tiles/device.dart';

class Devices extends StatelessWidget {
  final String time;
  final List devices;

  const Devices({
    super.key,
    required this.time,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {},
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Text(
                    "Devices",
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: time == "morning" ? const Color(0xff1e1e1e) : const Color(0xffffffff),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 24,
                    color: time == "morning" ? const Color(0xff1e1e1e) : const Color(0xffffffff),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        // const Device(),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: devices.length,
          itemBuilder: (_, index) {
            return Device(device: devices[index]);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 9 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
        )
      ],
    );
  }
}
