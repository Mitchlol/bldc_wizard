import 'package:bldc_wizard/ble_uart.dart';
import 'package:crclib/crclib.dart';
import 'package:crclib/catalog.dart';

class BLDC {
  BLEUart uart;

  BLDC(BLEUart uart) {
    this.uart = uart;
  }


  void sendIt(List<int> data){
    int crc = int.parse(Crc16().convert(data).toRadixString(10));
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