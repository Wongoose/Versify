import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ReportPostDialog extends StatefulWidget {
  final Feed feed;
  ReportPostDialog({this.feed});

  @override
  _ReportPostDialogState createState() => _ReportPostDialogState();
}

class _ReportPostDialogState extends State<ReportPostDialog> {
  final TextEditingController _textController = TextEditingController();

  Map<ReportFeed, bool> _checksMap = {
    ReportFeed.violence: false,
    ReportFeed.sensitive: false,
    ReportFeed.political: false,
    ReportFeed.adultContent: false,
    ReportFeed.language: false,
    ReportFeed.others: false,
  };

  bool _reason = false;
  bool _thankYou = false;
  bool _dialogLoading = false;

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SimpleDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            _thankYou ? 'Successful' : 'Report post',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: _thankYou ? Colors.blue : _themeProvider.primaryTextColor,
            ),
          ),
        ),
        titlePadding: EdgeInsets.fromLTRB(10, 25, 10, 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        children: [
          // SizedBox(height: 20),
          // Divider(thickness: 0.5, height: 0),
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
            alignment: Alignment.center,
            width: 60,
            child: _thankYou
                ? Text(
                    'Thank you for submitting your report. This post will be flagged for review immediately.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : !_reason
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _checksMap[ReportFeed.violence],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportFeed.violence] = value),
                                activeColor: _themeProvider.primaryTextColor
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() =>
                                        _checksMap[ReportFeed.violence] =
                                            !_checksMap[ReportFeed.violence]);
                                  },
                                  child: Text(
                                    'Violence/Graphic content',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _checksMap[ReportFeed.sensitive],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportFeed.sensitive] = value),
                                activeColor: _themeProvider.primaryTextColor
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() =>
                                        _checksMap[ReportFeed.sensitive] =
                                            !_checksMap[ReportFeed.sensitive]);
                                  },
                                  child: Text(
                                    'Sensitive Topic',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _checksMap[ReportFeed.political],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportFeed.political] = value),
                                activeColor: _themeProvider.primaryTextColor
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() =>
                                        _checksMap[ReportFeed.political] =
                                            !_checksMap[ReportFeed.political]);
                                  },
                                  child: Text(
                                    'Political content',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _checksMap[ReportFeed.adultContent],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportFeed.adultContent] =
                                        value),
                                activeColor: _themeProvider.primaryTextColor
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() => _checksMap[
                                            ReportFeed.adultContent] =
                                        !_checksMap[ReportFeed.adultContent]);
                                  },
                                  child: Text(
                                    'Adult/inappropriate content',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _checksMap[ReportFeed.language],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportFeed.language] = value),
                                activeColor: _themeProvider.primaryTextColor
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() =>
                                        _checksMap[ReportFeed.language] =
                                            !_checksMap[ReportFeed.language]);
                                  },
                                  child: Text(
                                    'Language misuse',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _checksMap[ReportFeed.others],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportFeed.others] = value),
                                activeColor: _themeProvider.primaryTextColor
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() =>
                                        _checksMap[ReportFeed.others] =
                                            !_checksMap[ReportFeed.others]);
                                  },
                                  child: Text(
                                    'Others',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What\'s wrong?',
                            style: TextStyle(
                              fontSize: 12,
                              color: _themeProvider.secondaryTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            autofocus: true,
                            controller: _textController,
                            maxLength: 300,
                            maxLines: null,
                            // keyboardType: TextInputType.multiline,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[\\\n]'))
                            ],
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (text) {
                              return text.contains(' ') ? '' : text;
                            },
                            buildCounter: (_,
                                {currentLength, maxLength, isFocused}) {
                              return Visibility(
                                visible: true,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${currentLength.toString()}/${maxLength.toString()}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: currentLength > maxLength
                                          ? Colors.red
                                          : _themeProvider.secondaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              // prefixText:
                              //     widget.editType == EditType.username ? '@ ' : '',

                              prefixStyle: TextStyle(
                                  color: _themeProvider.secondaryTextColor,
                                  fontSize: 15),
                              isDense: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: _themeProvider.primaryTextColor
                                        .withOpacity(0.26),
                                    width: 0.5),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: _themeProvider.primaryTextColor
                                        .withOpacity(0.26),
                                    width: 0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),

          // Divider(thickness: 0.5, height: 0),
          _thankYou
              ? Container(height: 20)
              : Container(
                  margin: EdgeInsets.all(0),
                  height: 60,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onPressed: () {
                      if (_reason) {
                        setState(() => _dialogLoading = true);
                        List<ReportFeed> _reportList = [];

                        _checksMap.forEach((key, value) {
                          if (value == true) {
                            _reportList.add(key);
                          }
                        });
                        print(_reportList);
                        _databaseService
                            .reportPost(
                          feed: widget.feed,
                          reportEnumList: _reportList,
                          description: _textController.text,
                        )
                            .then((_) {
                          setState(() {
                            _dialogLoading = false;
                            _thankYou = true;
                          });
                        });
                      } else {
                        setState(() => _reason = true);
                      }
                    },
                    child: Visibility(
                      visible: !_dialogLoading,
                      child: Text(
                        _reason ? 'Confirm' : 'Report',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      replacement: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                          strokeWidth: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
          Divider(thickness: 0.5, height: 0),
          Container(
            margin: EdgeInsets.all(0),
            height: 60,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                _thankYou ? 'Okay' : 'Cancel',
                style: TextStyle(
                  color: _themeProvider.secondaryTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
