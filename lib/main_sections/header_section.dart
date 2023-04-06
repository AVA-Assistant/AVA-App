import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../addons/init_socket.dart';

class Header extends StatefulWidget {
  final String time;

  const Header({
    super.key,
    required this.time,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double? temp;
  double? humidity;

  @override
  void initState() {
    socket = initSocket();

    socket.onConnect((data) => socket.emit("setupRoom", {'id': 1}));
    socket.on("setupRoom", (data) {
      setState(() {
        temp = data['temp'];
        humidity = data['humidity'];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '''Good ${widget.time},
Bartosz''',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 34,
            color: widget.time == "morning" ? const Color(0xff1e1e1e) : const Color(0xffffffff),
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            children: temp != null && humidity != null
                ? [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.heebo(
                          fontSize: 14.0,
                          color: widget.time == "morning" ? const Color(0xff333333) : const Color(0xffeeeeee),
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
                      color: widget.time == "morning" ? const Color(0xff333333) : const Color(0xffeeeeee),
                    ),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.heebo(
                          fontSize: 14.0,
                          color: widget.time == "morning" ? const Color(0xff333333) : const Color(0xffeeeeee),
                        ),
                        children: [
                          const TextSpan(text: 'Humidity: '),
                          TextSpan(text: '$humidity%', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ]
                : [],
          ),
        )
      ],
    );
  }
}
