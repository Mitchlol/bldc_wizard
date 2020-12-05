import 'package:bldc_wizard/esc/parse_util.dart';

import 'comm_code.dart';

enum McPwmMode {
  PWM_MODE_NONSYNCHRONOUS_HISW,
  PWM_MODE_SYNCHRONOUS,
  PWM_MODE_BIPOLAR,
}

enum McCommMode {
  COMM_MODE_INTEGRATE,
  COMM_MODE_DELAY,
}

enum McSensorMode {
  SENSOR_MODE_SENSORLESS,
  SENSOR_MODE_SENSORED,
  SENSOR_MODE_HYBRID,
}

enum McFocSensorMode {
  FOC_SENSOR_MODE_SENSORLESS,
  FOC_SENSOR_MODE_ENCODER,
  FOC_SENSOR_MODE_HALL,
  FOC_SENSOR_MODE_HFI,
}

enum McMotorType {
  MOTOR_TYPE_BLDC,
  MOTOR_TYPE_DC,
  MOTOR_TYPE_FOC,
  MOTOR_TYPE_GPD,
}

enum McFocCcDecouplingMode {
  FOC_CC_DECOUPLING_DISABLED,
  FOC_CC_DECOUPLING_CROSS,
  FOC_CC_DECOUPLING_BEMF,
  FOC_CC_DECOUPLING_CROSS_BEMF,
}

enum McFocObserverType {
  FOC_OBSERVER_ORTEGA_ORIGINAL,
  FOC_OBSERVER_ORTEGA_ITERATIVE,
}

enum McFocHfiSamples {
  HFI_SAMPLES_8,
  HFI_SAMPLES_16,
  HFI_SAMPLES_32,
}

enum McSensorPortMode {
  SENSOR_PORT_MODE_HALL,
  SENSOR_PORT_MODE_ABI,
  SENSOR_PORT_MODE_AS5047_SPI,
  SENSOR_PORT_MODE_AD2S1205,
  SENSOR_PORT_MODE_SINCOS,
  SENSOR_PORT_MODE_TS5700N8501,
  SENSOR_PORT_MODE_TS5700N8501_MULTITURN
}

enum McDrv8301OcMode {
  DRV8301_OC_LIMIT,
  DRV8301_OC_LATCH_SHUTDOWN,
  DRV8301_OC_REPORT_ONLY,
  DRV8301_OC_DISABLED,
}

enum McOutAuxMode {
  OUT_AUX_MODE_OFF,
  OUT_AUX_MODE_ON_AFTER_2S,
  OUT_AUX_MODE_ON_AFTER_5S,
  OUT_AUX_MODE_ON_AFTER_10S,
  OUT_AUX_MODE_UNUSED,
}

enum McTempSensorType {
  TEMP_SENSOR_NTC_10K_25C,
  TEMP_SENSOR_PTC_1K_100C,
  TEMP_SENSOR_KTY83_122,
}

enum McBatteryType {
  BATTERY_TYPE_LIION_3_0__4_2,
  BATTERY_TYPE_LIIRON_2_6__3_6,
  BATTERY_TYPE_LEAD_ACID,
}

enum BmsType {
  BMS_TYPE_NONE,
  BMS_TYPE_VESC,
}

class BmsConfig {
  BmsType type;
  double tLimitStart;
  double tLimitEnd;
  double socLimitStart;
  double socLimitEnd;
}

class MotorConfig {
  static final int MCCONF_SIGNATURE = 789840453;

