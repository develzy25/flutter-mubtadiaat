import 'package:flutter/material.dart';

class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;
  static const double circular = 999.0;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(small));
  static const BorderRadius md = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(large));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(extraLarge));
  static const BorderRadius rounded = BorderRadius.all(Radius.circular(circular));
}
