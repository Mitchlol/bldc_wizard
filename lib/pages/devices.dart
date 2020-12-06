import 'package:bldc_wizard/esc/esc_state.dart';
import 'package:bldc_wizard/esc/models/can_ping.dart';
import 'package:bldc_wizard/esc/models/fw_info.dart';
import 'package:bldc_wizard/esc/models/motor_config.dart';
import 'package:bldc_wizard/pages/start.dart';
import 'package:bldc_wizard/widgets/connection_state_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../model.dart';

class DevicesPage extends StatefulWidget {
  DevicesPage({Key key}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<DevicesPage> {
  Future future;

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      future = getAllDevices(context);
    }
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(title: Text("Connected ESCs"), actions: [ConnectionStateIndicator()]),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: FloatingActionButton(
                  child: snapshot.connectionState == ConnectionState.done
                      ? Icon(
                          Icons.refresh,
                        )
                      : CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                  onPressed: snapshot.connectionState == ConnectionState.done
                      ? () => setState(() {
                            future = getAllDevices(context);
                          })
                      : null,
                ),
              ),
              body: getBody(context, snapshot));
        });
  }

  Widget getBody(BuildContext buildContext, AsyncSnapshot snapshot) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            getDevicesWidget(buildContext, snapshot),
            Spacer(),
            getStartButton(buildContext, snapshot),
          ],
        ),
      ),
    );
  }

  Widget getDevicesWidget(BuildContext buildContext, AsyncSnapshot snapshot) {
    List<Widget> items = List();
    if (snapshot.connectionState != ConnectionState.done) {
      items.add(Padding(
        padding: const EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      ));
    } else {
      Provider.of<Model>(context, listen: false).devices.forEach((key, value) {
        items.add(getDeviceInfoCard(buildContext, key, value.fwInfo));
      });
      if (items.isEmpty) {
        items.add(getDeviceInfoCard(buildContext, -1, null));
      }
    }

    return Column(
      children: items,
    );
  }

  Widget getDeviceInfoCard(BuildContext buildContext, int canId, FWInfo fwInfo) {
    return Card(
      elevation: 1,
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
                        fwInfo == null ? "Unknown Firmware" : fwInfo.getName(),
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
                        fwInfo == null ? "Is device a compatible ESC" : "ID: ${fwInfo.getUuid()}\nCan ID: ${canId == -1 ? "local" : canId}",
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
                    fwInfo == null ? "Unable to parse FW Info, is device running Benjamin Vedder's BLDC Firmware?" : "Firmware: ${fwInfo.getVersion()}",
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

  Widget getStartButton(BuildContext buildContext, AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: snapshot.connectionState != ConnectionState.done || !Provider.of<Model>(context, listen: false).isValid()
              ? null
              : () {
            Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (context) {
                return StartPage();
              }),
            );
          },
          child:Text(
            "Start",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> getAllDevices(BuildContext context) async {
    print("Get all FwInfo");
    Model model = Provider.of<Model>(context, listen: false);

    // Clear old data
    model.devices.clear();

    // Get local
    model.devices[-1] = ESCState();

    // Get local FW Info
    model.bldc.requestFirmwareInfo();
    model.devices[-1].fwInfo = await model.bldc.getStream<FWInfo>().first.timeout(Duration(seconds: 5));
    print("Got local FWInfo ${model.devices[-1].fwInfo.uuid}");

    // Get motor config
    model.bldc.requestMotorConfig();
    model.devices[-1].motorConfig = await model.bldc.getStream<MotorConfig>().first.timeout(Duration(seconds: 5));
    print("Got local motor config");

    // Scan Can Bus
    model.bldc.requestPingCan();
    CanPing canPing = await model.bldc.getStream<CanPing>().first.timeout(Duration(seconds: 5));
    print("Got can device list ${canPing.canIds}");

    // Get all can FW Infos
    for (int canId in canPing.canIds) {
      try {
        model.bldc.requestFirmwareInfo(canId: canId);
        FWInfo fwInfo = await model.bldc.getStream<FWInfo>().first.timeout(Duration(seconds: 5));
        print("Got $canId FWInfo ${fwInfo.uuid}");

        model.bldc.requestMotorConfig(canId: canId);
        MotorConfig motorConfig = await model.bldc.getStream<MotorConfig>().first.timeout(Duration(seconds: 5));
        print("Got $canId MotorConfig");

        model.devices[canId] = ESCState();
        model.devices[canId].fwInfo = fwInfo;
        model.devices[canId].motorConfig = motorConfig;
      } catch (exception) {
        print(exception);
      }
    }
  }
}
