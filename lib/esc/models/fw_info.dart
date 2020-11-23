import 'dart:convert';

import 'package:bldc_wizard/esc/parse_util.dart';

class FWInfo{
  int major;
  int minor;
  String name;
  List<int> uuid;
  int paired;
  int test;

  FWInfo(List<int> data){

    if(data.length > 2) {
      major = ParseUtil.takeInt8(data);
      minor = ParseUtil.takeInt8(data);

      name = ParseUtil.takeString(data);
    }

    if(data.length >= 12){
      uuid = ParseUtil.takeInt8List(data);
    }

    if(data.length >= 1){
      paired = ParseUtil.takeInt8(data);
    }

    if(data.length >= 1){
      test = ParseUtil.takeInt8(data);
    }
  }

  String getVersion(){
    if(test == 0){
      return "$major.$minor";
    }else{
      return "$major.$minor (Beta $test)";
    }
  }

  String getName(){
    return name;
  }

  String getUuid(){
    return uuid.map((e) => e.toRadixString(16)).map((e) => e.length == 1 ? "0$e" : e).reduce((value, element) => "$value $element").toUpperCase();
  }

  bool isPaired(){
    return paired > 0;
  }

  bool isSupported(){
    return true;
  }

}