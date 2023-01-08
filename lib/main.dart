import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  double value = 75;

  void state(double state) {
    changeLed(255 - state);
    setState(() => value = state);
  }

  Future<http.Response> changeLed(double newState) {
    return http.post(
      Uri.parse('http://192.168.1.191:2500/led'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'status': newState,
      }),
    );
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

        /// ticks in between
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
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
                      divisions: 20,
                      label: value.round().toString(),
                      onChanged: (value) => state(value),
                      onChangeEnd: (value) => state(value),
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

  Widget buildSideLabel(String value) => Text(
        value,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      );
}
