import 'package:bldc_wizard/bldc.dart';
import 'package:bldc_wizard/ble_uart.dart';
import 'package:bldc_wizard/pages/start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../model.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  bool hasScanned = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLDC Wizard"),
      ),
      body: StreamBuilder<Object>(
          stream: Provider.of<FlutterBlue>(context).isScanning,
          builder: (context, snapshot) {
            bool isScanning = false;
            if (snapshot.data != null && snapshot.data == true) {
              isScanning = true;
            }
            return StreamBuilder<List<ScanResult>>(
                stream: Provider.of<FlutterBlue>(context).scanResults,
                builder: (context, snapshot) {
                  List<ScanResult> scanResults = snapshot.data;
                  if(snapshot.data != null){
                    scanResults = scanResults.where((result) => result.advertisementData.connectable && result.device.name.isNotEmpty).toList();
                  }
                  return getBody(isScanning, scanResults);
                });
          }),
    );
  }

  Widget getBody(bool isScanning, List<ScanResult> scanResults) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: getAllListStates(isScanning, scanResults)),
        getButton(isScanning),
      ],
    );
  }

  Widget getAllListStates(bool isScanning, List<ScanResult> scanResults){
    if(!isScanning && (scanResults == null || hasScanned == false)){
      return getWelcome();
    }else if(!isScanning && scanResults.isEmpty){
      return getEmpty();
    }else{
      return getList(scanResults);
    }
  }

  Widget getWelcome(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome to the BLDC Wizard!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Press scan blow to search for your ESC, this may launch a permission request.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getEmpty(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "No bluetooth devices round!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "No bluetooth devices found, please make sure bluetooth is enabled, and your ESC is powered on.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getList(List<ScanResult> scanResults){
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: scanResults.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text('Name: ${scanResults[index].device.name}'),
            subtitle: Text('Address: ${scanResults[index].device.id.id}'),
            onTap: () {
              connect(context, scanResults[index].device);
            },
          ),
        );
      },
    );
  }

  Widget getButton(bool isRefreshing) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: isRefreshing
              ? null
              : () {
                  scan(context);
                },
          child: isRefreshing
              ? CircularProgressIndicator()
              : Text(
                  "Scan",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void scan(BuildContext context) {
    hasScanned = true;
    Provider.of<FlutterBlue>(context, listen: false).startScan(timeout: Duration(seconds: 5));
  }

  void connect(BuildContext context, BluetoothDevice device) {
    BLEUart bleUart = BLEUart(device);
    bleUart.isIntialized.then((value) {
      print("BLEUart Initialized");
      Provider.of<Model>(context, listen: false).bldc = BLDC(bleUart);
      Provider.of<Model>(context, listen: false).bldc.requestFirmwareInfo();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return StartPage();
        }),
      );
    });
  }
}