  int signature; // uint32
  double lCurrentMax;
  double lCurrentMin;
  double lInCurrentMax;
  double lInCurrentMin;
  double lAbsCurrentMax;
  double lMinErpm;
  double lMaxErpm;
  double lErpmStart;
  double lMaxErpmFbrake;
  double lMaxErpmFbrakeCc;
  double lMinVin;
  double lMaxVin;
  double lBatteryCutStart;
  double lBatteryCutEnd;
  bool lSlowAbsCurrent;
  double lTempFetStart;
  double lTempFetEnd;
  double lTempMotorStart;
  double lTempMotorEnd;
  double lTempAccelDec;
  double lMinDuty;
  double lMaxDuty;
  double lWattMax;
  double lWattMin;
  double lCurrentMaxScale;
  double lCurrentMinScale;
  double lDutyStart;
  double loCurrentMax;
  double loCurrentMin;
  double loInCurrentMax;
  double loInCurrentMin;
  double loCurrentMotorMaxNow;
  double loCurrentMotorMinNow;
  McPwmMode pwmMode;
  McCommMode commMode;
  McMotorType motorType;
  McSensorMode sensorMode;
  double slMinErpm;
  double slMinErpmCycleIntLimit;
  double slMaxFullbreakCurrentDirChange;
  double slCycleIntLimit;
  double slPhaseAdvanceAtBr;
  double slCycleIntRpmBr;
  double slBemfCouplingK;
  List<int> hallTable; //uint8 x 8
  double hallSlErpm;
  double focCurrentKp;
  double focCurrentKi;
  double focFSw;
  double focDtUs;
  double focEncoderOffset;
  bool focEncoderInverted;
  double focEncoderRatio;
  double focEncoderSinOffset;
  double focEncoderSinGain;
  double focEncoderCosOffset;
  double focEncoderCosGain;
  double focEncoderSincosFilterConstant;
  double focMotorL;
  double focMotorLdLqDiff;
  double focMotorR;
  double focMotorFluxLinkage;
  double focObserverGain;
  double focObserverGainSlow;
  double focPllKp;
  double focPllKi;
  double focDutyDowmrampKp;
  double focDutyDowmrampKi;
  double focOpenloopRpm;
  double focOpenloopRpmLow;
  double focSlOpenloopHyst;
  double focSlOpenloopTime;
  double focSlOpenloopTimeLock;
  double focSlOpenloopTimeRamp;
  McFocSensorMode focSensorMode;
  List<int> focHallTable; // uint8 x 8
  double focHallInterpErpm;
  double focSlErpm;
  bool focSampleV0V7;
  bool focSampleHighCurrent;
  double focSatComp;
  bool focTempComp;
  double focTempCompBaseTemp;
  double focCurrentFilterConst;
  McFocCcDecouplingMode focCcDecoupling;
  McFocObserverType focObserverType;
  double focHfiVoltageStart;
  double focHfiVoltageRun;
  double focHfiVoltageMax;
  double focSlErpmHfi;
  int focHfiStartSamples; //unit16
  double focHfiObsOvrSec;
  McFocHfiSamples focHfiSamples;
  int gpdBufferNotifyLeft;
  int gpdBufferInterpol;
  double gpdCurrentFilterConst;
  double gpdCurrentKp;
  double gpdCurrentKi;
  double sPidKp;
  double sPidKi;
  double sPidKd;
  double sPidKdFilter;
  double sPidMinErpm;
  bool sPidAllowBraking;
  double sPidRampErpmsS;
  double pPidKp;
  double pPidKi;
  double pPidKd;
  double pPidKdFilter;
  double pPidAngDiv;
  double ccStartupBoostDuty;
  double ccMinCurrent;
  double ccGain;
  double ccRampStepMax;
  int mFaultStopTimeMs; // int32
  double mDutyRampStep;
  double mCurrentBackoffGain;
  int mEncoderCounts; // uint32
  McSensorPortMode mSensorPortMode;
  bool mInvertDirection;
  McDrv8301OcMode mDrv8301OcMode;
  int mDrv8301OcAdj;
  double mBldcFSswMin;
  double mBldcFSwMax;
  double mDcFSw;
  double mNtcMotorBeta;
  McOutAuxMode mOutAuxMode;
  McTempSensorType mMotorTempSensType;
  double mPtcMotorCoeff;
  int mHallExtraSamples;
  int siMotorPoles; // uint8
  double siGearRatio;
  double siWheelDiameter;
  McBatteryType siBatteryType;
  int siBatteryCells;
  double siBatteryAh;
  BmsConfig bms;
  int crc; // unit16

