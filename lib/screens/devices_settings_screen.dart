import 'package:ava_app/screens/add_device_screen.dart';
import 'package:ava_app/tiles/device_settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../addons/init_socket.dart';

class DevicesScreen extends StatefulWidget {
  final List devices;

  const DevicesScreen({super.key, required this.devices});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  void showPopup(index) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Warning!'),
              content: Text('Are you sure you want to delete "${widget.devices[index]["name"]}" device?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    setState(() => widget.devices.removeAt(index));
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: const Color(0xDFFFFFFF),
        child: const Icon(
          Icons.add,
          color: Color(0xff333333),
          size: 30,
        ),
        onPressed: () async {
          Map? newDevice = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDevice(),
            ),
          );

          setState(() {
            if (newDevice != null) {
              widget.devices.add(newDevice);
              socket.emit("setupDevices", [widget.devices]);
            }
          });
        },
      ),
      backgroundColor: const Color(0xFF1E1E1E),
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
        middle: const Text("Devices", style: TextStyle(color: Colors.white, fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ReorderableListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, index) => Padding(
            key: ObjectKey(widget.devices[index]),
            padding: const EdgeInsets.only(top: 15),
            child: Slidable(
              closeOnScroll: true,
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () => showPopup(index),
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      Map? newDevice = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDevice(
                            icon: widget.devices[index]["icon"],
                            name: widget.devices[index]["name"],
                            mqtt: {
                              "type": widget.devices[index]["type"],
                              "id": widget.devices[index]["id"],
                              "mqtt_Id": widget.devices[index]["mqtt_Id"],
                            },
                          ),
                        ),
                      );
                      setState(() {
                        if (newDevice != null) {
                          widget.devices.removeAt(index);
                          widget.devices.insert(index, newDevice);
                          socket.emit("setupDevices", [widget.devices]);
                        }
                      });
                    },
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (context) => showPopup(index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: DeviceSettings(
                device: widget.devices[index],
              ),
            ),
          ),
          itemCount: widget.devices.length,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = widget.devices.removeAt(oldIndex);
              widget.devices.insert(newIndex, item);
            });
          },
        ),
      ),
    );
  }
}
