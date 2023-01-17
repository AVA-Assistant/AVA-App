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
        const SizedBox(height: 5),
        // const Device(),
        GridView.builder(
          shrinkWrap: true,
          itemCount: 30,
          itemBuilder: (_, index) {
            return const Device();
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 33 / 14,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
        )
      ],
    );
  }
}
