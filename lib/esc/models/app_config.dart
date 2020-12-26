import '../parse_util.dart';

enum CanStatusMode {
  CAN_STATUS_DISABLED,
  CAN_STATUS_1,
  CAN_STATUS_1_2,
  CAN_STATUS_1_2_3,
  CAN_STATUS_1_2_3_4,
  CAN_STATUS_1_2_3_4_5,
}

enum CanBaud {
  CAN_BAUD_125K,
  CAN_BAUD_250K,
  CAN_BAUD_500K,
  CAN_BAUD_1M,
  CAN_BAUD_10K,
  CAN_BAUD_20K,
  CAN_BAUD_50K,
  CAN_BAUD_75K,
  CAN_BAUD_100K,
}

enum ShutdownMode {
  SHUTDOWN_MODE_ALWAYS_OFF,
  SHUTDOWN_MODE_ALWAYS_ON,
  SHUTDOWN_MODE_TOGGLE_BUTTON_ONLY,
  SHUTDOWN_MODE_OFF_AFTER_10S,
  SHUTDOWN_MODE_OFF_AFTER_1M,
  SHUTDOWN_MODE_OFF_AFTER_5M,
  SHUTDOWN_MODE_OFF_AFTER_10M,
  SHUTDOWN_MODE_OFF_AFTER_30M,
  SHUTDOWN_MODE_OFF_AFTER_1H,
  SHUTDOWN_MODE_OFF_AFTER_5H,
}

enum CanMode {
  CAN_MODE_VESC,
  CAN_MODE_UAVCAN,
  CAN_MODE_COMM_BRIDGE,
}

enum UAVCanRawMode {
  UAVCAN_RAW_MODE_CURRENT,
  UAVCAN_RAW_MODE_CURRENT_NO_REV_BRAKE,
  UAVCAN_RAW_MODE_DUTY,
}

enum AppUse {
  APP_NONE,
  APP_PPM,
  APP_ADC,
  APP_UART,
  APP_PPM_UART,
  APP_ADC_UART,
  APP_NUNCHUK,
  APP_NRF,
  APP_CUSTOM,
  APP_BALANCE,
  APP_PAS,
  APP_ADC_PAS,
}

enum PpmControlType {
  PPM_CTRL_TYPE_NONE,
  PPM_CTRL_TYPE_CURRENT,
  PPM_CTRL_TYPE_CURRENT_NOREV,
  PPM_CTRL_TYPE_CURRENT_NOREV_BRAKE,
  PPM_CTRL_TYPE_DUTY,
  PPM_CTRL_TYPE_DUTY_NOREV,
  PPM_CTRL_TYPE_PID,
  PPM_CTRL_TYPE_PID_NOREV,
  PPM_CTRL_TYPE_CURRENT_BRAKE_REV_HYST,
  PPM_CTRL_TYPE_CURRENT_SMART_REV,
}

enum ThrExpMode {
  THR_EXP_EXPO,
  THR_EXP_NATURAL,
  THR_EXP_POLY,
}

class PPMConfig {
  PpmControlType ctrlType;
  double pidMaxErpm;
  double hyst;
  double pulseStart;
  double pulseEnd;
  double pulseCenter;
  bool medianFilter;
  bool safeStart;
  double throttleExp;
  double throttleExpBrake;
  ThrExpMode throttleExpMode;
  double rampTimePos;
  double rampTimeNeg;
  bool multiEsc;
  bool tc;
  double tcMaxDiff;
  double maxErpmForDir;
  double smartRevMaxDuty;
  double smartRevRampTime;
}

