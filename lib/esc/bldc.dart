import 'package:bldc_wizard/esc/ble_uart.dart';
import 'package:bldc_wizard/esc/models/fw_info.dart';
import 'package:bldc_wizard/esc/models/motor_config.dart';
import 'package:bldc_wizard/esc/parse_util.dart';
import 'package:crclib/crclib.dart';
import 'package:crclib/catalog.dart';
import 'package:flutter/material.dart';

import './models/comm_code.dart';

class BLDC {
  BLEUart uart;
  List<int> _buffer;

  Stream responseStream;
  Stream state;

  BLDC(BLEUart uart) {
    this.uart = uart;
    responseStream = this.uart.getDataStream().map(_onRecievePacket).where((it) => it != null).asBroadcastStream();
    state = this.uart.device.state;
  }

  Future<Null> _sendIt(List<int> message) {

    // Calculate CRC
    CrcValue crc = Crc16Xmodem().convert(message);
    int crcint = int.parse(crc.toRadixString(10));
    int crcLow = crcint & 0xff;
    int crcHigh = crcint >> 8;

    // Build request
    List<int> request = List();

    // Add message length
    int messageLength = message.length;
    if(messageLength < 256){
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

    debugPrint("Final data = ${request.map((e) => e.toRadixString(16)).toList()}", wrapWidth: 1024);

    return uart.write(request).then((value) {
      print("Write Success!");
    }, onError: (value) {
      print("Write Fail! $value");
    });
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
    print("Message: $message");
    switch (CommCode.values[message.removeAt(0)]) {
      case CommCode.COMM_FW_VERSION:
        return FWInfo(message);
        break;
      case CommCode.COMM_GET_MCCONF:
        return MotorConfig(message);
        break;
      default:
        return null;
    }
  }

  Stream<T> getStream<T>() {
    return responseStream.takeWhile((element) => element is T).cast<T>();
  }

  Future<bool> requestFirmwareInfo() {
    return _sendIt([CommCode.COMM_FW_VERSION.index]);
  }

  Future<bool> requestGetValues() {
    return _sendIt([CommCode.COMM_GET_VALUES.index]);
  }

  Future<bool> requestMotorConfig() {
    return _sendIt([CommCode.COMM_GET_MCCONF.index]);
  }

  Future<bool> writeMotorConfig(MotorConfig config){
    List<int> data = config.serialize();
    data.insert(0, CommCode.COMM_SET_MCCONF.index);
    return _sendIt(data);
  }
}

// int PackSendPayload
// (

