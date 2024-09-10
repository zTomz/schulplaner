import 'package:flutter/material.dart';

Future<void> closeAllDialogs(BuildContext context) async {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
