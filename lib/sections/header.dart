import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  final String time;
  final double temp;
  final double humidity;

  const Header({
    super.key,
    required this.time,
    required this.temp,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '''Good $time,
Bartosz''',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 34,
            color: time == "morning" ? const Color(0xff1e1e1e) : const Color(0xffffffff),
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.heebo(
                    fontSize: 14.0,
                    color: time == "morning" ? const Color(0xff333333) : const Color(0xffeeeeee),
                  ),
                  children: [
                    const TextSpan(text: 'Temp: '),
                    TextSpan(text: '$temp°C', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 20,
                color: time == "morning" ? const Color(0xff333333) : const Color(0xffeeeeee),
                // color: Color(0xff333333)
              ),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.heebo(
                    fontSize: 14.0,
                    color: time == "morning" ? const Color(0xff333333) : const Color(0xffeeeeee),
                  ),
                  children: [
                    const TextSpan(text: 'Humidity: '),
                    TextSpan(text: '$humidity%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
