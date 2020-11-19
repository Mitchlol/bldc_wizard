import 'package:bldc_wizard/bldc.dart';
import 'package:bldc_wizard/ble_uart.dart';
import 'package:bldc_wizard/models/fw_info.dart';
import 'package:bldc_wizard/widgets/call_stream_builder.dart';
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
        actions: [getBluetoothStateIcon(context)],
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
              }),
          RaisedButton(
            onPressed: () => Provider.of<Model>(context, listen: false).bldc.requestGetValues(),
            child: Text("Call get values"),
          ),
          RaisedButton(
            onPressed: () => Provider.of<Model>(context, listen: false).bldc.uart.disconnect(),
            child: Text("Disconnect"),
          ),
          RaisedButton(
            onPressed: () {
              BLEUart bleUart = BLEUart(Provider.of<Model>(context, listen: false).bldc.uart.device);
              bleUart.isIntialized.then((value) {
                Provider.of<Model>(context, listen: false).bldc = BLDC(bleUart);
              });
            },
            child: Text("Connect"),
          ),
          CallStreamBuilder(
            call: Provider.of<Model>(context, listen: false).bldc.requestFirmwareInfo,
            stream: Provider.of<Model>(context).bldc.responseStream,
            builder: (buildContext, call, isLoading, response) {
              return Container(
                color: Colors.deepOrangeAccent,
                child: Column(
                  children: [
                    if (isLoading) CircularProgressIndicator(),
                    if (response != null)  Column(
                      children: [
                        Text("FW Verison = ${response.getVersion()} "),
                        Text("FW name = ${response.getName()}"),
                        Text("FW UUID = ${response.getUuid()}"),
                        Text("FW Paired = ${response.isPaired()}"),
                      ],
                    ),
                    RaisedButton(
                      onPressed: call,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getFirmwareStatusWidget() {}

  Widget getBluetoothStateIcon(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: Provider.of<Model>(context).bldc.state,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == BluetoothDeviceState.connected) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.bluetooth,
              color: Colors.lightGreenAccent,
            ),
          );
        } else {
          return Icon(
            Icons.bluetooth,
            color: Colors.red,
          );
        }
      },
    );
  }
}
