import 'dart:async';

import 'package:ble_experiment/model/bluetooth_item_model.dart';
import 'package:ble_experiment/notifications/local_notification_service.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothConnectNotifier extends StateNotifier<BluetoothModel> {
  BluetoothConnectNotifier()
      : super(/*DeviceConnectionState.disconnected */ BluetoothModel('', ''));

  final _ble = FlutterReactiveBle();
  StreamSubscription<ConnectionStateUpdate>? _connection;

  void connectToDevice(BluetoothModel device) {
    _connection = _ble
        .connectToAdvertisingDevice(
      id: device.id,
      withServices: [],
      prescanDuration: const Duration(seconds: 5),
    )
        .listen((event) {
      print(event.connectionState.name);
      if (event.connectionState == DeviceConnectionState.connected) {
        showLocalNotification(device.name, event.connectionState.name);
      }
      state = BluetoothModel(device.id, device.name,
          isConnected: event.connectionState);
    });
  }

  Future<void> readFromDevice(BluetoothModel device) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse("181A"),
        characteristicId: Uuid.parse("2A6E"),
        deviceId: device.id);
    final response = await _ble.readCharacteristic(characteristic);
    state = BluetoothModel(state.id, state.name,
        isConnected: state.isConnected, data: response[0]);
    print(response);
  }

  void disconnectFromDevice(/*BluetoothModel device*/) async {
    await _connection
        ?.cancel()
        .whenComplete(() => state = BluetoothModel('', ''));
  }
}

final bluetoothConnectionProvider =
    StateNotifierProvider.autoDispose<BluetoothConnectNotifier, BluetoothModel>(
        (ref) => BluetoothConnectNotifier());
