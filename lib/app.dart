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

    if (now.hour >= 5 && now.hour < 10) {
      return "morning";
    } else if (now.hour >= 10 && now.hour < 16) {
      return "midday";
    } else if (now.hour >= 16 && now.hour < 19) {
      return "afternoon";
    } else if (now.hour >= 19 && now.hour < 24) {
      return "evening";
    } else {
      return "midday";
    }
  }

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
      setState(() {
        errors.removeWhere((element) => element[2] == 1);

        errors.removeWhere((element) => element[2] == 0);
      });
    });

    socket.onDisconnect((data) async {
      var connectivityResult = await (Connectivity().checkConnectivity());

      setState(() {
        errors.add([true, 'Disconnected from the server, reconnecting', 0]);
      });

      if (connectivityResult != ConnectivityResult.wifi) {
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
