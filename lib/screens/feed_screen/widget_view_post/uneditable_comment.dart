import 'package:versify/providers/feeds/input_comments_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UneditableInputComment extends StatelessWidget {
  const UneditableInputComment({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputCommentsProvider inputCommentsProvider =
        Provider.of<InputCommentsProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, -0.5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ProfilePic(
          //   primary: Colors.pinkAccent,
          //   secondary: Colors.pink[200],
          //   size: 1,
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onTap: () {
                  Navigator.pop(context);
                  inputCommentsProvider.requestFocus();
                },
                // focusNode: inputFocus,
                textInputAction: TextInputAction.send,
                controller: inputCommentsProvider.textEditingController,
                textCapitalization: TextCapitalization.sentences,
                enabled: true,
                maxLines: null,
                keyboardType: TextInputType.text,
                readOnly: true,
                autocorrect: true,
                autofocus: false,
                enableInteractiveSelection: false,
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
        ],
      ),
    );
  }
}
