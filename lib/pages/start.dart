import 'package:bldc_wizard/esc/esc_state.dart';
import 'package:bldc_wizard/esc/models/can_ping.dart';
import 'package:bldc_wizard/esc/models/fw_info.dart';
import 'package:bldc_wizard/esc/models/motor_config.dart';
import 'package:bldc_wizard/pages/power_wizard.dart';
import 'package:bldc_wizard/widgets/connection_state_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      appBar: AppBar(title: Text("Select Wizard"), actions: [ConnectionStateIndicator()]),
      body: getButtons(context),
    );
  }

  Widget getButtons(BuildContext buildContext) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Set Power Output',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  subtitle: Text('Adjust motor output current limits. This will determine the maximum torque for your vehicle.'),
                  trailing: Icon(
                    Icons.bolt,
                    color: Colors.blue,
                  ),
                  onTap: !Provider.of<Model>(context, listen: false).isValid()
                      ? null
                      : () {
                          Navigator.push(
                            buildContext,
                            MaterialPageRoute(builder: (context) {
                              return PowerWizardPage();
                            }),
                          );
                        },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
