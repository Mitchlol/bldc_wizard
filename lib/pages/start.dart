import 'package:bldc_wizard/bldc.dart';
import 'package:bldc_wizard/ble_uart.dart';
import 'package:bldc_wizard/models/fw_info.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Somthin somethin.",
          ),
          Expanded(
            child: StreamBuilder<dynamic>(
                stream: Provider.of<Model>(context).bldc.responseStream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      if (snapshot.data is FWInfo) {
                        var data = snapshot.data as FWInfo;
                        return Container(
                          color: Colors.amber,
                          child: Column(
                            children: [
                              Text("FW Verison = ${data.getVersion()} "),
                              Text("FW name = ${data.getName()}"),
                              Text("FW UUID = ${data.getUuid()}"),
                              Text("FW Paired = ${data.isPaired()}"),
                            ],
                          ),
                        );
                      }
                      return Container(
                        height: 100,
                        width: 200,
                        color: Colors.green,
                      );
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                    default:
                      return Container();
                  }
                }),
          ),
          StreamBuilder<Object>(
              stream: Provider.of<FlutterBlue>(context).isScanning,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    return RaisedButton(
                      onPressed: snapshot.data
                          ? null
                          : () {
                              Provider.of<Model>(context, listen: false).bldc.requestFirmwareInfo();
                            },
                      child: snapshot.data ? CircularProgressIndicator() : Text("Refresh"),
                    );
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                  default:
                    return Container();
                }
              })
        ],
      ),
    );
  }
}
