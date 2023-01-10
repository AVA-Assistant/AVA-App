import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVA brightness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: SliderVerticalWidget()),
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: const Text(
            "AVA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SliderVerticalWidget extends StatefulWidget {
  const SliderVerticalWidget({super.key});

  @override
  _SliderVerticalWidgetState createState() => _SliderVerticalWidgetState();
}

class _SliderVerticalWidgetState extends State<SliderVerticalWidget> {
  double value = 0;

  void state(double state, bool finalValue) {
    socket.emit("led", {'state': state, 'final': finalValue});
    setState(() => value = state);
  }

  late Socket socket;
  @override
  void initState() {
    initSocket();
    super.initState();
  }

  initSocket() {
    socket = io("http://192.168.1.191:2500", <String, dynamic>{
      'force new connection': true,
      "transports": ['websocket']
    });

    socket.onConnect((_) {
      socket.emit("ledState");
      print('connected');
    });

    socket.on("ledState", (data) {
      setState(() => value = double.parse(json.decode(data)["state"]));
    });

    socket.on("led", (data) {
      // print(json.decode(data)["state"]);
      setState(() => value = json.decode(data)["state"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double min = 0;
    const double max = 255;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 100,
        thumbShape: SliderComponentShape.noOverlay,
        overlayShape: SliderComponentShape.noOverlay,
        valueIndicatorShape: SliderComponentShape.noOverlay,
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            buildSideLabel("On"),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      activeColor: Colors.amber,
                      label: value.round().toString(),
                      onChanged: (value) => state(value, false),
                      onChangeEnd: (value) => state(value, true),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(value / 2.55).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            buildSideLabel("Off"),
          ],
        ),
      ),
    );
  }

  Widget buildSideLabel(String value) => TextButton(
        onPressed: () => state(value == "On" ? 255 : 0, true),
        child: Text(
          value,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
}
