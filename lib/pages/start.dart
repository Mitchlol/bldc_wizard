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

  Widget getBody(buildContext, call, isLoading, FWInfo fwInfo) {
    if (isLoading) {
      return Container();
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              fwInfo.getName(),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "ID: ${fwInfo.getUuid()}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getFirmwareStatusWidget(fwInfo),
                ],
              ),
            ),
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Firmware: ${info.getVersion()}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "ID: ${info.getUuid()}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
