import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool camera = false;
  IconData? icon;
  String name = "";
  Map? mqtt;

  _pickIcon() async {
    IconData? tempIcon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.material],
      backgroundColor: const Color(0xAA353535),
      iconColor: Colors.white,
    );
    setState(() {
      icon = tempIcon;
    });
  }

  _turnOnCamera() {
    setState(() {
      camera = true;
    });
    if (controller != null) controller!.resumeCamera();
  }

  _passDataBack() {
    if (icon != null && name != "" && mqtt != null) {
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
      floatingActionButton: icon != null && name != "" && mqtt != null
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
            const Text(
              "Choose a name:",
              style: TextStyle(color: Colors.white70, fontSize: 22),
            ),
            TextField(
                onChanged: (value) => setState(() {
                      name = value;
                    }),
                cursorColor: Colors.white,
                style: const TextStyle(fontSize: 20, color: Colors.white),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                )),
            const SizedBox(height: 30),
            const Text(
              "Choose an icon:",
              style: TextStyle(color: Colors.white70, fontSize: 22),
            ),
            const SizedBox(height: 20),
            icon == null
                ? TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: _pickIcon,
                    child: const Text("Choose...", style: TextStyle(fontSize: 20, color: Colors.white)),
                  )
                : SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                      icon: Icon(icon, size: 50, color: Colors.white),
                      onPressed: _pickIcon,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
            const SizedBox(height: 20),
            const Text(
              "Scan QR code:",
              style: TextStyle(color: Colors.white70, fontSize: 22),
            ),
            mqtt == null
                ? TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => _turnOnCamera(),
                    child: const Text("Scan...", style: TextStyle(fontSize: 20, color: Colors.white)),
                  )
                : TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => _turnOnCamera(),
                    child: const Text("Scaned! Scan again.", style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
            if (camera)
              SizedBox(
                height: 400,
                width: 400,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              )
          ],
        ),
      ),
      backgroundColor: const Color(0xFF222222),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        mqtt = json.decode(scanData.code.toString());
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
