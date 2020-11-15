import 'package:bldc_wizard/welcome.dart';
import 'package:flutter/material.dart';

class WizardApp extends MaterialApp{
  WizardApp() : super(
    title: 'BLDC Wizard',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      accentColor: Colors.blue,

      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: WelcomePage(),
  );
}