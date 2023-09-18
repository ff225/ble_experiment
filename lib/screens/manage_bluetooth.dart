import 'package:ble_experiment/provider/bluetooth_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageBluetoothScreen extends ConsumerWidget {
  const ManageBluetoothScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothItem = ref.watch(bluetoothConnectionProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(bluetoothItem.name),
        actions: [
          Column(
            children: [
              Text(bluetoothItem.isConnected.name),
              const SizedBox(
                height: 2,
              ),
              Text(bluetoothItem.id),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (bluetoothItem.isConnected ==
                      DeviceConnectionState.connected) {
                    ref
                        .read(bluetoothConnectionProvider.notifier)
                        .readFromDevice(bluetoothItem);
                  }
                },
                child: const Text('Leggi'),
              )
            ],
          )
        ],
      ),
    );
  }
}
