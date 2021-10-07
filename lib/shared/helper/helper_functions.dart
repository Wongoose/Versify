import 'package:flutter/material.dart';
import 'package:versify/source/wrapper.dart';

Future<void> refreshToWrapper(BuildContext context) async {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Wrapper()),
    (route) => false,
  );
}
