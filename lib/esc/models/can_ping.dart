import 'dart:convert';

import 'package:bldc_wizard/esc/parse_util.dart';

class CanPing{
  List<int> canIds;

  CanPing(List<int> data){
    canIds = data;
  }

}