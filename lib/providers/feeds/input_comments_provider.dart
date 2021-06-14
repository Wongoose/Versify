import 'package:versify/screens/feed_screen/widget_view_post/input_comment.dart';
import 'package:flutter/cupertino.dart';

class InputCommentsProvider extends ChangeNotifier {
  FocusNode focusNode = FocusNode();
  bool isFocused = false;
  TextEditingController textEditingController = TextEditingController();
  Widget inputCommentWidget;

  void requestFocus() {
    print('Tap and requesting Focus');
    isFocused = true;
    notifyListeners();
    focusNode.requestFocus();
  }

  void attachController() {
    inputCommentWidget = InputComment(
      textEditingController: textEditingController,
      focusNode: focusNode,
      isViewOnly: true,
    );
  }

  void updateFocus() {
    print('Update Focus RAN!');
    isFocused = focusNode.hasFocus;
    notifyListeners();
  }

  void nextPostClearComment() {
    textEditingController.text = '';
  }
}
