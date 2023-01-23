import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SceneTile extends StatefulWidget {
  final Map scene;

  const SceneTile({super.key, required this.scene});

  @override
  State<SceneTile> createState() => _SceneTileState();
}

class _SceneTileState extends State<SceneTile> {
  String state = "off";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          state = "on";
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            state = "off";
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: state == "off" ? const Color(0x99141414) : const Color(0xB1FFFFFF),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
          child: IntrinsicWidth(
            child: Row(children: [
              Icon(
                widget.scene["icon"],
                size: 30,
                color: state == "off" ? const Color(0xFFFFFFFF) : const Color(0xff333333),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                widget.scene["name"],
                style: GoogleFonts.heebo(
                  color: state == "off" ? const Color(0xFFFFFFFF) : const Color(0xff333333),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
