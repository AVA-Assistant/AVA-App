import 'dart:ui';
import 'package:ava_app/sections/devices.dart';
import 'package:ava_app/sections/header.dart';
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
  List scenes = [];
  List devices = [
    {
      'id': 0,
      'name': "Main lights",
      'mqtt_id': "lights_1",
      'icon': Icons.light,
      'type': 'on_off',
      'state': 'off',
    }
  ];

  @override
  Widget build(BuildContext context) {
    String time = getCurrentTime();

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
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: SafeArea(
              child: Column(children: [
                Header(
                  humidity: humidity,
                  temp: temp,
                  time: time,
                ),
                // const SizedBox(height: 40),
                // Scenes(time: time, scenes: scenes),
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
