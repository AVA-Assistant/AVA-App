import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '''Good morning,
Bartosz''',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 34,
            color: const Color(0xff1e1e1e),
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
                    color: const Color(0xff333333),
                  ),
                  children: const [
                    TextSpan(text: 'Temp: '),
                    TextSpan(text: '32°C', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const VerticalDivider(
                thickness: 1,
                width: 17,
                color: Color(0xff333333),
              ),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.heebo(
                    fontSize: 14.0,
                    color: const Color(0xff333333),
                  ),
                  children: const [
                    TextSpan(text: 'Humidity: '),
                    TextSpan(text: '64%', style: TextStyle(fontWeight: FontWeight.bold)),
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
