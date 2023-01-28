import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  IconData? icon;
  String? name;

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
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                )),
            const SizedBox(height: 30),
            const Text(
              "Choose an icon:",
              style: TextStyle(color: Colors.white70, fontSize: 22),
            ),
            const SizedBox(height: 10),
            icon == null
                ? TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => _pickIcon(),
                    child: const Text("Choose...", style: TextStyle(fontSize: 20, color: Colors.white)),
                  )
                : IconButton(
                    icon: Icon(icon, size: 50, color: Colors.white),
                    onPressed: () => _pickIcon(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF222222),
    );
  }
}
