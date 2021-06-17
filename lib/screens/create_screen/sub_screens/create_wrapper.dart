import 'package:versify/providers/create_post/content_body_provider.dart';
import 'package:versify/screens/create_screen/sub_screens/create_boarding.dart';
import 'package:versify/screens/create_screen/sub_screens/create_topics.dart';
import 'package:versify/screens/create_screen/widgets/content_normal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CreateWrapper extends StatefulWidget {
  @override
  _CreateWrapperState createState() => _CreateWrapperState();
}

class _CreateWrapperState extends State<CreateWrapper> {
  bool knowWhatToWrite = false;
  bool _enableBot = true;
  final TextEditingController _titleController = TextEditingController();
  // ContentBodyProvider contentBodyProvider;

  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     print('initState RUN');

  //     contentBodyProvider.clearAll();

  //     TextEditingController _temptextController = TextEditingController();
  //     FocusNode _tempTextFocusNode = FocusNode();

  //     contentBodyProvider.addText(
  //         widget: TextContent(
  //           textEditingController: _temptextController,
  //           focusNode: _tempTextFocusNode,
  //           isFocus: false,
  //           isFirst: true,
  //         ),
  //         textController: _temptextController,
  //         focusNode: _tempTextFocusNode,
  //         isFirst: true);
  //     // contentBodyProvider.selectToolbar(WidgetType.text,
  //     //     isRequestFocus: false, index: 0);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // contentBodyProvider =
    //     Provider.of<ContentBodyProvider>(context, listen: false);
    return CreateBoarding(titleController: _titleController);
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          titleSpacing: 5,
          title: Text(
            'Create',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
              onTap: () => Navigator.popUntil(
                  context, ModalRoute.withName(Navigator.defaultRouteName)),
              child: Icon(
                Icons.clear_rounded,
                color: Colors.black,
                size: 28,
              )),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                if (knowWhatToWrite) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            CreateTopics(titleController: _titleController),
                      ));
                } else {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            CreateBoarding(titleController: _titleController),
                      ));
                }
              },
              label: Text(''),
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 250,
                  child: RichText(
                    maxLines: 2,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Already',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            height: 1.1),
                      ),
                      TextSpan(
                        text: ' know what to write?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            height: 1.1),
                      )
                    ]),
                  ),
                ),
              ),
              // SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(14, 30, 14, 25),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: !knowWhatToWrite
                                ? null
                                : BorderSide(color: Colors.black12),
                            elevation: knowWhatToWrite ? 0 : 15,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          onPressed: () {
                            if (knowWhatToWrite == true) {
                              setState(() {
                                knowWhatToWrite = false;
                                _enableBot = true;
                              });
                            }
                          },
                          child: Ink(
                            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                            decoration: BoxDecoration(
                                // color: Colors.pink,
                                gradient: LinearGradient(
                                  colors: knowWhatToWrite
                                      ? [Colors.white, Colors.white]
                                      : [Colors.pinkAccent, Colors.pink[200]],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: Container()),
                                Text(
                                  'No',
                                  style: TextStyle(
                                      color: knowWhatToWrite
                                          ? Colors.black45
                                          : Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Versify\'s writing bot will guide you',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: knowWhatToWrite
                                          ? Colors.black45
                                          : Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                                Expanded(child: Container()),
                                Icon(
                                  FontAwesomeIcons.pen,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: knowWhatToWrite
                                  ? null
                                  : BorderSide(color: Colors.black12),
                              elevation: knowWhatToWrite ? 15 : 0,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              primary: knowWhatToWrite
                                  ? Colors.pink[300]
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: () {
                              if (knowWhatToWrite == false) {
                                setState(() {
                                  knowWhatToWrite = true;
                                  _enableBot = false;
                                });
                              }
                            },
                            child: Ink(
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                              decoration: BoxDecoration(
                                  // color: Colors.pink,
                                  gradient: LinearGradient(
                                    colors: !knowWhatToWrite
                                        ? [Colors.white, Colors.white]
                                        : [Colors.pinkAccent, Colors.pink[200]],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: Container()),

                                  Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: knowWhatToWrite
                                            ? Colors.white
                                            : Colors.black45,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'We\'ll leave it to your creativity!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: knowWhatToWrite
                                            ? Colors.white
                                            : Colors.black45,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(
                                    FontAwesomeIcons.pen,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  // SizedBox(height: 15),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.pencilAlt,
                      size: 15,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Enable writing bot',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                    Switch(
                      value: _enableBot,
                      onChanged: (bool value) {
                        if (knowWhatToWrite) {
                          setState(() => _enableBot = value);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
