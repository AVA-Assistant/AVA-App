import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddDevice extends StatefulWidget {
  final int? icon;
  final String? name;
  final Map? mqtt;
  const AddDevice({super.key, this.icon, this.name, this.mqtt});

  @override
  State<AddDevice> createState() => _AddDeviceState(icon, name, mqtt);
}

class _AddDeviceState extends State<AddDevice> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String camStatus = "Scan...";

  bool camera = false;
  int? icon;
  String? name;
  Map? mqtt;

  _AddDeviceState(this.icon, this.name, this.mqtt);

  _pickIcon() async {
    IconData? tempIcon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.cupertino],
      backgroundColor: const Color(0xAA353535),
      iconColor: Colors.white,
    );
    setState(() {
      icon = tempIcon!.codePoint;
    });
  }

  _turnOnCamera() {
    FocusScope.of(context).unfocus();

    setState(() {
      camera = true;
    });
    if (controller != null) controller!.resumeCamera();
  }

  _passDataBack() {
    if (icon != null && name != "" && name != null) {
      mqtt!["icon"] = icon;
      mqtt!["name"] = name;

      Navigator.pop(context, mqtt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        middle: const Text(
          "Devices",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      floatingActionButton: icon != null && name != ""
          ? FloatingActionButton(
              elevation: 5,
              backgroundColor: const Color(0xDFFFFFFF),
              onPressed: _passDataBack,
              child: const Icon(
                Icons.check,
                color: Color(0xff333333),
                size: 30,
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(75)),
                  color: Color(0xFF181818),
                  boxShadow: [
                    BoxShadow(color: Color(0x99000000), blurRadius: 10, blurStyle: BlurStyle.solid),
                  ],
                ),
                height: 125,
                width: 125,
                child: IconButton(
                  icon: Icon(
                    icon != null ? IconData(icon!, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage) : Icons.question_mark,
                    size: 75,
                    color: Colors.white,
                  ),
                  onPressed: _pickIcon,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: _pickIcon,
                child: const Text("Choose", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ),
            const Text(
              "Choose name",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 7.5),
            TextFormField(
                initialValue: name,
                maxLength: 12,
                onChanged: (value) => setState(() => name = value),
                cursorColor: Colors.white,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  filled: true,
                  fillColor: Color(0xFF181818),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                )),
            const SizedBox(height: 10),
            const Text(
              "Scan QR code",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 7.5),
            if (!camera)
              TextButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF181818)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    )),
                onPressed: () => _turnOnCamera(),
                child: Text(mqtt == null ? camStatus : "Scan again...", style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            if (camera)
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 400,
                width: 400,
                child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
              )
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        try {
          Map tempMqtt = json.decode(scanData.code.toString());
          if (tempMqtt.containsKey("id") && tempMqtt.containsKey("type") && tempMqtt.containsKey("mqtt_Id")) {
            mqtt = tempMqtt;
            camStatus = "Scanned! Scan again...";
          } else {
            camStatus = "Wrong QR code! Scan again.";
          }
        } catch (e) {
          camStatus = "Wrong QR code! Scan again.";
        }

        camera = false;
      });

      controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }
}