  MotorConfig(List<int> data) {

    // Check signature
    signature = ParseUtil.takeInt32(data);
    if (signature != MCCONF_SIGNATURE) {
      throw Exception("Invalid MC Conf signature $signature");
    } else {
      print("Valid MC Conf $signature");
    }

    pwmMode = McPwmMode.values[ParseUtil.takeInt8(data)];
    commMode = McCommMode.values[ParseUtil.takeInt8(data)];
    motorType = McMotorType.values[ParseUtil.takeInt8(data)];
    sensorMode = McSensorMode.values[ParseUtil.takeInt8(data)];
    lCurrentMax = ParseUtil.takeDouble(data);
    lCurrentMin = ParseUtil.takeDouble(data);
    lInCurrentMax = ParseUtil.takeDouble(data);
    lInCurrentMin = ParseUtil.takeDouble(data);
    lAbsCurrentMax = ParseUtil.takeDouble(data);
    lMinErpm = ParseUtil.takeDouble(data);
    lMaxErpm = ParseUtil.takeDouble(data);
    lErpmStart = ParseUtil.takeDouble(data);
    lMaxErpmFbrake = ParseUtil.takeDouble(data);
    lMaxErpmFbrakeCc = ParseUtil.takeDouble(data);
    lMinVin = ParseUtil.takeDouble(data);
    lMaxVin = ParseUtil.takeDouble(data);
    lBatteryCutStart = ParseUtil.takeDouble(data);
    lBatteryCutEnd = ParseUtil.takeDouble(data);
    lSlowAbsCurrent = ParseUtil.takeBoolean(data);
    lTempFetStart = ParseUtil.takeDouble(data);
    lTempFetEnd = ParseUtil.takeDouble(data);
    lTempMotorStart = ParseUtil.takeDouble(data);
    lTempMotorEnd = ParseUtil.takeDouble(data);
    lTempAccelDec = ParseUtil.takeDouble(data);
    lMinDuty = ParseUtil.takeDouble(data);
    lMaxDuty = ParseUtil.takeDouble(data);
    lWattMax = ParseUtil.takeDouble(data);
    lWattMin = ParseUtil.takeDouble(data);
    lCurrentMaxScale = ParseUtil.takeDouble(data);
    lCurrentMinScale = ParseUtil.takeDouble(data);
    lDutyStart = ParseUtil.takeDouble(data);
    slMinErpm = ParseUtil.takeDouble(data);
    slMinErpmCycleIntLimit = ParseUtil.takeDouble(data);
    slMaxFullbreakCurrentDirChange = ParseUtil.takeDouble(data);
    slCycleIntLimit = ParseUtil.takeDouble(data);
    slPhaseAdvanceAtBr = ParseUtil.takeDouble(data);
    slCycleIntRpmBr = ParseUtil.takeDouble(data);
    slBemfCouplingK = ParseUtil.takeDouble(data);
    hallTable = ParseUtil.takeInt8List(data, 8); // Just pretend its uint, seems like qt app seems to do it this way
    hallSlErpm = ParseUtil.takeDouble(data);
    focCurrentKp = ParseUtil.takeDouble(data);
    focCurrentKi = ParseUtil.takeDouble(data);
    focFSw = ParseUtil.takeDouble(data);
    focDtUs = ParseUtil.takeDouble(data);
    focEncoderInverted = ParseUtil.takeBoolean(data);
    focEncoderOffset = ParseUtil.takeDouble(data);
    focEncoderRatio = ParseUtil.takeDouble(data);
    focEncoderSinGain = ParseUtil.takeDouble(data);
    focEncoderCosGain = ParseUtil.takeDouble(data);
    focEncoderSinOffset = ParseUtil.takeDouble(data);
    focEncoderCosOffset = ParseUtil.takeDouble(data);
    focEncoderSincosFilterConstant = ParseUtil.takeDouble(data);
    focSensorMode = McFocSensorMode.values[ParseUtil.takeInt8(data)];
    focPllKp = ParseUtil.takeDouble(data);
    focPllKi = ParseUtil.takeDouble(data);
    focMotorL = ParseUtil.takeDouble(data);
    focMotorLdLqDiff = ParseUtil.takeDouble(data);
    focMotorR = ParseUtil.takeDouble(data);
    focMotorFluxLinkage = ParseUtil.takeDouble(data);
    focObserverGain = ParseUtil.takeDouble(data);
    focObserverGainSlow = ParseUtil.takeDouble(data);
    focDutyDowmrampKp = ParseUtil.takeDouble(data);
    focDutyDowmrampKi = ParseUtil.takeDouble(data);
    focOpenloopRpm = ParseUtil.takeDouble(data);
    focOpenloopRpmLow = ParseUtil.takeDouble2Byte(data, 1000);
    focSlOpenloopHyst = ParseUtil.takeDouble2Byte(data, 100);
    focSlOpenloopTimeLock = ParseUtil.takeDouble2Byte(data, 100);
    focSlOpenloopTimeRamp = ParseUtil.takeDouble2Byte(data, 100);
    focSlOpenloopTime = ParseUtil.takeDouble2Byte(data, 100);
    focHallTable = ParseUtil.takeInt8List(data, 8);
    focHallInterpErpm = ParseUtil.takeDouble(data);
    focSlErpm = ParseUtil.takeDouble(data);
    focSampleV0V7 = ParseUtil.takeBoolean(data);
    focSampleHighCurrent = ParseUtil.takeBoolean(data);
    focSatComp = ParseUtil.takeDouble2Byte(data, 1000);
    focTempComp = ParseUtil.takeBoolean(data);
    focTempCompBaseTemp = ParseUtil.takeDouble2Byte(data, 100);
    focCurrentFilterConst = ParseUtil.takeDouble(data);
    focCcDecoupling = McFocCcDecouplingMode.values[ParseUtil.takeInt8(data)];
    focObserverType = McFocObserverType.values[ParseUtil.takeInt8(data)];
    focHfiVoltageStart = ParseUtil.takeDouble(data);
    focHfiVoltageRun = ParseUtil.takeDouble(data);
    focHfiVoltageMax = ParseUtil.takeDouble(data);
    focSlErpmHfi = ParseUtil.takeDouble(data);
    focHfiStartSamples = ParseUtil.takeInt16(data);
    focHfiObsOvrSec = ParseUtil.takeDouble(data);
    focHfiSamples = McFocHfiSamples.values[ParseUtil.takeInt8(data)];
    gpdBufferNotifyLeft = ParseUtil.takeInt16s(data);
    gpdBufferInterpol = ParseUtil.takeInt16s(data);
    gpdCurrentFilterConst = ParseUtil.takeDouble(data);
    gpdCurrentKp = ParseUtil.takeDouble(data);
    gpdCurrentKi = ParseUtil.takeDouble(data);
    sPidKp = ParseUtil.takeDouble(data);
    sPidKi = ParseUtil.takeDouble(data);
    sPidKd = ParseUtil.takeDouble(data);
    sPidKdFilter = ParseUtil.takeDouble(data);
    sPidMinErpm = ParseUtil.takeDouble(data);
    sPidAllowBraking = ParseUtil.takeBoolean(data);
    sPidRampErpmsS = ParseUtil.takeDouble(data);
    pPidKp = ParseUtil.takeDouble(data);
    pPidKi = ParseUtil.takeDouble(data);
    pPidKd = ParseUtil.takeDouble(data);
    pPidKdFilter = ParseUtil.takeDouble(data);
    pPidAngDiv = ParseUtil.takeDouble(data);
    ccStartupBoostDuty = ParseUtil.takeDouble(data);
    ccMinCurrent = ParseUtil.takeDouble(data);
    ccGain = ParseUtil.takeDouble(data);
    ccRampStepMax = ParseUtil.takeDouble(data);
    mFaultStopTimeMs = ParseUtil.takeInt32s(data);
    mDutyRampStep = ParseUtil.takeDouble(data);
    mCurrentBackoffGain = ParseUtil.takeDouble(data);
    mEncoderCounts = ParseUtil.takeInt32(data);
    mSensorPortMode = McSensorPortMode.values[ParseUtil.takeInt8(data)];
    mInvertDirection = ParseUtil.takeBoolean(data);
    mDrv8301OcMode = McDrv8301OcMode.values[ParseUtil.takeInt8(data)];
    mDrv8301OcAdj = ParseUtil.takeInt8(data);
    mBldcFSswMin = ParseUtil.takeDouble(data);
    mBldcFSwMax = ParseUtil.takeDouble(data);
    mDcFSw = ParseUtil.takeDouble(data);
    mNtcMotorBeta = ParseUtil.takeDouble(data);
    mOutAuxMode = McOutAuxMode.values[ParseUtil.takeInt8(data)];
    mMotorTempSensType = McTempSensorType.values[ParseUtil.takeInt8(data)];
    mPtcMotorCoeff = ParseUtil.takeDouble(data);
    mHallExtraSamples = ParseUtil.takeInt8(data);
    siMotorPoles = ParseUtil.takeInt8(data);
    siGearRatio = ParseUtil.takeDouble(data);
    siWheelDiameter = ParseUtil.takeDouble(data);
    siBatteryType = McBatteryType.values[ParseUtil.takeInt8(data)];
    siBatteryCells = ParseUtil.takeInt8(data);
    siBatteryAh = ParseUtil.takeDouble(data);
    bms = BmsConfig();
    bms.type = BmsType.values[ParseUtil.takeInt8(data)];
    bms.tLimitStart = ParseUtil.takeDouble2Byte(data, 100);
    bms.tLimitEnd = ParseUtil.takeDouble2Byte(data, 100);
    bms.socLimitStart = ParseUtil.takeDouble2Byte(data, 1000);
    bms.socLimitEnd = ParseUtil.takeDouble2Byte(data, 1000);

    print("Parsed Motor Config, MaxCurrent = $lCurrentMax, MinCurrent = $lCurrentMin, hall table = $hallTable");
  }