enum ADCControlType {
  ADC_CTRL_TYPE_NONE,
  ADC_CTRL_TYPE_CURRENT,
  ADC_CTRL_TYPE_CURRENT_REV_CENTER,
  ADC_CTRL_TYPE_CURRENT_REV_BUTTON,
  ADC_CTRL_TYPE_CURRENT_REV_BUTTON_BRAKE_ADC,
  ADC_CTRL_TYPE_CURRENT_REV_BUTTON_BRAKE_CENTER,
  ADC_CTRL_TYPE_CURRENT_NOREV_BRAKE_CENTER,
  ADC_CTRL_TYPE_CURRENT_NOREV_BRAKE_BUTTON,
  ADC_CTRL_TYPE_CURRENT_NOREV_BRAKE_ADC,
  ADC_CTRL_TYPE_DUTY,
  ADC_CTRL_TYPE_DUTY_REV_CENTER,
  ADC_CTRL_TYPE_DUTY_REV_BUTTON,
  ADC_CTRL_TYPE_PID,
  ADC_CTRL_TYPE_PID_REV_CENTER,
  ADC_CTRL_TYPE_PID_REV_BUTTON,
}

class ADCConfig {
  ADCControlType ctrlType;
  double hyst;
  double voltageStart;
  double voltageEnd;
  double voltageCenter;
  double voltage2Start;
  double voltage2End;
  bool useFilter;
  bool safeStart;
  bool ccButtonInverted;
  bool revButtonInverted;
  bool voltageInverted;
  bool voltage2Inverted;
  double throttleExp;
  double throttleExpBrake;
  ThrExpMode throttleExpMode;
  double rampTimePos;
  double rampTimeNeg;
  bool multiEsc;
  bool tc;
  double tcMaxDiff;
  int updateRateHz; //uint32_t
}

enum ChukControlType {
  CHUK_CTRL_TYPE_NONE,
  CHUK_CTRL_TYPE_CURRENT,
  CHUK_CTRL_TYPE_CURRENT_NOREV,
  CHUK_CTRL_TYPE_CURRENT_BIDIRECTIONAL,
}

class ChukConfig {
  ChukControlType ctrlType;
  double hyst;
  double rampTimePos;
  double rampTimeNeg;
  double stickErpmPerSInCc;
  double throttleExp;
  double throttleExpBrake;
  ThrExpMode throttleExpMode;
  bool multiEsc;
  bool tc;
  double tcMaxDiff;
  bool useSmartRev;
  double smartRevMaxDuty;
  double smartRevRampTime;
}

enum NRFSpeed {
  NRF_SPEED_250K,
  NRF_SPEED_1M,
  NRF_SPEED_2M,
}

enum NRFPower {
  NRF_POWER_M18DBM,
  NRF_POWER_M12DBM,
  NRF_POWER_M6DBM,
  NRF_POWER_0DBM,
  NRF_POWER_OFF,
}

enum NRFCRC {
  NRF_CRC_DISABLED,
  NRF_CRC_1B,
  NRF_CRC_2B,
}

enum NRFRetryDelay {
  NRF_RETR_DELAY_250US,
  NRF_RETR_DELAY_500US,
  NRF_RETR_DELAY_750US,
  NRF_RETR_DELAY_1000US,
  NRF_RETR_DELAY_1250US,
  NRF_RETR_DELAY_1500US,
  NRF_RETR_DELAY_1750US,
  NRF_RETR_DELAY_2000US,
  NRF_RETR_DELAY_2250US,
  NRF_RETR_DELAY_2500US,
  NRF_RETR_DELAY_2750US,
  NRF_RETR_DELAY_3000US,
  NRF_RETR_DELAY_3250US,
  NRF_RETR_DELAY_3500US,
  NRF_RETR_DELAY_3750US,
  NRF_RETR_DELAY_4000US,
}

class NRFConfig {
  NRFSpeed speed;
  NRFPower power;
  NRFCRC crcType;
  NRFRetryDelay retryDelay;
  int retries; //unsigned char
  int channel; // unsigned char
  List<int> address; //unsigned char[3]
  bool sendCrcAck;
}

