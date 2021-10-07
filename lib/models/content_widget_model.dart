import 'package:flutter/material.dart';

enum WidgetType { quote, text, image, delete }

class ContentWidget {
  final Widget widget;
  final TextEditingController controller;
  final WidgetType widgetType;
  final FocusNode focusNode;
  // final ContentBodyProvider contentBodyProvider;

  ContentWidget({
    this.widget,
    this.controller,
    this.widgetType,
    this.focusNode,
  });
}
