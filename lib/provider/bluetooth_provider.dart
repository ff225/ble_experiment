import 'dart:async';

import 'package:ble_experiment/model/bluetooth_item_model.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothNotifier extends StateNotifier<List<BluetoothModel>> {
  BluetoothNotifier() : super([]);
  final _ble = FlutterReactiveBle();

  void scanDevice() {
    final List<BluetoothModel> discoveredDevice = [];

    _ble.statusStream.listen((event) async {
      print(event.name);
      switch (event) {
        case BleStatus.unauthorized:
          var statusBle = await Permission.bluetooth.status;
          var statusLocation = await Permission.location.status;
          print(statusBle.name);
          if (!statusBle.isGranted || !statusLocation.isGranted) {
            await [Permission.bluetooth, Permission.location].request();
          }
          break;
        case BleStatus.unknown:
          print('Stato unknown');
          break;
        case BleStatus.ready:
          state = [];
          final test = _ble.scanForDevices(withServices: []).listen((event) {
            if (event.name != '' &&
                discoveredDevice
                    .where((element) => element.id == event.id)
                    .isEmpty) {
              discoveredDevice.add(
                BluetoothModel(event.id, event.name),
              );
            }
          });

          Timer(
            const Duration(seconds: 5),
            () {
              state = discoveredDevice;
              test.cancel();
            },
          );
          break;
        default:
          print('default value');
      }
    });
  }
}

final bluetoothProvider =
    StateNotifierProvider<BluetoothNotifier, List<BluetoothModel>>(
        (ref) => BluetoothNotifier());
