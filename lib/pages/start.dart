import 'package:bldc_wizard/esc/bldc.dart';
import 'package:bldc_wizard/esc/ble_uart.dart';
import 'package:bldc_wizard/esc/models/fw_info.dart';
import 'package:bldc_wizard/widgets/call_stream_builder.dart';
import 'package:bldc_wizard/widgets/connection_state_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../model.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return CallStreamBuilder<FWInfo>(
        call: Provider.of<Model>(context, listen: false).bldc.requestFirmwareInfo,
        stream: Provider.of<Model>(context).bldc.getStream<FWInfo>(),
        autoLoad: true,
        builder: (buildContext, call, isLoading, FWInfo fwInfo) {
          return Scaffold(
              appBar: AppBar(title: Text("BLDC Wizard"), actions: [ConnectionStateIndicator()]),
              floatingActionButton: FloatingActionButton(
                child: !isLoading
                    ? Icon(
                        Icons.refresh,
                      )
                    : CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                onPressed: !isLoading ? call : null,
              ),
              body: getBody(buildContext, call, isLoading, fwInfo));
        });
  }

  Widget getBody(BuildContext buildContext, Function call, bool isLoading, FWInfo fwInfo) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            getCard(buildContext, call, isLoading, fwInfo),
            getButtons(buildContext, call, isLoading, fwInfo),
            RaisedButton(
              onPressed: () => Provider.of<Model>(context, listen: false).bldc.requestGetValues(),
              child: Text("Call get values"),
            ),
            RaisedButton(
              onPressed: () => Provider.of<Model>(context, listen: false).bldc.requestPingCan(),
              child: Text("Call ping can"),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCard(BuildContext buildContext, Function call, bool isLoading, FWInfo fwInfo) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        isLoading? "Loading..." : fwInfo == null? "Unknown Firmware" : fwInfo.getName(),
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        isLoading? "" : fwInfo == null? "Is device a compatible ESC" : "ID: ${fwInfo.getUuid()}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isLoading? "Loading..." : fwInfo == null? "Unable to parse FW Info, is device running Benjamin Vedder's BLDC Firmware?" : "Firmware: ${fwInfo.getVersion()}",
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getButtons(BuildContext buildContext, Function call, bool isLoading, FWInfo fwInfo) {
    return Expanded(
      child: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('Set Power Output'),
              subtitle: Text('Adjust motor current output values. This will determine the maximum torque for your vehicle.'),
              trailing: Icon(Icons.bolt),
              onTap: isLoading? null : fwInfo == null ? null : !fwInfo.isSupported()? null : () {
                Provider.of<Model>(context, listen: false).bldc.requestMotorConfig();
              },
            ),
          )
        ],
      ),
    );

  }
}
