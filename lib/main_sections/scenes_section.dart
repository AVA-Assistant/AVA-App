import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tiles/scene_tile.dart';

class Scenes extends StatelessWidget {
  const Scenes({
    super.key,
    required this.time,
    required this.scenes,
  });

  final List scenes;
  final String time;

  List<Widget> createScenes() {
    scenes.sort((a, b) => a["name"].length.compareTo(b["name"].length));

    if (scenes.length > 3) {
      return [
        Row(
          children: [
            for (int i = 0; i < (scenes.length.isOdd ? (scenes.length + 1) / 2 : scenes.length / 2); i++)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SceneTile(scene: scenes[i]),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            for (int i = (scenes.length.isOdd ? (scenes.length + 1) / 2 : scenes.length / 2).toInt(); i < scenes.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SceneTile(scene: scenes[i]),
              ),
          ],
        )
      ];
    } else {
      return [
        Row(
          children: [
            for (int i = 0; i < scenes.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SceneTile(scene: scenes[i]),
              ),
          ],
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {},
          child: IntrinsicWidth(
            child: Row(
              children: [
                Text(
                  "Scenes",
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
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // children: createScenes(),
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 1.6),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: scenes.map((e) => SceneTile(scene: e)).toList(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
