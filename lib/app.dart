import 'dart:ui';
import 'package:ava_app/main_sections/devices_section.dart';
import 'package:ava_app/main_sections/header_section.dart';
import 'package:ava_app/main_sections/scenes_section.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String getCurrentTime() {
    final now = DateTime.now();

    if (now.hour >= 5 && now.hour < 11) {
      return "morning";
    } else if (now.hour >= 11 && now.hour < 17) {
      return "afternoon";
    } else if (now.hour >= 17 && now.hour < 23) {
      return "evening";
    } else {
      return "night";
    }
  }

  double temp = 32;
  double humidity = 70.2;
  List scenes = [
    {
      'id': "scene_0",
      'name': "Off",
      'icon': Icons.stop_circle_sharp,
      'actions': [],
    },
    {
      'id': "scene_0",
      'name': "Reading",
      'icon': Icons.menu_book_rounded,
      'actions': [],
    },
    {
      'id': "scene_0",
      'name': "Playing",
      'icon': Icons.gamepad_outlined,
      'actions': [],
    },
    {
      'id': "scene_0",
      'name': "Morning",
      'icon': Icons.sunny,
      'actions': [],
    },
    {
      'id': "scene_0",
      'name': "Relax",
      'icon': Icons.beach_access_sharp,
      'actions': [],
    },
    {
      'id': "scene_0",
      'name': "Work",
      'icon': Icons.work,
      'actions': [],
    },
  ];

  List devices = [
    {
      'id': "dev_0",
      'name': "Main lights",
      'mqtt_id': "lights_1",
      'icon': Icons.lightbulb,
      'type': 'on_off',
      'state': 'off',
    },
    {
      'id': "dev_1",
      'name': "Main leds",
      'mqtt_id': "lights_1",
      'icon': Icons.light_mode_rounded,
      'type': 'on_off',
      'state': 'auto',
    }
  ];

  @override
  Widget build(BuildContext context) {
    String time = getCurrentTime();
    scenes.sort((a, b) => a["name"].length.compareTo(b["name"].length));

    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/$time.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Column(children: [
                Header(
                  humidity: humidity,
                  temp: temp,
                  time: time,
                ),
                const SizedBox(height: 40),
                Scenes(time: time, scenes: scenes),
                const SizedBox(height: 40),
                if (devices.isNotEmpty) Devices(time: time, devices: devices)
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