  List<int> serialize(){
    List<int> serialized = List<int>();

    ParseUtil.putInt32(serialized, signature);
    ParseUtil.putInt8(serialized, pwmMode.index);
    ParseUtil.putInt8(serialized, commMode.index);
    ParseUtil.putInt8(serialized, motorType.index);
    ParseUtil.putInt8(serialized, sensorMode.index);
    ParseUtil.putDouble(serialized, lCurrentMax);
    ParseUtil.putDouble(serialized, lCurrentMin);
    ParseUtil.putDouble(serialized, lInCurrentMax);
    ParseUtil.putDouble(serialized, lInCurrentMin);
    ParseUtil.putDouble(serialized, lAbsCurrentMax);
    ParseUtil.putDouble(serialized, lMinErpm);
    ParseUtil.putDouble(serialized, lMaxErpm);
    ParseUtil.putDouble(serialized, lErpmStart);
    ParseUtil.putDouble(serialized, lMaxErpmFbrake);
    ParseUtil.putDouble(serialized, lMaxErpmFbrakeCc);
    ParseUtil.putDouble(serialized, lMinVin);
    ParseUtil.putDouble(serialized, lMaxVin);
    ParseUtil.putDouble(serialized, lBatteryCutStart);
    ParseUtil.putDouble(serialized, lBatteryCutEnd);
    ParseUtil.putBoolean(serialized, lSlowAbsCurrent);
    ParseUtil.putDouble(serialized, lTempFetStart);
    ParseUtil.putDouble(serialized, lTempFetEnd);
    ParseUtil.putDouble(serialized, lTempMotorStart);
    ParseUtil.putDouble(serialized, lTempMotorEnd);
    ParseUtil.putDouble(serialized, lTempAccelDec);
    ParseUtil.putDouble(serialized, lMinDuty);
    ParseUtil.putDouble(serialized, lMaxDuty);
    ParseUtil.putDouble(serialized, lWattMax);
    ParseUtil.putDouble(serialized, lWattMin);
    ParseUtil.putDouble(serialized, lCurrentMaxScale);
    ParseUtil.putDouble(serialized, lCurrentMinScale);
    ParseUtil.putDouble(serialized, lDutyStart);
    ParseUtil.putDouble(serialized, slMinErpm);
    ParseUtil.putDouble(serialized, slMinErpmCycleIntLimit);
    ParseUtil.putDouble(serialized, slMaxFullbreakCurrentDirChange);
    ParseUtil.putDouble(serialized, slCycleIntLimit);
    ParseUtil.putDouble(serialized, slPhaseAdvanceAtBr);
    ParseUtil.putDouble(serialized, slCycleIntRpmBr);
    ParseUtil.putDouble(serialized, slBemfCouplingK);
    ParseUtil.putInt8List(serialized, hallTable); // Just pretend its uint, seems like qt app seems to do it this way
    ParseUtil.putDouble(serialized, hallSlErpm);
    ParseUtil.putDouble(serialized, focCurrentKp);
    ParseUtil.putDouble(serialized, focCurrentKi);
    ParseUtil.putDouble(serialized, focFSw);
    ParseUtil.putDouble(serialized, focDtUs);
    ParseUtil.putBoolean(serialized, focEncoderInverted);
    ParseUtil.putDouble(serialized, focEncoderOffset);
    ParseUtil.putDouble(serialized, focEncoderRatio);
    ParseUtil.putDouble(serialized, focEncoderSinGain);
    ParseUtil.putDouble(serialized, focEncoderCosGain);
    ParseUtil.putDouble(serialized, focEncoderSinOffset);
    ParseUtil.putDouble(serialized, focEncoderCosOffset);
    ParseUtil.putDouble(serialized, focEncoderSincosFilterConstant);
    ParseUtil.putInt8(serialized, focSensorMode.index);
    ParseUtil.putDouble(serialized, focPllKp);
    ParseUtil.putDouble(serialized, focPllKi);
    ParseUtil.putDouble(serialized, focMotorL);
    ParseUtil.putDouble(serialized, focMotorLdLqDiff);
    ParseUtil.putDouble(serialized, focMotorR);
    ParseUtil.putDouble(serialized, focMotorFluxLinkage);
    ParseUtil.putDouble(serialized, focObserverGain);
    ParseUtil.putDouble(serialized, focObserverGainSlow);
    ParseUtil.putDouble(serialized, focDutyDowmrampKp);
    ParseUtil.putDouble(serialized, focDutyDowmrampKi);
    ParseUtil.putDouble(serialized, focOpenloopRpm);
    ParseUtil.putDouble2Byte(serialized, focOpenloopRpmLow, 1000);
    ParseUtil.putDouble2Byte(serialized, focSlOpenloopHyst, 100);
    ParseUtil.putDouble2Byte(serialized, focSlOpenloopTimeLock, 100);
    ParseUtil.putDouble2Byte(serialized, focSlOpenloopTimeRamp, 100);
    ParseUtil.putDouble2Byte(serialized, focSlOpenloopTime, 100);
    ParseUtil.putInt8List(serialized, focHallTable);
    ParseUtil.putDouble(serialized, focHallInterpErpm);
    ParseUtil.putDouble(serialized, focSlErpm);
    ParseUtil.putBoolean(serialized, focSampleV0V7);
    ParseUtil.putBoolean(serialized, focSampleHighCurrent);
    ParseUtil.putDouble2Byte(serialized, focSatComp, 1000);
    ParseUtil.putBoolean(serialized, focTempComp);
    ParseUtil.putDouble2Byte(serialized, focTempCompBaseTemp, 100);
    ParseUtil.putDouble(serialized, focCurrentFilterConst);
    ParseUtil.putInt8(serialized, focCcDecoupling.index);
    ParseUtil.putInt8(serialized, focObserverType.index);
    ParseUtil.putDouble(serialized, focHfiVoltageStart);
    ParseUtil.putDouble(serialized, focHfiVoltageRun);
    ParseUtil.putDouble(serialized, focHfiVoltageMax);
    ParseUtil.putDouble(serialized, focSlErpmHfi);
    ParseUtil.putInt16(serialized, focHfiStartSamples);
    ParseUtil.putDouble(serialized, focHfiObsOvrSec);
    ParseUtil.putInt8(serialized, focHfiSamples.index);
    ParseUtil.putInt16s(serialized, gpdBufferNotifyLeft);
    ParseUtil.putInt16s(serialized, gpdBufferInterpol);
    ParseUtil.putDouble(serialized, gpdCurrentFilterConst);
    ParseUtil.putDouble(serialized, gpdCurrentKp);
    ParseUtil.putDouble(serialized, gpdCurrentKi);
    ParseUtil.putDouble(serialized, sPidKp);
    ParseUtil.putDouble(serialized, sPidKi);
    ParseUtil.putDouble(serialized, sPidKd);
    ParseUtil.putDouble(serialized, sPidKdFilter);
    ParseUtil.putDouble(serialized, sPidMinErpm);
    ParseUtil.putBoolean(serialized, sPidAllowBraking);
    ParseUtil.putDouble(serialized, sPidRampErpmsS);
    ParseUtil.putDouble(serialized, pPidKp);
    ParseUtil.putDouble(serialized, pPidKi);
    ParseUtil.putDouble(serialized, pPidKd);
    ParseUtil.putDouble(serialized, pPidKdFilter);
    ParseUtil.putDouble(serialized, pPidAngDiv);
    ParseUtil.putDouble(serialized, ccStartupBoostDuty);
    ParseUtil.putDouble(serialized, ccMinCurrent);
    ParseUtil.putDouble(serialized, ccGain);
    ParseUtil.putDouble(serialized, ccRampStepMax);
    ParseUtil.putInt32s(serialized, mFaultStopTimeMs);
    ParseUtil.putDouble(serialized, mDutyRampStep);
    ParseUtil.putDouble(serialized, mCurrentBackoffGain);
    ParseUtil.putInt32(serialized, mEncoderCounts);
    ParseUtil.putInt8(serialized, mSensorPortMode.index);
    ParseUtil.putBoolean(serialized, mInvertDirection);
    ParseUtil.putInt8(serialized, mDrv8301OcMode.index);
    ParseUtil.putInt8(serialized, mDrv8301OcAdj);
    ParseUtil.putDouble(serialized, mBldcFSswMin);
    ParseUtil.putDouble(serialized, mBldcFSwMax);
    ParseUtil.putDouble(serialized, mDcFSw);
    ParseUtil.putDouble(serialized, mNtcMotorBeta);
    ParseUtil.putInt8(serialized, mOutAuxMode.index);
    ParseUtil.putInt8(serialized, mMotorTempSensType.index);
    ParseUtil.putDouble(serialized, mPtcMotorCoeff);
    ParseUtil.putInt8(serialized, mHallExtraSamples);
    ParseUtil.putInt8(serialized, siMotorPoles);
    ParseUtil.putDouble(serialized, siGearRatio);
    ParseUtil.putDouble(serialized, siWheelDiameter);
    ParseUtil.putInt8(serialized, siBatteryType.index);
    ParseUtil.putInt8(serialized, siBatteryCells);
    ParseUtil.putDouble(serialized, siBatteryAh);
    ParseUtil.putInt8(serialized, bms.type.index);
    ParseUtil.putDouble2Byte(serialized, bms.tLimitStart, 100);
    ParseUtil.putDouble2Byte(serialized, bms.tLimitEnd, 100);
    ParseUtil.putDouble2Byte(serialized, bms.socLimitStart, 1000);
    ParseUtil.putDouble2Byte(serialized, bms.socLimitEnd, 1000);

    return serialized;
  }
}
