import 'package:ble_experiment/model/bluetooth_item_model.dart';
import 'package:ble_experiment/provider/bluetooth_connect.dart';
import 'package:ble_experiment/screens/manage_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothItem extends ConsumerWidget {
  const BluetoothItem(this.device, {super.key});

  final BluetoothModel device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(bluetoothConnectionProvider);
    return ListTile(
      title: Text(device.id),
      subtitle: Text(device.name),
      onTap: () {
        if (device.name != status.name) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Devi prima connetterti a: ${device.name}'),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                if (device.name == status.name &&
                    status.isConnected == DeviceConnectionState.disconnected) {
                  ref
                      .read(bluetoothConnectionProvider.notifier)
                      .disconnectFromDevice(/*device*/);
                }
                return const ManageBluetoothScreen();
              },
            ),
          );
        }
      },
      trailing: TextButton.icon(
        onPressed: () {
          if (status.isConnected == DeviceConnectionState.disconnected) {
            ref
                .read(bluetoothConnectionProvider.notifier)
                .connectToDevice(device);
          } else {
            ref
                .read(bluetoothConnectionProvider.notifier)
                .disconnectFromDevice(/*device*/);
          }
        },
        /*
            .read(bluetoothConnectionProvider.notifier)
            .disconnectFromDevice(device),*/

        icon: Icon(status.isConnected == DeviceConnectionState.disconnected
            ? Icons.bluetooth
            : Icons.bluetooth_connected),
        label: Text(status.id == device.id
            ? status.isConnected.name
            : DeviceConnectionState.disconnected.name),
      ),
    );
  }
}
