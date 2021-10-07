import 'package:versify/models/content_widget_model.dart';
import 'package:versify/screens/create_post/widgets/content_normal_text.dart';
import 'package:flutter/cupertino.dart';

// enum WidgetType { quote, text, image, bold }

class ContentBodyProvider extends ChangeNotifier {
  List<ContentWidget> _contentWidgetList = [];

  List<TextEditingController> _allControllerList = [];
  WidgetType _enumToolBarSelected;

  int _writeCounter = 0;

  String _textOfAllControllers = '';

  int _currentFocusIndex;
  int _nextFocusIndex;
  WidgetType _currentWidgetType;

  List<ContentWidget> get listOfContentWidgets => _contentWidgetList;
  WidgetType get selectedTool => _enumToolBarSelected;
  bool get hasWritten => _textOfAllControllers.isNotEmpty;
  String get allText => _textOfAllControllers;
  int get currentFocusIndex => _currentFocusIndex;
  WidgetType get currentWidgetType => _currentWidgetType;

  bool get validBodyLength {
    return _textOfAllControllers
            .trim()
            .replaceAll(' ', '')
            .replaceAll('\n', '')
            .length >=
        250;
  }

  void refocusCurrent() {
    _currentFocusIndex = _currentFocusIndex < 0 ? 0 : _currentFocusIndex;
    _contentWidgetList[_currentFocusIndex].focusNode.requestFocus();
    print('Refocus Current at index: ' + _currentFocusIndex.toString());
  }

  void getCurrentFocus() {
    print('Get current focus RAN!');
    List<ContentWidget> _tempListToRemove = [];

    for (int i = _contentWidgetList.length - 1; i >= 1; i--) {
      print('For Loop int i is: ' + i.toString());
      if (_contentWidgetList[i].widgetType ==
              _contentWidgetList[i - 1].widgetType &&
          _contentWidgetList[i].widgetType == WidgetType.text) {
        String _tempTextToBeAdded = _contentWidgetList[i].controller.text;
        _contentWidgetList[i - 1].controller.text +=
            ('\n' + _tempTextToBeAdded.replaceFirst('\n', ' '));
        // _contentWidgetList.removeAt(i + 1);
        _tempListToRemove.add(_contentWidgetList[i]);
        // _contentWidgetList[i].focusNode.requestFocus();
      }
    }
    _tempListToRemove.forEach((widgetToRemove) {
      _contentWidgetList.remove(widgetToRemove);
      _allControllerList.remove(widgetToRemove.controller);
    });
    for (int i = 0; i <= _contentWidgetList.length - 1; i++) {
      if (_contentWidgetList[i].focusNode.hasFocus) {
        _currentWidgetType = _contentWidgetList[i].widgetType;

        _currentFocusIndex = i; //update the current focus
        print('Current Focus Index: ' + _currentFocusIndex.toString());

        _nextFocusIndex =
            _currentFocusIndex != null ? _currentFocusIndex + 1 : 0;
        print('Next Focus Index: ' + _nextFocusIndex.toString());
        updateToolBar(_currentWidgetType);
      }
    }
  }

  void updateToolBar(WidgetType selection) {
    _enumToolBarSelected = selection;
    notifyListeners();
  }

  Future<void> selectToolbar(WidgetType selection,
      {bool isRequestFocus, int index}) async {
    _enumToolBarSelected = selection;
    notifyListeners();
    print('Notify listeners in selectToolBar');

    // _currentFocusIndex = index;
    // print('Current Focus Index: ' + _currentFocusIndex.toString());

    if (isRequestFocus == true) {
      _contentWidgetList[index].focusNode.requestFocus();
      print('SelectTollBar requested focusat index: ' + index.toString());
    } else {
      _currentFocusIndex = 0; //update the current focus

      _nextFocusIndex = _currentFocusIndex != null ? _currentFocusIndex + 1 : 1;
    }
  }

