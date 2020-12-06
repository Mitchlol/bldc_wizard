import 'esc/bldc.dart';
import 'esc/esc_state.dart';

class Model{
  BLDC bldc;
  Map<int, ESCState> devices = Map();

  bool isValid(){
    if(devices.isEmpty){
      return false;
    }
    for(ESCState escState in devices.values){
      if(escState.fwInfo == null || !escState.fwInfo.isSupported()){
        return false;
      }
      if(escState.motorConfig == null){
        return false;
      }
    }
    return true;
  }
}