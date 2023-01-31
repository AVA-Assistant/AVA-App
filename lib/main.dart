import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'package:flutter/services.dart';

late Box appBox;
Future<void> main() async {
  await Hive.initFlutter();
  var appBox = await Hive.openBox('appBox');

  // appBox.put("devices", [
  //   {
  //     'id': "dev_0",
  //     'name': "Main lights",
  //     'mqtt_Id': "lights_1",
  //     // 'icon': Icons.lightbulb,
  //     'type': 'on_off',
  //     'state': null,
  //   },
  //   {
  //     'id': "dev_1",
  //     'name': "Main leds",
  //     'mqtt_Id': "lights_1",
  //     // 'icon': Icons.light_mode_rounded,
  //     'type': 'on_off',
  //     'state': "auto",
  //   }
  // ]);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: App()),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
