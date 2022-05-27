import 'package:karostreammemories/utils/text.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(String? content, BuildContext context, {bool hidePrevious = true, int duration = 4000, SnackBarAction? action}) {
  final scaffold = Scaffold.of(context);
  if (hidePrevious) {
    scaffold.hideCurrentSnackBar();
  }
  return scaffold.showSnackBar(SnackBar(
    content: text(content),
    duration: Duration(milliseconds: duration),
    action: action,
  ));
}