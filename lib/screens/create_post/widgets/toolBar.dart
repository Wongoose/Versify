import 'package:versify/models/content_widget_model.dart';
import 'package:versify/providers/providers_create_post/content_body_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/create_post/widgets/content_normal_text.dart';
import 'package:versify/screens/create_post/widgets/quote_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateToolBar extends StatefulWidget {
  @override
  _CreateToolBarState createState() => _CreateToolBarState();
}

class _CreateToolBarState extends State<CreateToolBar> {
  @override
  Widget build(BuildContext context) {
    final ContentBodyProvider _contentBodyProvider =
        Provider.of<ContentBodyProvider>(context, listen: true);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(55, 0, 55, 15),
          height: 50,
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border: Border.all(
                color: _themeProvider.secondaryTextColor,
              ),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    TextEditingController _tempQuoteController =
                        TextEditingController();
                    TextEditingController _tempQuoteTitleController =
                        TextEditingController();

                    FocusNode _tempQuoteFocusNode = FocusNode();

                    if (_contentBodyProvider.selectedTool != WidgetType.quote) {
                      _contentBodyProvider.addQuote(
                          widget: QuoteText(
                            quoteController: _tempQuoteController,
                            titleController: _tempQuoteTitleController,
                            isFocus: false,
                            focusNode: _tempQuoteFocusNode,
                            quoteEnteredAddText:
                                _contentBodyProvider.addTextAfterQuote,
                          ),
                          quoteController: _tempQuoteController,
                          focusNode: _tempQuoteFocusNode);
                      // contentBodyProvider.selectToolbar(
                      //   WidgetType.quote,
                      //   isRequestFocus: true,
                      //   index: contentBodyProvider 
                      //           .listOfContentWidgets.isEmpty
                      //       ? 0
                      //       : contentBodyProvider.currentFocusIndex + 1,
                      // );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 65,
                    child: Icon(Icons.format_quote,
                        color: _contentBodyProvider.selectedTool ==
                                WidgetType.quote
                            ? Colors.deepPurpleAccent
                            : _themeProvider.secondaryTextColor),
                  )),
              GestureDetector(
                onTap: () {
                  TextEditingController _temptextController =
                      TextEditingController();
                  FocusNode _tempTextFocusNode = FocusNode();

                  if (_contentBodyProvider.selectedTool != WidgetType.text) {
                    _contentBodyProvider.addText(
                      widget: TextContent(
                        textEditingController: _temptextController,
                        isFocus: false,
                        focusNode: _tempTextFocusNode,
                      ),
                      textController: _temptextController,
                      focusNode: _tempTextFocusNode,
                      // isFirst: false,
                    );
                    // contentBodyProvider.selectToolbar(
                    //   WidgetType.text,
                    //   isRequestFocus: true,
                    //   index:
                    //       contentBodyProvider.listOfContentWidgets.isEmpty
                    //           ? 0
                    //           : contentBodyProvider.currentFocusIndex + 1,
                    // );
                  }
                },
                child: Container(
                  height: 50,
                  width: 65,
                  child: Icon(Icons.text_fields_rounded,
                      color:
                          _contentBodyProvider.selectedTool == WidgetType.text
                              ? Theme.of(context).primaryColor
                              : _themeProvider.secondaryTextColor),
                ),
              ),
              Container(
                  height: 50,
                  width: 65,
                  child: Icon(Icons.image,
                      color: _themeProvider.secondaryTextColor)),
              VerticalDivider(thickness: 1, width: 0),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (_contentBodyProvider.selectedTool != WidgetType.delete) {
                    _contentBodyProvider.deleteCurrentSelect();
                  }
                },
                child: Container(
                  height: 50,
                  width: 65,
                  child: Icon(Icons.cancel, color: Colors.red.withOpacity(0.9)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
