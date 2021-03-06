import 'package:karostreammemories/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:karostreammemories/drive/state/root-navigator-key.dart';

InputDecoration authInputDecoration(IconData icon, String label) {
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: Theme.of(rootNavigatorKey.currentContext!).cardColor,
    border: OutlineInputBorder(),
    prefixIcon: Icon(icon),
    labelText: trans(label),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}