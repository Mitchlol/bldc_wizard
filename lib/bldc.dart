import 'dart:typed_data';

import 'package:bldc_wizard/ble_uart.dart';
import 'package:crclib/crclib.dart';
import 'package:crclib/catalog.dart';
import 'package:flutter/material.dart';

class BLDC {
  BLEUart uart;

  BLDC(BLEUart uart) {
    this.uart = uart;
  }

  Future<Null> sendIt(List<int> message) {
    // Hardcode message for testing
    message = [0x1d]; // Reboot
    // message = [0x1e]; // Alive
    // message = [0x00]; // Get Firmware

    // Calculate CRC
    CrcValue crc = Crc16Xmodem().convert(message);
    int crcint = int.parse(crc.toRadixString(10));
    int crcLow = crcint & 0xff;
    int crcHigh = crcint >> 8;

    // Build request
    List<int> request = List();
    request.add(0x02);
    request.add(message.length);
    request.addAll(message);
    request.add(crcHigh);
    request.add(crcLow);
    request.add(0x03);

    // Working Reboot Request
    // request[0] = 0x02;
    // request[1] = 0x01;
    // request[2] = 0x1d;
    // request[3] = 0xc3;
    // request[4] = 0x9c;
    // request[5] = 0x03;

    print("Final data = ${request.map((e) => e.toRadixString(16))}");

    return uart.write(request);
  }

  void readIt() {
    uart.read().then((value) => print("Response: $value"), onError: (error) => print("Response Error = $error"));
  }

}

// int PackSendPayload
// (
// uint8_t* payload,
//
// int lenPay, int
// num) {
// uint16_t crcPayload = crc16(payload, lenPay);
// int count = 0;
// uint8_t messageSend[256];
//
// if (lenPay <= 256)
// {
// messageSend[count++] = 2;
// messageSend[count++] = lenPay;
// }
// else
// {
// messageSend[count++] = 3;
// messageSend[count++] = (uint8_t)(lenPay >> 8);
// messageSend[count++] = (uint8_t)(lenPay & 0xFF);
// }
// memcpy(&messageSend[count], payload, lenPay);
//
// count += lenPay;
// messageSend[count++] = (uint8_t)(crcPayload >> 8);
// messageSend[count++] = (uint8_t)(crcPayload & 0xFF);
// messageSend[count++] = 3;
// messageSend[count] = NULL;
//
// #ifdef DEBUG
// DEBUGSERIAL.print("UART package send: "); SerialPrint(messageSend, count);
//
// #endif // DEBUG
//
//
// HardwareSerial *serial;
// #ifdef __AVR_ATmega2560__
// switch (num) {
// case 0:
// serial=&Serial;
// break;
// case 1:
// serial=&Serial1;
// break;
// case 2:
// serial=&Serial2;
// break;
// case 3:
// serial=&Serial3;
// break;
// default:
// break;
// }
// #endif
// //Sending package
// serial->write(messageSend, count);
//
//
// //Returns number of send bytes
// return count;
// }
