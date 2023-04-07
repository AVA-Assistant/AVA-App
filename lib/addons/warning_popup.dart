import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WarningPopup extends StatefulWidget {
  const WarningPopup({super.key, this.text, this.error});
  final String? text;
  final bool? error;

  @override
  State<WarningPopup> createState() => _WarningPopupState();
}

class _WarningPopupState extends State<WarningPopup> {
  bool visible = true;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() => visible = false);
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (visible)
          DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xffffffff),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                widget.text!,
                style: GoogleFonts.ubuntu(fontSize: 14, color: const Color(0xff1e1e1e)),
              ),
            ),
          ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _timer.cancel();
            if (!visible) {
              _timer = Timer(const Duration(seconds: 3), () {
                setState(() => visible = false);
              });
            }
            setState(() => visible = !visible);
          },
          child: Icon(
            Icons.warning_amber_rounded,
            color: !widget.error! ? Colors.amber[700] : Colors.red[500],
            size: 40,
          ),
        ),
      ],
    );
  }
}