class BalanceConfig {
  double kp;
  double ki;
  double kd;
  int hertz; //unit16_t
  double faultPitch;
  double faultRoll;
  double faultDuty;
  double faultAdc1;
  double faultAdc2;
  int faultDelayPitch; //unit16_t
  int faultDelayRoll; //unit16_t
  int faultDelayDuty; //unit16_t
  int faultDelaySwitchHalf; //unit16_t
  int faultDelaySwitchFull; //unit16_t
  int faultAdcHalfErpm; //unit16_t
  double tiltbackAngle;
  double tiltbackSpeed;
  double tiltbackDuty;
  double tiltbackHighVoltage;
  double tiltbackLowVoltage;
  double tiltbackConstant;
  int tiltbackConstantErpm; //unit16_t
  double startupPitchTolerance;
  double startupRollTolerance;
  double startupSpeed;
  double deadzone;
  double currentBoost;
  bool multiEsc;
  double yawKp;
  double yawKi;
  double yawKd;
  double rollSteerKp;
  double rollSteerErpmKp;
  double brakeCurrent;
  double yawCurrentClamp;
  double setpointPitchFilter;
  double setpointTargetFilter;
  double setpointFilterClamp;
  int kdPt1Frequency; //unit16_t
}

// PAS control types
enum PasControlType {
  PAS_CTRL_TYPE_NONE,
  PAS_CTRL_TYPE_CADENCE,
}

// PAS sensor types
enum PasSensorType {
  PAS_SENSOR_TYPE_QUADRATURE,
}

class PasConfig{
  PasControlType ctrlType;
  PasSensorType sensorType;
  double currentScaling;
  double pedalRpmStart;
  double pedalRpmEnd;
  bool invertPedalDirection;
  int magnets; //uint8_t
  bool useFilter;
  double rampTimePos;
  double rampTimeNeg;
  int updateRateHz; //uint32_t
}

// IMU
enum IMUType{
  IMU_TYPE_OFF,
  IMU_TYPE_INTERNAL,
  IMU_TYPE_EXTERNAL_MPU9X50,
  IMU_TYPE_EXTERNAL_ICM20948,
  IMU_TYPE_EXTERNAL_BMI160,
  IMU_TYPE_EXTERNAL_LSM6DS3,
}

enum AHRSMode{
  AHRS_MODE_MADGWICK,
  AHRS_MODE_MAHONY,
}

class IMUConfig {
  IMUType type;
  AHRSMode mode;
  int sampleRateHz;
  double accelConfidenceDecay;
  double mahonyKp;
  double mahonyKi;
  double madgwickBeta;
  double rotRoll;
  double rotPitch;
  double rotYaw;
  List<double> accelOffsets; // 3
  List<double> gyroOffsets; // 3
  List<double> gyroOffsetCompFact; // 3
  double gyroOffsetCompClamp;
}

class AppConfig {
  static const int APPCONF_SIGNATURE = 3264926020;

  int signature; // uint32

  // Settings
  int controllerId; //uint8_t
  int timeoutMsec; //uint32_t
  double timeoutBrakeCurrent;
  CanStatusMode sendCanStatus;
  int sendCanStatusRateHz; //uint32_t
  CanBaud canBaudRate;
  bool pairingDone;
  bool permanentUartEnabled;
  ShutdownMode shutdownMode;
  CanMode canMode;
  int uavcanEscIndex; //uint8_t
  UAVCanRawMode uavcanRawMode;
  AppUse appToUse;
  PPMConfig appPpmConf;
  ADCConfig appAdcConf;
  int appUartBaudrate; //uint32_t
  ChukConfig appChukConf;
  NRFConfig appNrfConf;
  BalanceConfig appBalanceConf;
  PasConfig appPasConf;
  IMUConfig imuConf;
  int crc; //uint16_t