  void addText({
    Widget widget,
    TextEditingController textController,
    FocusNode focusNode,
    bool isFirst,
    bool addedSplitAfterQuote = false,
  }) {
    bool _shouldReplace =
        isFirst != null && isFirst ? false : replaceWidgetCheck();
    if (_shouldReplace) {
      _contentWidgetList.removeAt(_currentFocusIndex);
      _currentFocusIndex -= 1;
      _nextFocusIndex -= 1;
    }
    print('insert text at: ' +
        (isFirst != null && isFirst ? 0 : _nextFocusIndex ?? 0).toString());
    _contentWidgetList.insert(
      isFirst != null && isFirst ? 0 : _nextFocusIndex ?? 0,
      new ContentWidget(
        widget: widget,
        controller: textController,
        widgetType: WidgetType.text,
        focusNode: focusNode,
      ),
    );
    _allControllerList.insert(
        isFirst != null && isFirst ? 0 : _nextFocusIndex ?? 0, textController);
    if (!addedSplitAfterQuote) {
      notifyListeners();
      selectToolbar(WidgetType.text,
          isRequestFocus: isFirst != null && isFirst ? false : true,
          index: isFirst != null && isFirst ? 0 : _nextFocusIndex ?? 0);
    }
    print('Building TEXT - The current focus index is: ' +
        _currentFocusIndex.toString());
  }

  void addQuote(
      {StatefulWidget widget,
      TextEditingController quoteController,
      FocusNode focusNode}) {
    bool _shouldReplace = replaceWidgetCheck();

    // int _tempSplitIndex;
    // int _tempSpaceIndex = _contentWidgetList[_currentFocusIndex]
    //     .controller
    //     .text
    //     .indexOf(' ', _currentStringIndex);

    // int _tempEnterIndex = _contentWidgetList[_currentFocusIndex]
    //     .controller
    //     .text
    //     .indexOf('\n', _currentStringIndex);

    // if (_tempSpaceIndex != -1) {
    //   if (_tempEnterIndex != -1) {
    //     _tempSplitIndex = _tempSpaceIndex <= _tempEnterIndex
    //         ? _tempSpaceIndex
    //         : _tempEnterIndex;
    //   } else {
    //     _tempSplitIndex = _tempSpaceIndex;
    //   }
    // } else if (_tempEnterIndex != -1) {
    //   _tempSplitIndex = _tempEnterIndex;
    // } else {
    //   _tempSplitIndex = _contentWidgetList[_currentFocusIndex]
    //       .controller
    //       .text
    //       .characters
    //       .length;
    // }
    int _currentStringIndex;
    if (_contentWidgetList[_currentFocusIndex].focusNode.hasFocus) {
      _currentStringIndex = _quoteSplitTextAtIndex();
    }

    String _splitTextFirst = '';
    String _splitTextSecond = '';
    print('The selection index is at: ' + _currentStringIndex.toString());

    if (_shouldReplace) {
      print('Quote says should replace');
      _contentWidgetList.removeAt(_currentFocusIndex);
      _allControllerList.removeAt(_currentFocusIndex);

      _currentFocusIndex -= 1;
      _nextFocusIndex -= 1;
    } else if (
        // _currentStringIndex <
        //       _contentWidgetList[_currentFocusIndex]
        //               .controller
        //               .text
        //               .characters
        //               .length -
        //           1 &&
        _currentStringIndex != null) {
      print('Going to split');
      _splitTextFirst = _contentWidgetList[_currentFocusIndex]
          .controller
          .text
          .characters
          .getRange(0, _currentStringIndex)
          .toString();
      _splitTextSecond = _contentWidgetList[_currentFocusIndex]
          .controller
          .text
          .characters
          .getRange(
              _currentStringIndex,
              _contentWidgetList[_currentFocusIndex]
                  .controller
                  .text
                  .characters
                  .length)
          .toString();

      _contentWidgetList[_currentFocusIndex].controller.text = _splitTextFirst;
      print('Selectin in the middle split first text is: ' +
          _splitTextFirst.toString());
    }

    // int _insertIndex = _nextFocusIndex != null
    //     ? _splitTextSecond.isNotEmpty
    //         ? _nextFocusIndex - 1
    //         : _nextFocusIndex
    //     : 0;

    int _insertIndex = _nextFocusIndex ?? 0;
    print('QUOTE INSERT at ' + _insertIndex.toString());
    _splitTextSecond != null && _splitTextSecond.isNotEmpty
        ? quoteController.text = 'Here'
        : null;
    _contentWidgetList.insert(
      _insertIndex,
      ContentWidget(
        widget: widget,
        controller: quoteController,
        widgetType: WidgetType.quote,
        focusNode: focusNode,
      ),
    );

    _allControllerList.insert(_insertIndex, quoteController);
    //adding second part of split

    if (_splitTextSecond != null && _splitTextSecond.isNotEmpty) {
      print('Split second part is not empty index: ' +
          _nextFocusIndex.toString());
      TextEditingController _temptextController = TextEditingController();
      FocusNode _tempTextFocusNode = FocusNode();
      _currentFocusIndex++;
      _nextFocusIndex++;
      print('SECOND TEXT INSERT');

      _temptextController.text = _splitTextSecond;

      addText(
        widget: TextContent(
          textEditingController: _temptextController,
          isFocus: false,
          focusNode: _tempTextFocusNode,
        ),
        textController: _temptextController,
        focusNode: _tempTextFocusNode,
        addedSplitAfterQuote: true,
      );

      print('After TEXT - The current focus index is: ' +
          _currentFocusIndex.toString());
      // notifyListeners();
      selectToolbar(WidgetType.quote,
          isRequestFocus: true, index: _currentFocusIndex ?? 0);
    } else {
      notifyListeners();
      selectToolbar(WidgetType.quote,
          isRequestFocus: true, index: _nextFocusIndex ?? 0);
    }
  }

