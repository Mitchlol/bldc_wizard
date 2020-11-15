import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BLEUart{

  static const SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  static const RX_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  static const TX_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  BluetoothDevice device;
  BluetoothService service;
  BluetoothCharacteristic rxCharacteristic;
  BluetoothCharacteristic txCharacteristic;

  Future<bool> isIntialized;

  BLEUart(BluetoothDevice device){
    this.device = device;
    isIntialized = init();
  }
  
  Future<bool> init() async{
    try{
      await device.disconnect();
    }catch(e){
      print(e);
    }
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();

    if(services == null){
      throw Exception("Cant discover bluetooth services");
    }

    service = services.firstWhere((BluetoothService service) => service.uuid.toString() == SERVICE_UUID);
    rxCharacteristic = service.characteristics.firstWhere((characteristic) => characteristic.uuid.toString() == RX_UUID);
    txCharacteristic = service.characteristics.firstWhere((characteristic) => characteristic.uuid.toString() == TX_UUID);

    print("char is wat?: ${rxCharacteristic.runtimeType.toString()}");
    print("char is wat?: ${txCharacteristic.runtimeType.toString()}");

    if(service == null){
      throw Exception("Device does not have UART service");
    }

    if(rxCharacteristic == null){
      throw Exception("Device does not have UART RX characteristic");
    }

    if(txCharacteristic == null){
      throw Exception("Device does not have UART TX characteristic");
    }

    return true;
  }
  
  Future<Null> write(List<int> value){
    return rxCharacteristic.write(value);
  }

  Future<List<int>> read(){
    return txCharacteristic.read();
  }
}