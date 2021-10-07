import 'package:google_fonts/google_fonts.dart';
import 'package:versify/providers/providers_create_post/content_body_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/create_post/widgets/feature_quote.dart';
import 'package:versify/screens/create_post/widgets/search_verse_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuoteText extends StatefulWidget {
  final TextEditingController quoteController;
  final TextEditingController titleController;
  final FocusNode focusNode;
  final bool isFocus;
  final Function() quoteEnteredAddText;

  String topic;

  QuoteText(
      {this.quoteController,
      this.topic,
      this.focusNode,
      this.isFocus,
      this.quoteEnteredAddText,
      this.titleController});

  @override
  _QuoteTextState createState() => _QuoteTextState();
}

class _QuoteTextState extends State<QuoteText> {
  ContentBodyProvider contentBodyProvider;
  ThemeProvider _themeProvider;
  String _quoteTitle;

  void updateVerse({String topic, String verse}) {
    setState(() {
      topic = topic;
      widget.titleController.text = topic;
      _quoteTitle = topic;
      widget.quoteController.text = verse;
    });
  }

  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      // if (widget.focusNode.hasFocus) {
      print('Quote Text Focused!');
      contentBodyProvider.getCurrentFocus();
      // }
    });
    print('Quote Text has initState');
  }

  void _openBottomSheet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (widget.quoteController.text != '') {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return QuoteBottomSheet(updateVerse: updateVerse);
        },
      );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    contentBodyProvider =
        Provider.of<ContentBodyProvider>(context, listen: false);

    print('QuoteText has value: ' + widget.quoteController.text);

    if (widget.quoteController.text.isEmpty) {
      _openBottomSheet();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 26, 0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: Colors.deepPurpleAccent,
          ),
        ),
        color: Colors.deepPurpleAccent.withOpacity(0.07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (text) => contentBodyProvider.updateCounter(),
                  onEditingComplete: () => widget.quoteEnteredAddText(),
                  focusNode: widget.focusNode,
                  autofocus: widget.isFocus,
                  scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                  autocorrect: true,
                  autofillHints: ['versify'],
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: widget.quoteController,
                  cursorColor: Colors.teal,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  cursorHeight: 17.5,
                  textAlign: TextAlign.start,
                  enableInteractiveSelection: true,
                  style: TextStyle(
                    color: _themeProvider.primaryTextColor.withOpacity(0.7),
                    fontSize: 15.5,
                    fontFamily: GoogleFonts.getFont('Philosopher').fontFamily,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    height: 1.35,
                  ),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: '" Your Quote "',
                    hintStyle: TextStyle(
                        color: _themeProvider.primaryTextColor.withOpacity(0.7),
                        fontSize: 15.5,
                        height: 1.35,
                        fontFamily:
                            GoogleFonts.getFont('Philosopher').fontFamily,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal),
                    labelStyle: TextStyle(
                        color: _themeProvider.primaryTextColor.withOpacity(0.7),
                        fontSize: 15.5,
                        height: 1.35,
                        fontFamily:
                            GoogleFonts.getFont('Philosopher').fontFamily,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 12, 8, 12),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      enableDrag: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return QuoteBottomSheet(updateVerse: updateVerse);
                      },
                    );
                  },
                  child: Container(
                    height: 25,
                    margin: EdgeInsets.fromLTRB(6, 0, 0, 12),
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurpleAccent,
                        ),
                        child: Text(
                          widget.titleController.text != ''
                              ? widget.titleController.text
                              : _quoteTitle ?? 'Quote',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xfffffcfe),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.format_quote,
            color: Colors.deepPurpleAccent.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