  AppConfig(List<int> data) {
    // Check signature
    signature = ParseUtil.takeInt32(data);
    if (signature != APPCONF_SIGNATURE) {
      print("Invalid App Conf $signature");
      throw Exception("Invalid App Conf signature $signature");
    } else {
      print("Valid App Conf $signature");
    }

    controllerId = ParseUtil.takeInt8(data);
    timeoutMsec = ParseUtil.takeInt32(data);
    timeoutBrakeCurrent = ParseUtil.takeDouble(data);
    sendCanStatus = CanStatusMode.values[ParseUtil.takeInt8(data)];
    sendCanStatusRateHz = ParseUtil.takeInt16(data);
    canBaudRate = CanBaud.values[ParseUtil.takeInt8(data)];
    pairingDone = ParseUtil.takeBoolean(data);
    permanentUartEnabled = ParseUtil.takeBoolean(data);
    shutdownMode = ShutdownMode.values[ParseUtil.takeInt8(data)];
    canMode = CanMode.values[ParseUtil.takeInt8(data)];
    uavcanEscIndex = ParseUtil.takeInt8(data);
    uavcanRawMode = UAVCanRawMode.values[ParseUtil.takeInt8(data)];
    appToUse = AppUse.values[ParseUtil.takeInt8(data)];
    appPpmConf = PPMConfig();
    appPpmConf.ctrlType = PpmControlType.values[ParseUtil.takeInt8(data)];
    appPpmConf.pidMaxErpm = ParseUtil.takeDouble(data);
    appPpmConf.hyst = ParseUtil.takeDouble(data);
    appPpmConf.pulseStart = ParseUtil.takeDouble(data);
    appPpmConf.pulseEnd = ParseUtil.takeDouble(data);
    appPpmConf.pulseCenter = ParseUtil.takeDouble(data);
    appPpmConf.medianFilter = ParseUtil.takeBoolean(data);
    appPpmConf.safeStart = ParseUtil.takeBoolean(data);
    appPpmConf.throttleExp = ParseUtil.takeDouble(data);
    appPpmConf.throttleExpBrake = ParseUtil.takeDouble(data);
    appPpmConf.throttleExpMode = ThrExpMode.values[ParseUtil.takeInt8(data)];
    appPpmConf.rampTimePos = ParseUtil.takeDouble(data);
    appPpmConf.rampTimeNeg = ParseUtil.takeDouble(data);
    appPpmConf.multiEsc = ParseUtil.takeBoolean(data);
    appPpmConf.tc = ParseUtil.takeBoolean(data);
    appPpmConf.tcMaxDiff = ParseUtil.takeDouble(data);
    appPpmConf.maxErpmForDir = ParseUtil.takeDouble(data);
    appPpmConf.smartRevMaxDuty = ParseUtil.takeDouble(data);
    appPpmConf.smartRevRampTime = ParseUtil.takeDouble(data);
    appAdcConf = ADCConfig();
    appAdcConf.ctrlType = ADCControlType.values[ParseUtil.takeInt8(data)];
    appAdcConf.hyst = ParseUtil.takeDouble(data);
    appAdcConf.voltageStart = ParseUtil.takeDouble(data);
    appAdcConf.voltageEnd = ParseUtil.takeDouble(data);
    appAdcConf.voltageCenter = ParseUtil.takeDouble(data);
    appAdcConf.voltage2Start = ParseUtil.takeDouble(data);
    appAdcConf.voltage2End = ParseUtil.takeDouble(data);
    appAdcConf.useFilter = ParseUtil.takeBoolean(data);
    appAdcConf.safeStart = ParseUtil.takeBoolean(data);
    appAdcConf.ccButtonInverted = ParseUtil.takeBoolean(data);
    appAdcConf.revButtonInverted = ParseUtil.takeBoolean(data);
    appAdcConf.voltageInverted = ParseUtil.takeBoolean(data);
    appAdcConf.voltage2Inverted = ParseUtil.takeBoolean(data);
    appAdcConf.throttleExp = ParseUtil.takeDouble(data);
    appAdcConf.throttleExpBrake = ParseUtil.takeDouble(data);
    appAdcConf.throttleExpMode = ThrExpMode.values[ParseUtil.takeInt8(data)];
    appAdcConf.rampTimePos = ParseUtil.takeDouble(data);
    appAdcConf.rampTimeNeg = ParseUtil.takeDouble(data);
    appAdcConf.multiEsc = ParseUtil.takeBoolean(data);
    appAdcConf.tc = ParseUtil.takeBoolean(data);
    appAdcConf.tcMaxDiff = ParseUtil.takeDouble(data);
    appAdcConf.updateRateHz = ParseUtil.takeInt16(data);
    appUartBaudrate = ParseUtil.takeInt32(data);
    appChukConf = ChukConfig();
    appChukConf.ctrlType = ChukControlType.values[ParseUtil.takeInt8(data)];
    appChukConf.hyst = ParseUtil.takeDouble(data);
    appChukConf.rampTimePos = ParseUtil.takeDouble(data);
    appChukConf.rampTimeNeg = ParseUtil.takeDouble(data);
    appChukConf.stickErpmPerSInCc = ParseUtil.takeDouble(data);
    appChukConf.throttleExp = ParseUtil.takeDouble(data);
    appChukConf.throttleExpBrake = ParseUtil.takeDouble(data);
    appChukConf.throttleExpMode = ThrExpMode.values[ParseUtil.takeInt8(data)];
    appChukConf.multiEsc = ParseUtil.takeBoolean(data);
    appChukConf.tc = ParseUtil.takeBoolean(data);
    appChukConf.tcMaxDiff = ParseUtil.takeDouble(data);
    appChukConf.useSmartRev = ParseUtil.takeBoolean(data);
    appChukConf.smartRevMaxDuty = ParseUtil.takeDouble(data);
    appChukConf.smartRevRampTime = ParseUtil.takeDouble(data);
    appNrfConf = NRFConfig();
    appNrfConf.speed = NRFSpeed.values[ParseUtil.takeInt8(data)];
    appNrfConf.power = NRFPower.values[ParseUtil.takeInt8(data)];
    appNrfConf.crcType = NRFCRC.values[ParseUtil.takeInt8(data)];
    appNrfConf.retryDelay = NRFRetryDelay.values[ParseUtil.takeInt8(data)];
    appNrfConf.retries = ParseUtil.takeInt8s(data);// Signed????
    appNrfConf.channel = ParseUtil.takeInt8s(data);// Signed????
    appNrfConf.address = ParseUtil.takeInt8List(data, 3);
    appNrfConf.sendCrcAck = ParseUtil.takeBoolean(data);
    appBalanceConf = BalanceConfig();
    appBalanceConf.kp = ParseUtil.takeDouble(data);
    appBalanceConf.ki = ParseUtil.takeDouble(data);
    appBalanceConf.kd = ParseUtil.takeDouble(data);
    appBalanceConf.hertz = ParseUtil.takeInt16(data);
    appBalanceConf.faultPitch = ParseUtil.takeDouble(data);
    appBalanceConf.faultRoll = ParseUtil.takeDouble(data);
    appBalanceConf.faultDuty = ParseUtil.takeDouble(data);
    appBalanceConf.faultAdc1 = ParseUtil.takeDouble(data);
    appBalanceConf.faultAdc2 = ParseUtil.takeDouble(data);
    appBalanceConf.faultDelayPitch = ParseUtil.takeInt16(data);
    appBalanceConf.faultDelayRoll = ParseUtil.takeInt16(data);
    appBalanceConf.faultDelayDuty = ParseUtil.takeInt16(data);
    appBalanceConf.faultDelaySwitchHalf = ParseUtil.takeInt16(data);
    appBalanceConf.faultDelaySwitchFull = ParseUtil.takeInt16(data);
    appBalanceConf.faultAdcHalfErpm = ParseUtil.takeInt16(data);
    appBalanceConf.tiltbackAngle = ParseUtil.takeDouble(data);
    appBalanceConf.tiltbackSpeed = ParseUtil.takeDouble(data);
    appBalanceConf.tiltbackDuty = ParseUtil.takeDouble(data);
    appBalanceConf.tiltbackHighVoltage = ParseUtil.takeDouble(data);
    appBalanceConf.tiltbackLowVoltage = ParseUtil.takeDouble(data);
    appBalanceConf.tiltbackConstant = ParseUtil.takeDouble(data);
    appBalanceConf.tiltbackConstantErpm = ParseUtil.takeInt16(data);
    appBalanceConf.startupPitchTolerance = ParseUtil.takeDouble(data);
    appBalanceConf.startupRollTolerance = ParseUtil.takeDouble(data);
    appBalanceConf.startupSpeed = ParseUtil.takeDouble(data);
    appBalanceConf.deadzone = ParseUtil.takeDouble(data);
    appBalanceConf.currentBoost = ParseUtil.takeDouble(data);
    appBalanceConf.multiEsc = ParseUtil.takeBoolean(data);
    appBalanceConf.yawKp = ParseUtil.takeDouble(data);
    appBalanceConf.yawKi = ParseUtil.takeDouble(data);
    appBalanceConf.yawKd = ParseUtil.takeDouble(data);
    appBalanceConf.rollSteerKp = ParseUtil.takeDouble(data);
    appBalanceConf.rollSteerErpmKp = ParseUtil.takeDouble(data);
    appBalanceConf.brakeCurrent = ParseUtil.takeDouble(data);
    appBalanceConf.yawCurrentClamp = ParseUtil.takeDouble(data);
    appBalanceConf.setpointPitchFilter = ParseUtil.takeDouble(data);
    appBalanceConf.setpointTargetFilter = ParseUtil.takeDouble(data);
    appBalanceConf.setpointFilterClamp = ParseUtil.takeDouble(data);
    appBalanceConf.kdPt1Frequency = ParseUtil.takeInt16(data);
    appPasConf = PasConfig();
    appPasConf.ctrlType = PasControlType.values[ParseUtil.takeInt8(data)];
    appPasConf.sensorType = PasSensorType.values[ParseUtil.takeInt8(data)];
    appPasConf.currentScaling = ParseUtil.takeDouble2Byte(data, 1000);
    appPasConf.pedalRpmStart = ParseUtil.takeDouble2Byte(data, 10);
    appPasConf.pedalRpmEnd = ParseUtil.takeDouble2Byte(data, 10);
    appPasConf.invertPedalDirection = ParseUtil.takeBoolean(data);
    appPasConf.magnets = ParseUtil.takeInt16(data);
    appPasConf.useFilter = ParseUtil.takeBoolean(data);
    appPasConf.rampTimePos = ParseUtil.takeDouble2Byte(data, 100);
    appPasConf.rampTimeNeg =ParseUtil.takeDouble2Byte(data, 100);
    appPasConf.updateRateHz = ParseUtil.takeInt16(data);
    imuConf = IMUConfig();
    imuConf.type = IMUType.values[ParseUtil.takeInt8(data)];
    imuConf.mode = AHRSMode.values[ParseUtil.takeInt8(data)];
    imuConf.sampleRateHz = ParseUtil.takeInt16(data);
    imuConf.accelConfidenceDecay = ParseUtil.takeDouble(data);
    imuConf.mahonyKp = ParseUtil.takeDouble(data);
    imuConf.mahonyKi = ParseUtil.takeDouble(data);
    imuConf.madgwickBeta = ParseUtil.takeDouble(data);
    imuConf.rotRoll = ParseUtil.takeDouble(data);
    imuConf.rotPitch = ParseUtil.takeDouble(data);
    imuConf.rotYaw = ParseUtil.takeDouble(data);
    imuConf.accelOffsets = ParseUtil.takeDoubleList(data, 3);
    imuConf.gyroOffsets = ParseUtil.takeDoubleList(data, 3);
    imuConf.gyroOffsetCompFact = ParseUtil.takeDoubleList(data, 3);
    imuConf.gyroOffsetCompClamp = ParseUtil.takeDouble(data);

    print("Parsed App Config, gyroOffsetCompClamp = ${imuConf.gyroOffsetCompClamp}, tiltbackAngle = ${appBalanceConf.tiltbackAngle}");
  }

  List<int> serialize() {
    List<int> serialized = List<int>();

    return serialized;
  }
}
