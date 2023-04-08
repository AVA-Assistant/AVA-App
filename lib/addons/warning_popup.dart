import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WarningPopup extends StatefulWidget {
  const WarningPopup({super.key, required this.text, this.error});
  final String text;
  final bool? error;

  @override
  State<WarningPopup> createState() => _WarningPopupState();
}

class _WarningPopupState extends State<WarningPopup> {
  bool visible = false;
  String warningText = '';
  late List text;
  late Timer _timer;

  @override
  void initState() {
    int milisecs;

    if (widget.text.length * 50 > 5000) {
      milisecs = widget.text.length * 50 + 3000;
    } else {
      milisecs = 5000;
    }

    _timer = Timer(Duration(milliseconds: milisecs), () {
      setState(() => visible = false);
    });
    Timer(const Duration(milliseconds: 700), () {
      text = widget.text.characters.toList();
      addWord();
    });

    super.initState();
  }

  void addWord() {
    setState(() {
      warningText += text[0];
      text.removeAt(0);
    });
    if (text.isNotEmpty) {
      Timer(const Duration(milliseconds: 50), () {
        addWord();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 500),
        tween: Tween(begin: MediaQuery.of(context).size.width / 2, end: 0),
        builder: (context, value, child) => Transform.translate(
          offset: Offset(value.toDouble(), 0),
          child: child,
        ),
        curve: Curves.bounceIn,
        onEnd: () => setState(() => visible = true),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (visible)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xffffffff),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Text(
                      warningText,
                      style: GoogleFonts.ubuntu(fontSize: 14, color: const Color(0xff1e1e1e)),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (warningText != '') {
                  _timer.cancel();
                  if (!visible) {
                    _timer = Timer(const Duration(seconds: 3), () {
                      setState(() => visible = false);
                    });
                  }
                  setState(() => visible = !visible);
                }
              },
              child: Icon(
                Icons.warning_amber_rounded,
                color: !widget.error! ? Colors.amber[700] : Colors.red[500],
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
