import 'package:bldc_wizard/bldc.dart';
import 'package:bldc_wizard/ble_uart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLDC Wizard"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome to the BLDC Wizard. Press scan blow to search for your ESC, this will require permissons.",
          ),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
                stream: Provider.of<FlutterBlue>(context).scanResults,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      var data = snapshot.data.where((result) => result.advertisementData.connectable && result.device.name.isNotEmpty).toList();
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: data.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text('Name: ${data[index].device.name}'),
                              subtitle: Text('Address: ${data[index].device.id.id}'),
                              onTap: () {
                                connect(context, data[index].device);
                              },
                            ),
                          );
                        },
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
                              scan(context);
                            },
                      child: snapshot.data ? CircularProgressIndicator() : Text("Scan"),
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

  void scan(BuildContext context) {
    Provider.of<FlutterBlue>(context, listen: false).startScan(timeout: Duration(seconds: 5));
  }

  void connect(BuildContext context, BluetoothDevice device) {
    // device.connect().then((value) {
    //   print('Ayyyyyy we connected');
    //   device.discoverServices().then((value) {
    //     device.services.forEach((List<BluetoothService> serviceList) {
    //       for(var service in serviceList){
    //         print("Service: ${service.uuid}");
    //         for(var characteristic in service.characteristics){
    //           print("__Characteristic: ${characteristic.uuid}");
    //         }
    //
    //       }
    //
    //     });
    //   });
    // });

    BLEUart bleUart = BLEUart(device);
    bleUart.isIntialized.then((value) {
      print("BLEUart Initialized");

      BLDC bldc = BLDC(bleUart);
      bldc.sendIt(null).then((value) {
        print("Write Success! $value");
      }, onError: (value) {
        print("Write Fail! $value");
      });
    });
  }
}
