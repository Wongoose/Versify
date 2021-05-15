import 'package:versify/screens/feed_screen/create_post_sub/widgets/smart_text.dart';
import 'package:flutter/material.dart';

class TextContent extends StatelessWidget {
  final FocusNode focusNode;
  final bool isFocus;
  final TextEditingController textEditingController;
  final bool isFirst;

  TextContent(
      {this.focusNode, this.isFocus, this.textEditingController, this.isFirst});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, isFirst != null ? 2 : 8, 0, 8),
      margin: EdgeInsets.fromLTRB(0, 0, 26, 0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: Color(0xffff548e),
          ),
        ),
      ),
      child: SmartTextField(
        // contentBodyProvider: state,
        isFirst: isFirst,
        focusNode: focusNode,
        isFocus: isFocus,
        controller: textEditingController,
      ),
    );
  }
}
