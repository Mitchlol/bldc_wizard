import 'dart:convert';

class FWInfo{
  int major;
  int minor;
  String name;
  List<int> uuid;
  int paired;
  int test;

  FWInfo(List<int> data){

    if(data.length > 2) {
      major = data.removeAt(0);
      minor = data.removeAt(0);

      int nameEndIndex = data.indexWhere((it) => it == 0);
      name = utf8.decode(data.sublist(0, nameEndIndex));
      data.removeRange(0, nameEndIndex);
      data.removeAt(0);
    }

    if(data.length >= 12){
      uuid = data.sublist(0, 12);
      data.removeRange(0, 12);
    }

    if(data.length >= 1){
      paired = data.removeAt(0);
    }

    if(data.length >= 1){
      test = data.removeAt(0);
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

}