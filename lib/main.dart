import 'package:bldc_wizard/wizard_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import 'model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => FlutterBlue.instance),
      Provider(create: (_) => Model()),
    ],
    child: WizardApp(),
  ));
}
