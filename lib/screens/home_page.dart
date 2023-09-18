import 'package:ble_experiment/provider/bluetooth_connect.dart';
import 'package:ble_experiment/provider/bluetooth_provider.dart';
import 'package:ble_experiment/widgets/bluetooth_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* TODO: questa pagina deve essere stateful perché il valore della lista è
 ottenuto dal tasto refresh
 */

class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(bluetoothProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Experiment'),
        actions: [
          IconButton.outlined(
            onPressed: () {
              ref.read(bluetoothProvider.notifier).scanDevice();
              ref
                  .read(bluetoothConnectionProvider.notifier)
                  .disconnectFromDevice();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BluetoothList(devices),
    );
  }
}
