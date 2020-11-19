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

  final GlobalKey<State> _key = GlobalKey<State>();

  bool hasScanned = false;
  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _key,
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
    if(isConnecting){
      return getConnecting();
    }else if(!isScanning && (scanResults == null || hasScanned == false)){
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
              "No bluetooth devices found!",
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
              "Please make sure bluetooth is enabled, and your ESC is powered on.",
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
            trailing: Icon(Icons.bluetooth
            ),
            onTap: () {
              connect(scanResults[index].device);
            },
          ),
        );
      },
    );
  }

  Widget getConnecting(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Connecting...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget getButton(bool isRefreshing) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: isRefreshing || isConnecting
              ? null
              : () {
                  scan();
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

  void scan() {
    // // Clear stale state
    // if(Provider.of<Model>(context, listen: false).bldc != null){
    //   Provider.of<Model>(context, listen: false).bldc.uart.disconnect();
    // }
    // Scan
    hasScanned = true;
    Provider.of<FlutterBlue>(_key.currentContext, listen: false).startScan(timeout: Duration(seconds: 5));
  }

  void  connect(BluetoothDevice device){
    // print("Connecting");
    // // Clear stale state
    // if(Provider.of<Model>(context, listen: false).bldc != null){
    //   print("Connecting - already connected, disconnecting");
    //   await Provider.of<Model>(context, listen: false).bldc.uart.disconnect();
    //   await Future.delayed(Duration(seconds: 1));
    // }
    // Connect
    setState(() {
      isConnecting = true;
    });
    BLEUart bleUart = BLEUart(device);
    bleUart.isIntialized.then((value) {
      print("BLEUart Initialized");
      setState(() {
        isConnecting = false;
      });
      Provider.of<Model>(_key.currentContext, listen: false).bldc = BLDC(bleUart);
      Provider.of<Model>(_key.currentContext, listen: false).bldc.requestFirmwareInfo();
      Navigator.push(
        _key.currentContext,
        MaterialPageRoute(builder: (context) {
          return StartPage();
        }),
      );
    }, onError: (error) {
      setState(() {
        isConnecting = false;
      });
      final snackBar = SnackBar(content: Text('Unable to connect, please make sure selected device has a UART interface.'));
      Scaffold.of(_key.currentContext).showSnackBar(snackBar);
    });
  }
}
