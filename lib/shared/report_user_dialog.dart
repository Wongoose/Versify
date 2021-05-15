import 'package:versify/models/user_model.dart';
import 'package:versify/services/database.dart';
import 'package:versify/services/profile_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ReportUserDialog extends StatefulWidget {
  final MyUser user;
  ReportUserDialog({this.user});

  @override
  _ReportPostDUsergState createState() => _ReportPostDUsergState();
}

class _ReportPostDUsergState extends State<ReportUserDialog> {
  final TextEditingController _textController = TextEditingController();

  Map<ReportUser, bool> _checksMap = {
    ReportUser.offTopic: false,
    ReportUser.copyAccount: false,
    ReportUser.disrespectful: false,
    ReportUser.others: false,
  };

  bool _reason = false;
  bool _thankYou = false;
  bool _dialogLoading = false;

  @override
  Widget build(BuildContext context) {
    final ProfileDBService _profileDBService =
        Provider.of<ProfileDBService>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SimpleDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            _thankYou ? 'Successful' : 'Report user',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: _thankYou ? Colors.blue : Colors.redAccent,
            ),
          ),
        ),
        titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                    'Thank you for submitting your report. This user will be flagged for review immediately.',
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
                                value: _checksMap[ReportUser.offTopic],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportUser.offTopic] = value),
                                activeColor: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() =>
                                        _checksMap[ReportUser.offTopic] =
                                            !_checksMap[ReportUser.offTopic]);
                                  },
                                  child: Text(
                                    'Off-topic content',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
                                value: _checksMap[ReportUser.disrespectful],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportUser.disrespectful] =
                                        value),
                                activeColor: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() => _checksMap[
                                            ReportUser.disrespectful] =
                                        !_checksMap[ReportUser.disrespectful]);
                                  },
                                  child: Text(
                                    'Disrespectful content',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
                                value: _checksMap[ReportUser.copyAccount],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportUser.copyAccount] = value),
                                activeColor: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() => _checksMap[
                                            ReportUser.copyAccount] =
                                        !_checksMap[ReportUser.copyAccount]);
                                  },
                                  child: Text(
                                    'Pretending to be another user',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
                                value: _checksMap[ReportUser.others],
                                onChanged: (value) => setState(() =>
                                    _checksMap[ReportUser.others] = value),
                                activeColor: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() =>
                                        _checksMap[ReportUser.others] =
                                            !_checksMap[ReportUser.others]);
                                  },
                                  child: Text(
                                    'Others',
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
                              color: Colors.black45,
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
                            cursorColor: Color(0xffff548e),
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
                                          : Colors.black54,
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
                                  color: Colors.black45, fontSize: 15),
                              isDense: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 0.5),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 0.5),
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
                        List<ReportUser> _reportList = [];

                        _checksMap.forEach((key, value) {
                          if (value == true) {
                            _reportList.add(key);
                          }
                        });
                        print(_reportList);
                        _profileDBService
                            .reportUser(
                          user: widget.user,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      replacement: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
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
                  color: Colors.black45,
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
