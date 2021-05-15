import 'package:versify/providers/content_body_provider.dart';
import 'package:versify/screens/feed_screen/create_post_sub/widgets/editing_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

enum SmartTextType { H1, T, QUOTE, BULLET }

extension SmartTextStyle on SmartTextType {
  TextStyle get textStyle {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextStyle(
            fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.white70);
      case SmartTextType.H1:
        return TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
        break;
      default:
        return TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600);
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case SmartTextType.H1:
        return EdgeInsets.fromLTRB(16, 24, 16, 8);
        break;
      case SmartTextType.BULLET:
        return EdgeInsets.fromLTRB(24, 8, 16, 8);
      default:
        return EdgeInsets.fromLTRB(10, 0, 8, 0);
    }
  }

  TextAlign get align {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextAlign.center;
        break;
      default:
        return TextAlign.start;
    }
  }

  String get prefix {
    switch (this) {
      case SmartTextType.BULLET:
        return '\u2022 ';
        break;
      default:
        return '';
    }
  }
}

class SmartTextField extends StatefulWidget {
  SmartTextField({
    Key key,
    this.type,
    this.controller,
    this.focusNode,
    this.controllerType,
    this.isFocus,
    this.isFirst,
  }) : super(key: key);

  final SmartTextType type;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String controllerType;
  final bool isFocus;
  final bool isFirst;

  @override
  _SmartTextFieldState createState() => _SmartTextFieldState();
}

class _SmartTextFieldState extends State<SmartTextField> {
  int _prevSafeIndex;
  ContentBodyProvider contentBodyProvider;

  void initState() {
    super.initState();
    widget.controllerType != 'title'
        ? widget.focusNode.addListener(() {
            // if (widget.focusNode.hasFocus) {
              print('Text Field Focused');
              contentBodyProvider.getCurrentFocus();
            // }
          })
        : null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controllerType != 'title'
          ? contentBodyProvider.updateCounter()
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    contentBodyProvider =
        Provider.of<ContentBodyProvider>(context, listen: false);

    return TextField(
      scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      onTap: () => setState(
          () => _prevSafeIndex = widget.controller.selection.baseOffset),
      onChanged: (val) {
        try {
          print(Utf8Codec().encode(widget.controller.text));
          setState(
              () => _prevSafeIndex = widget.controller.selection.baseOffset);
          print(_prevSafeIndex);
          widget.controllerType != 'title'
              ? contentBodyProvider.updateCounter()
              : null;
        } catch (e) {
          print('the error ' + e.toString());
          widget.controller.text = widget.controller.text.replaceRange(
              _prevSafeIndex, widget.controller.selection.end, '');
          widget.controller.selection =
              TextSelection.fromPosition(TextPosition(offset: _prevSafeIndex));
        }
      },
      
      autocorrect: true,
      autofillHints: ['versify'],
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.isFocus,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      cursorColor: Colors.teal,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: widget.controllerType == 'title'
          ? TextInputAction.go
          : TextInputAction.newline,
      cursorHeight: widget.controllerType == 'title' ? 30 : 20,
      textAlign: widget.type.align,
      enableInteractiveSelection:
          widget.controllerType == 'title' ? false : true,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          labelStyle: widget.controllerType == 'title'
              ? TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Libre')
              : TextStyle(
                  fontSize: 15.5, fontWeight: FontWeight.w600, height: 1.5),
          hintText: widget.controllerType == 'title'
              ? 'What is your title . . .'
              : widget.isFirst != null && widget.isFirst == true
                  ? 'Write your thoughts down . . . \n'
                  : 'Your text',
          hintStyle: widget.controllerType == 'title'
              ? TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Libre')
              : TextStyle(
                  fontSize: 15.5, fontWeight: FontWeight.w600, height: 1.5),
          border: InputBorder.none,
          prefixText: widget.type.prefix,
          prefixStyle: widget.type.textStyle,
          isDense: true,
          contentPadding: widget.type.padding),
      style: widget.controllerType == 'title'
          ? TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
              fontFamily: 'Libre',
              height: 1.4,
              letterSpacing: -0.3,
              decorationStyle: TextDecorationStyle.solid)
          : TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, height: 1.5),
    );
  }
}
