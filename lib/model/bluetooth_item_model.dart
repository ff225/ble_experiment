import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothModel {
  BluetoothModel(this.id, this.name,
      {this.isConnected = DeviceConnectionState.disconnected, this.data = 0});

  final String id;
  final String name;
  DeviceConnectionState isConnected;
  dynamic data;
}
