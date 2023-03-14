import 'dart:ui';
import 'package:ava_app/addons/initSocket.dart';
import 'package:ava_app/main_sections/devices_section.dart';
import 'package:ava_app/main_sections/header_section.dart';
import 'package:ava_app/main_sections/scenes_section.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'addons/warning_popup.dart';

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

  String? warningPopupText = 'Connecting to the server';
  bool? warningPopupError = false;
  bool? visible = true;

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

  @override
  void initState() {
    socket = initSocket();

    socket.onConnect((data) {
      setState(() {
        warningPopupError = null;
        warningPopupText = null;
      });
    });

    socket.onDisconnect((data) async {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          warningPopupError = true;
          warningPopupText = 'Disconnected from the server, reconnecting';
        });
      } else if (connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          warningPopupError = true;
          warningPopupText = 'Connect to wifi"';
        });
      } else if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          warningPopupError = true;
          warningPopupText = 'Turn on wifi';
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String time = getCurrentTime();
    scenes.sort((a, b) => a["name"].length.compareTo(b["name"].length));
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        visible = false;
      });
    });
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
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Column(children: [
                Stack(children: [
                  Header(
                    time: time,
                  ),
                  WarningPopup(error: warningPopupError, text: warningPopupText),
                ]),
                const SizedBox(height: 40),
                Scenes(time: time, scenes: scenes),
                const SizedBox(height: 40),
                Devices(time: time),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
