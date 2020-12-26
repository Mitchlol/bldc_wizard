import 'package:bldc_wizard/esc/ble_uart.dart';
import 'package:bldc_wizard/esc/models/app_config.dart';
import 'package:bldc_wizard/esc/models/can_ping.dart';
import 'package:bldc_wizard/esc/models/fw_info.dart';
import 'package:bldc_wizard/esc/models/motor_config.dart';
import 'package:bldc_wizard/esc/parse_util.dart';
import 'package:crclib/crclib.dart';
import 'package:crclib/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';

import './models/comm_code.dart';
import 'models/motor_config_set.dart';

class BLDC {
  BLEUart uart;
  List<int> _buffer;

  Stream responseStream;
  BehaviorSubject<BluetoothDeviceState> state = BehaviorSubject<BluetoothDeviceState>();

  BLDC(BLEUart uart) {
    this.uart = uart;
    responseStream = this.uart.getDataStream().map(_onRecievePacket).where((it) => it != null).asBroadcastStream();
    this.uart.device.state.listen((event) {
      state.add(event);
    });
  }

  Future<bool> _sendIt(List<int> message) {
    return _writePackets(_buildRequest(message));
  }

  Future<bool> _writePackets(List<int> request) async {
    print("Write: request length = ${request.length}, splitting into ${(request.length / 20).ceil()} packets");

    bool failures = false;
    while (request.isNotEmpty) {
      List<int> batch = request.take(20).toList();
      print("Write batch: length = ${batch.length}, batch = $batch");
      await uart.write(batch).then((value) {
        print("Write Success!");
      }, onError: (value) {
        print("Write Fail! $value");
        failures = true;
      });
      request.removeRange(0, batch.length);
    }
    return failures;
  }

  List<int> _buildRequest(List<int> message) {
    // Calculate CRC
    CrcValue crc = Crc16Xmodem().convert(message);
    int crcint = int.parse(crc.toRadixString(10));
    int crcLow = crcint & 0xff;
    int crcHigh = crcint >> 8;

    // Build request
    List<int> request = List();

    // Add message length
    int messageLength = message.length;
    if (messageLength < 256) {
      request.add(0x02);
      ParseUtil.putInt8(request, messageLength);
    } else if (messageLength < 65536) {
      request.add(0x03);
      ParseUtil.putInt16(request, messageLength);
    } else {
      request.add(0x04);
      ParseUtil.putInt24(request, messageLength);
    }

    request.addAll(message);
    request.add(crcHigh);
    request.add(crcLow);
    request.add(0x03);

    debugPrint("Request = ${request.map((e) => e.toRadixString(16)).toList()}", wrapWidth: 1024);

    return request;
  }

  dynamic _onRecievePacket(List<int> packet) {
    // Starting fresh message
    if (_buffer == null) {
      if (packet.isEmpty || (packet.first != 2 && packet.first != 3 && packet.first != 4)) {
        // Not the start of a message, ignore this packet
        print("onRecievePacket: Invalid packet start, discarding");
        return;
      }
      _buffer = List<int>();
    }

    // Add packet to message
    _buffer.addAll(packet);

    // Get message length
    int messageLength;
    if (_buffer[0] == 2) {
      messageLength = _buffer[1];
    } else if (_buffer[0] == 3) {
      messageLength = (_buffer[1] << 8) + _buffer[2];
    } else {
      messageLength = (_buffer[1] << 16) + (_buffer[2] << 8) + _buffer[3];
    }

    // Check for message done
    if (_buffer.length >= messageLength + 4 + (_buffer[0] - 1)) {
      // Check last byte
      if (_buffer.last != 3) {
        print("onRecievePacket: Invalid packet end, discarding");
        _buffer = null;
        return;
      }
      // Check CRC
      int crc = _buffer[_buffer.length - 2] + (_buffer[_buffer.length - 3] << 8);
      List<int> message = _buffer.sublist(_buffer[0], _buffer[0] + messageLength);
      CrcValue crc2 = Crc16Xmodem().convert(message);
      if (crc != int.parse(crc2.toRadixString(10))) {
        print(
            "onRecievePacket: CRC check failed, discarding.\nRecieved: ${crc.toRadixString(16)}\nCalculated: ${int.parse(crc2.toString()).toRadixString(16)}");
        _buffer = null;
        return;
      }

      _buffer = null;
      return onRecieveMessage(message);
    }
  }

  dynamic onRecieveMessage(List<int> message) {
    CommCode commCode = CommCode.values[message.removeAt(0)];
    switch (commCode) {
      case CommCode.COMM_FW_VERSION:
        return FWInfo(message);
        break;
      case CommCode.COMM_SET_MCCONF:
        MotorConfigSet empty = MotorConfigSet(message);
        return empty;
        break;
      case CommCode.COMM_GET_MCCONF:
        MotorConfig config = MotorConfig(message);
        return config;
        break;
      case CommCode.COMM_GET_APPCONF:
        AppConfig config = AppConfig(message);
        return config;
        break;
      case CommCode.COMM_PING_CAN:
        return CanPing(message);
        break;
      default:
        print("Unhandled message recieved: code = $commCode, message = $message");
        return null;
    }
  }

  Stream<T> getStream<T>() {
    return responseStream.where((element) => element is T).cast<T>();
  }

  Future<bool> requestFirmwareInfo({int canId}) {
    List<int> message = [CommCode.COMM_FW_VERSION.index];
    if (canId == null) {
      return _sendIt(message);
    } else {
      return _requestForwardCan(canId, message);
    }
  }

  Future<bool> requestPingCan() {
    return _sendIt([CommCode.COMM_PING_CAN.index]);
  }

  Future<bool> _requestForwardCan(int canId, List<int> message) {
    return _sendIt([CommCode.COMM_FORWARD_CAN.index, canId] + message);
  }

  Future<bool> requestGetValues() {
    return _sendIt([CommCode.COMM_GET_VALUES.index]);
  }

  Future<bool> requestMotorConfig({int canId}) {
    List<int> message = [CommCode.COMM_GET_MCCONF.index];
    if (canId == null) {
      return _sendIt(message);
    } else {
      return _requestForwardCan(canId, message);
    }
  }

  Future<bool> writeMotorConfig(MotorConfig config, {int canId}) {
    List<int> message = config.serialize();
    message.insert(0, CommCode.COMM_SET_MCCONF.index);
    if (canId == null) {
      return _sendIt(message);
    } else {
      return _requestForwardCan(canId, message);
    }
  }

  Future<bool> requestAppConfig({int canId}) {
    List<int> message = [CommCode.COMM_GET_APPCONF.index];
    if (canId == null) {
      return _sendIt(message);
    } else {
      return _requestForwardCan(canId, message);
    }
  }
}