  int _quoteSplitTextAtIndex() {
    int stringSelectionIndex =
        _contentWidgetList[_currentFocusIndex].controller.selection.baseOffset;
    print('Quote Split at index parsed in selectionIndex: ' +
        stringSelectionIndex.toString());
    int _tempSplitIndex;
    if (stringSelectionIndex != -1) {
      int _tempSpaceIndex = _contentWidgetList[_currentFocusIndex]
          .controller
          .text
          .indexOf(' ', stringSelectionIndex);

      int _tempEnterIndex = _contentWidgetList[_currentFocusIndex]
          .controller
          .text
          .indexOf('\n', stringSelectionIndex);

      if (_tempSpaceIndex != -1) {
        if (_tempEnterIndex != -1) {
          _tempSplitIndex = _tempSpaceIndex <= _tempEnterIndex
              ? _tempSpaceIndex
              : _tempEnterIndex;
        } else {
          _tempSplitIndex = _tempSpaceIndex;
        }
      } else if (_tempEnterIndex != -1) {
        _tempSplitIndex = _tempEnterIndex;
      } else {
        _tempSplitIndex = _contentWidgetList[_currentFocusIndex]
            .controller
            .text
            .characters
            .length;
      }
    } else {
      _tempSplitIndex = -1;
    }
    return _tempSplitIndex;
  }

  void addTextAfterQuote() {
    if (_currentFocusIndex == _contentWidgetList.length - 1) {
      TextEditingController _temptextController = TextEditingController();
      FocusNode _tempTextFocusNode = FocusNode();

      if (_enumToolBarSelected != WidgetType.text) {
        addText(
          widget: TextContent(
            textEditingController: _temptextController,
            isFocus: false,
            focusNode: _tempTextFocusNode,
          ),
          textController: _temptextController,
          focusNode: _tempTextFocusNode,
        );
      }
    } else {
      _contentWidgetList[_currentFocusIndex].focusNode.nextFocus();
      // print('Current Focus index after enter from quote: ' + _currentFocusIndex.toString());
      _contentWidgetList[_nextFocusIndex].controller.selection =
          TextSelection.fromPosition(TextPosition(offset: 0));
    }
  }

  bool replaceWidgetCheck() {
    return _contentWidgetList[_currentFocusIndex].controller.text.isEmpty
        ? true
        : false;
  }

  void deleteCurrentSelect() {
    if (_currentFocusIndex != 0) {
      _enumToolBarSelected = WidgetType.delete;
      _contentWidgetList[_currentFocusIndex].focusNode.previousFocus();
      _contentWidgetList.removeAt(_currentFocusIndex);
      _allControllerList.removeAt(_currentFocusIndex);
    }
    updateCounter();
    notifyListeners();
  }

  void updateCounter() {
    // _writeCounter = text.split(' ').length -1;
    // String _textWithNoSpaces =
    //     text.trim().replaceAll(' ', '').replaceAll('\n', '');
    // _writeCounter = _textWithNoSpaces.length;

    _textOfAllControllers = '';
    _allControllerList.forEach((textController) {
      _textOfAllControllers += textController.text;
    });

    String _trimmedText =
        _textOfAllControllers.trim().replaceAll(' ', '').replaceAll('\n', '');
    _writeCounter = _trimmedText.length;
    print(_writeCounter);

    notifyListeners();
  }

  int get writeCounter => _writeCounter;

  void clearAll() {
    print('Cleared all content!');
    _contentWidgetList.clear();
    _allControllerList.clear();
    _currentFocusIndex = null;
  }
}
