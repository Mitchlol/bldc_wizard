import 'package:bldc_wizard/bldc.dart';
import 'package:bldc_wizard/ble_uart.dart';
import 'package:bldc_wizard/models/fw_info.dart';
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
    return CallStreamBuilder(
        call: Provider.of<Model>(context, listen: false).bldc.requestFirmwareInfo,
        stream: Provider.of<Model>(context).bldc.responseStream,
        autoLoad: true,
        builder: rootBuilder);
  }

  Widget rootBuilder(buildContext, call, isLoading, response) {
    return Scaffold(
      appBar: AppBar(title: Text("Firmware Status"), actions: [ConnectionStateIndicator()]),
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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                color: Colors.red,
                child: Column(
                  children: [
                    if (isLoading) CircularProgressIndicator(),
                    if (response != null) getFirmwareStatusWidget(response),
                    if (!isLoading && response == null) Text("Error loading FW Info, is this device a compatible ESC?"),
                    RaisedButton(
                      child: Text("Refresh"),
                      onPressed: call,
                    ),
                  ],
                )),
            RaisedButton(
              onPressed: () => Provider.of<Model>(context, listen: false).bldc.requestGetValues(),
              child: Text("Call get values"),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFirmwareStatusWidget(FWInfo info) {
    return Column(
      children: [
        Text("FW Verison = ${info.getVersion()} "),
        Text("FW name = ${info.getName()}"),
        Text("FW UUID = ${info.getUuid()}"),
        Text("FW Paired = ${info.isPaired()}"),
      ],
    );
  }
}
