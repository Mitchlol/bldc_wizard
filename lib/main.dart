import 'package:bldc_wizard/wizard_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Provider(
    create:  (_) => FlutterBlue.instance,
    child: WizardApp(),
  ));
}
