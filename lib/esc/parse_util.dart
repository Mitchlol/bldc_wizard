import 'dart:convert';

import 'dart:math';

class ParseUtil{

  static String takeString(List<int> data){
    int stringEndIndex = data.indexWhere((it) => it == 0);
    String string = utf8.decode(data.sublist(0, stringEndIndex));
    data.removeRange(0, stringEndIndex);
    data.removeAt(0);
    return string;
  }

  static int takeInt8(List<int> data){
    return data.removeAt(0);
  }

  static int takeInt8s(List<int> data){
    return takeInt8(data).toSigned(8);
  }

  static List<int> takeInt8List(List<int> data){
    List<int> list = data.sublist(0, 12);
    data.removeRange(0, 12);
    return list;
  }

  static int takeInt16(List<int> data){
    return (data.removeAt(0) << 8) + data.removeAt(0);
  }

  static int takeInt16s(List<int> data){
    return takeInt16(data).toSigned(16);
  }

  static int takeInt32(List<int> data){
    return (data.removeAt(0) << 24) + (data.removeAt(0) << 16) + (data.removeAt(0) << 8) + data.removeAt(0);
  }

  static int takeInt32s(List<int> data){
    return takeInt32(data).toSigned(32);
  }

  static double takeDouble2Byte(List<int> data, int scale){
    return takeInt16(data) / scale;
  }

  static double takeDouble(List<int> data){
    int res = takeInt32(data);

    int e = (res >> 23) & 0xFF;
    int sigI = res & 0x7FFFFF;
    bool neg = (res & (1 << 31)) == 1;

    double sig = 0.0;
    if (e != 0 || sigI != 0) {
        sig = sigI / (8388608.0 * 2.0) + 0.5;
        e -= 126;
    }

    if (neg) {
       sig = -sig;
    }

    return sig * pow(2, e);
  }

  static bool takeBoolean(List<int> data){
    return data.removeAt(0) == 1;
  }
}