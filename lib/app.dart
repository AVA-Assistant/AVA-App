import 'dart:ui';
import 'package:ava_app/addons/init_socket.dart';
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

  List errors = [
    [false, 'Connecting to the server', 0]
  ];

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

    socket.onConnect((data) async {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          errors.removeWhere((element) => element[2] == 1);
        });
      }

      setState(() {
        errors.removeWhere((element) => element[2] == 0);
      });
    });

    socket.onDisconnect((data) async {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          errors.add([true, 'Disconnected from the server, reconnecting', 0]);
        });
      }

      if (connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          errors.add([true, 'Connect to wifi', 1]);
        });
      } else if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          errors.add([true, 'Turn on wifi', 1]);
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
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: errors.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            WarningPopup(error: errors[index][0], text: errors[index][1]),
                          ],
                        );
                      },
                    ),
                  )
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
