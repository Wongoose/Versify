import 'package:versify/providers/providers_feeds/input_comments_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/shared/helper/helper_classes.dart';

class InputComment extends StatefulWidget {
  final FocusNode focusNode;
  final bool isViewOnly;
  final BuildContext context;
  final TextEditingController textEditingController;

  InputComment(
      {this.focusNode,
      this.isViewOnly,
      this.context,
      this.textEditingController});

  @override
  _InputCommentState createState() => _InputCommentState();
}

class _InputCommentState extends State<InputComment> {
  InputCommentsProvider _inputCommentsProvider;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.focusNode.addListener(() {
        // if (widget.focusNode.hasFocus) {
        _inputCommentsProvider.updateFocus();
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _inputCommentsProvider =
        Provider.of<InputCommentsProvider>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, -0.5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfilePic(
            primary: Colors.pinkAccent,
            secondary: Colors.pink[200],
            size: 1,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.send,
                textCapitalization: TextCapitalization.sentences,
                controller: widget.textEditingController,
                enabled: true,
                maxLines: null,
                keyboardType: TextInputType.text,
                autocorrect: true,
                autofocus: true,
                enableInteractiveSelection: true,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  suffixIcon: GestureDetector(
                    onTap: () => {print('Sent Comment')},
                    child: Icon(Icons.send_rounded),
                  ),

                  contentPadding: EdgeInsets.fromLTRB(12, 8, 8, 8),
                  hintText: "Comment as zheng_xiang_wzx...",
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(25),
                  // ),
                  border: InputBorder.none,
                  filled: true,
                  isDense: false,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 4.0),
          //   height: 30,
          //   width: 30,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.white,
          //   ),
          //   child: Center(
          //     child: Icon(
          //       Icons.more_vert_rounded,
          //       color: Colors.black54,
          //       size: 28,
          //     ),
          //   ),
          // ),
          // SizedBox(width: 4),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 4.0),
          //   height: 35,
          //   width: 35,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.grey[400],
          //   ),
          //   child: Center(
          //     child: Icon(
          //       Icons.flag,
          //       color: Colors.white,
          //       size: 20,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
