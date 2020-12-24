import 'package:bldc_wizard/esc/esc_state.dart';
import 'package:bldc_wizard/esc/models/can_ping.dart';
import 'package:bldc_wizard/esc/models/fw_info.dart';
import 'package:bldc_wizard/esc/models/motor_config.dart';
import 'package:bldc_wizard/esc/models/motor_config_set.dart';
import 'package:bldc_wizard/pages/start.dart';
import 'package:bldc_wizard/widgets/connection_state_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../model.dart';

class ConfigWriterPage extends StatefulWidget {
  ConfigWriterPage({Key key}) : super(key: key);

  @override
  _ConfigWriterState createState() => _ConfigWriterState();
}

enum _WriteProgressState {
  MOTOR_WRITE,
  MOTOR_READ,
  MOTOR_VERIFY,
  DONE,
}

class _ESCWriteState {
  int _id;
  _WriteProgressState progressState = _WriteProgressState.DONE;
  bool motorWrite;
  bool motorRead;
  bool motorVerified;
  MotorConfig readMotorConfig;

  _ESCWriteState(int canId) {
    _id = canId;
  }

  int getCanId() {
    return _id;
  }
}

class _ConfigWriterState extends State<ConfigWriterPage> {
  bool initflag = true;
  List<_ESCWriteState> escStates = List();

  @override
  Widget build(BuildContext context) {
    // Load default value
    if (initflag) {
      initflag = false;
      writeMotorConfigs(context);
    }
    return Scaffold(
      appBar: AppBar(title: Text("Writing Config"), actions: [ConnectionStateIndicator()]),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext buildContext) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: escStates.length,
              itemBuilder: (BuildContext context, int index) {
                return getWriteStateDisplay(context, escStates[index]);
              },
            ),
          ),
          getButton(context)
        ],
      ),
    );
  }

  Widget getWriteStateDisplay(BuildContext buildContext, _ESCWriteState state) {
    Model model = Provider.of<Model>(context, listen: false);
    ESCState escState = model.devices[state.getCanId()];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "${escState.fwInfo.name}",
              style: TextStyle(
                fontSize: 35,
                color: Colors.blue,
              ),
            ),
            Text("${escState.fwInfo.uuid}"),
            Divider(),
            Row(
              children: [
                Text("Write"),
                Spacer(),
                if (state.progressState == _WriteProgressState.MOTOR_WRITE) CircularProgressIndicator(),
                if (state.progressState != _WriteProgressState.MOTOR_WRITE)
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: state.motorWrite == null
                        ? Colors.grey
                        : state.motorWrite == true
                            ? Colors.green
                            : Colors.red,
                  )
              ],
            ),
            Row(
              children: [
                Text("Read"),
                Spacer(),
                if (state.progressState == _WriteProgressState.MOTOR_READ) CircularProgressIndicator(),
                if (state.progressState != _WriteProgressState.MOTOR_READ)
                  Icon(
                    Icons.cloud_download_outlined,
                    color: state.motorRead == null
                        ? Colors.grey
                        : state.motorRead == true
                            ? Colors.green
                            : Colors.red,
                  )
              ],
            ),
            Row(
              children: [
                Text("Verify"),
                Spacer(),
                if (state.progressState == _WriteProgressState.MOTOR_VERIFY) CircularProgressIndicator(),
                if (state.progressState != _WriteProgressState.MOTOR_VERIFY)
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    color: state.motorVerified == null
                        ? Colors.grey
                        : state.motorVerified == true
                            ? Colors.green
                            : Colors.red,
                  )
              ],
            ),
          ],
        ),
      ),
    );
    return Text("${state.getCanId()} ${state.progressState}");
  }

  Widget getButton(BuildContext buildContext) {
    bool isLoading  = false;
    bool isError  = false;
    for(_ESCWriteState state in escStates){
      if(state.progressState != _WriteProgressState.DONE){
        isLoading = true;
      }
      if(state.motorWrite == false || state.motorRead == false || state.motorVerified == false ){
        isError = true;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  if(isError){
                    writeMotorConfigs(context);
                  }else{
                    Navigator.of(context).popUntil(
                        ModalRoute.withName((StartPage).toString())
                    );
                  }
                },
          child: Text(
            isError ? "Retry" : "Thanks Mitch <3",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future writeMotorConfigs(BuildContext context) async {
    Model model = Provider.of<Model>(context, listen: false);

    setState(() {
      escStates = List();
      for (int canId in model.devices.keys) {
        escStates.add(_ESCWriteState(canId));
      }
    });

    for (_ESCWriteState state in escStates) {
      MotorConfig config = model.devices[state.getCanId()].motorConfig;
      //Write config
      setState(() {
        state.progressState = _WriteProgressState.MOTOR_WRITE;
      });
      try {
        if (state.getCanId() == -1) {
          await model.bldc.writeMotorConfig(config);
        } else {
          await model.bldc.writeMotorConfig(config, canId: state.getCanId());
        }
        await model.bldc.getStream<MotorConfigSet>().first.timeout(Duration(seconds: 5));
        setState(() {
          state.motorWrite = true;
        });
      } catch (e) {
        setState(() {
          state.motorWrite = false;
          state.progressState = _WriteProgressState.DONE;
        });
        return;
      }

      // Read Config
      setState(() {
        state.progressState = _WriteProgressState.MOTOR_READ;
      });
      try {
        if (state.getCanId() == -1) {
          model.bldc.requestMotorConfig();
        } else {
          model.bldc.requestMotorConfig(canId: state.getCanId());
        }
        state.readMotorConfig = await model.bldc.getStream<MotorConfig>().first.timeout(Duration(seconds: 5));
        setState(() {
          state.motorRead = true;
        });
      } catch (e) {
        setState(() {
          state.motorRead = false;
          state.progressState = _WriteProgressState.DONE;
        });
        return;
      }

      // Verify Motor Config Was Set
      setState(() {
        state.progressState = _WriteProgressState.MOTOR_VERIFY;
      });
      if(state.readMotorConfig.isSameAs(config)){
        setState(() {
          state.motorVerified = true;
        });
      }else{
        setState(() {
          state.motorVerified = false;
          state.progressState = _WriteProgressState.DONE;
        });
        return;
      }

      //Done
      setState(() {
        state.progressState = _WriteProgressState.DONE;
      });
    }
  }
}

class PrimitiveWrapper<T> {
  T value;

  PrimitiveWrapper(this.value);
}
