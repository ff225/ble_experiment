import 'package:ble_experiment/model/bluetooth_item_model.dart';
import 'package:ble_experiment/widgets/bluetooth_item.dart';
import 'package:flutter/material.dart';

class BluetoothList extends StatelessWidget {
  const BluetoothList(this.devices, {super.key});

  final List<BluetoothModel> devices;

  @override
  Widget build(BuildContext context) {
    return devices.isEmpty
        ? const Center(
            child: Text('Scan'),
          )
        : ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) => BluetoothItem(
              devices[index],
            ),
          );
  }
}
