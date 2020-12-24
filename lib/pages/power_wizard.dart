import 'package:bldc_wizard/esc/esc_state.dart';
import 'package:bldc_wizard/esc/models/can_ping.dart';
import 'package:bldc_wizard/esc/models/fw_info.dart';
import 'package:bldc_wizard/esc/models/motor_config.dart';
import 'package:bldc_wizard/widgets/connection_state_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../model.dart';
import 'config_writer.dart';

class PowerWizardPage extends StatefulWidget {
  PowerWizardPage({Key key}) : super(key: key);

  @override
  _PowerWizardState createState() => _PowerWizardState();
}

class _PowerWizardState extends State<PowerWizardPage> {
  PrimitiveWrapper<double> lCurrentMin, lCurrentMax;

  @override
  Widget build(BuildContext context) {
    // Load default value
    if (lCurrentMin == null) {
      Model model = Provider.of<Model>(context, listen: false);
      lCurrentMin = PrimitiveWrapper(model.devices[-1].motorConfig.lCurrentMin);
      lCurrentMax = PrimitiveWrapper(model.devices[-1].motorConfig.lCurrentMax);
    }
    return Scaffold(
      appBar: AppBar(title: Text("Set Power Output"), actions: [ConnectionStateIndicator()]),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext buildContext) {
    return Container(
      child: Column(
        children: [
          getValueAdjuster("Motor Max Current", lCurrentMax, 0, "A", [-5, -1, 1, 5], 0, 0, 10000),
          getValueAdjuster("Motor Min Current", lCurrentMin, 0, "A", [5, 1, -1, -5], 0, -10000, 0),
          Spacer(),
          getWriteButton(context)
        ],
      ),
    );
  }

  Widget getWriteButton(BuildContext buildContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: false
              ? null
              : () {
                  writeMotorConfigs(context);
                },
          child: Text(
            Provider.of<Model>(context, listen: false).devices.length > 1 ? "Write to all ESCs" : "Write to ESC",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  writeMotorConfigs(BuildContext context) {
    Model model = Provider.of<Model>(context, listen: false);

    for (int canId in model.devices.keys){
      MotorConfig config = model.devices[canId].motorConfig;
      config.lCurrentMax = lCurrentMax.value;
      config.lCurrentMin = lCurrentMin.value;
    }


    Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return ConfigWriterPage();
      }),
    );
  }

  Widget getValueAdjuster(
      String label, PrimitiveWrapper value, int valuePrecision, String valueSuffix, List<double> adjusters, int adjusterPrecision, double min, double max) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(color: Colors.black, height: 1),
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    value.value += adjusters[0];
                    if (value.value < min) {
                      value.value = min;
                    } else if (value.value > max) {
                      value.value = max;
                    }
                  });
                },
                child: Text(
                  "${adjusters[0].toStringAsFixed(adjusterPrecision)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    value.value += adjusters[1];
                    if (value.value < min) {
                      value.value = min;
                    } else if (value.value > max) {
                      value.value = max;
                    }
                  });
                },
                child: Text(
                  "${adjusters[1].toStringAsFixed(adjusterPrecision)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Text(
                "${value.value.toStringAsFixed(valuePrecision)} $valueSuffix",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    value.value += adjusters[2];
                    if (value.value < min) {
                      value.value = min;
                    } else if (value.value > max) {
                      value.value = max;
                    }
                  });
                },
                child: Text(
                  "${adjusters[2].toStringAsFixed(adjusterPrecision)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    value.value += adjusters[3];
                    if (value.value < min) {
                      value.value = min;
                    } else if (value.value > max) {
                      value.value = max;
                    }
                  });
                },
                child: Text(
                  "${adjusters[3].toStringAsFixed(adjusterPrecision)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PrimitiveWrapper<T> {
  T value;

  PrimitiveWrapper(this.value);
}
