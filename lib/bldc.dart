import 'dart:typed_data';

import 'package:bldc_wizard/ble_uart.dart';
import 'package:crclib/crclib.dart';
import 'package:crclib/catalog.dart';

class BLDC {
  BLEUart uart;

  BLDC(BLEUart uart) {
    this.uart = uart;
  }


  Future<Null> sendIt(List<int> data){
    // Hardcode firmware version request
    data = Uint8List(6);
    // data[0] = 2;
    // data[1] = 1;
    // data[2] = 29;
    // data[3] = int.parse(Crc16().convert([29]).toRadixString(10));
    // data[4] = 0;
    // data[5] = 3;

    // data[0] = 0x02;
    // data[1] = 0x01;
    // data[2] = 0x00;
    // data[3] = 0x00;
    // data[4] = 0x00;
    // data[5] = 0x03;


    data[0] = 0x02;
    data[1] = 0x01;
    data[2] = 0x1d;
    data[3] = 0xc3;
    data[4] = 0x9c;
    data[5] = 0x03;

    // data[5] = 3;
    // data.add(0);
    //
    // int crc = int.parse(Crc16().convert([0]).toRadixString(10));
    //
    // print("Data = $data");
    // print("CRC = $crc");
    //
    // data.insert(0, 2);
    // data.insert(1, 1);
    // data.add(crc);
    // data.add(3);

    print("Final data = $data");

    return uart.write(data);
  }

  void readIt(){
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