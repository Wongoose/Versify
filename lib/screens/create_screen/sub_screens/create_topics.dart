import 'package:versify/providers/create_post/content_body_provider.dart';
import 'package:versify/providers/create_post/create_topics_provider.dart';
import 'package:versify/screens/create_screen/sub_screens/create_post.dart';
import 'package:versify/screens/create_screen/widgets/content_normal_text.dart';
import 'package:versify/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTopics extends StatefulWidget {
  final TextEditingController titleController;

  CreateTopics({this.titleController});

  @override
  _CreateTopicsState createState() => _CreateTopicsState();
}

class _CreateTopicsState extends State<CreateTopics> {
  final CreateTopicsProvider _createTopicsProvider = CreateTopicsProvider();
  // final TextEditingController writeController = TextEditingController();
  //
  // final TextEditingController widget.titleController = TextEditingController();
  ContentBodyProvider contentBodyProvider;

  void showDialogWhenCancel() {
    if (widget.titleController.text != '' || contentBodyProvider.hasWritten) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  'Discard post?',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
                  alignment: Alignment.center,
                  width: 40,
                  child: Text(
                    'If you go back now, you will lose all your writing data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                // Divider(thickness: 0.5, height: 0),
                Container(
                  margin: EdgeInsets.all(0),
                  height: 60,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onPressed: () {
                      contentBodyProvider.clearAll();
                      Navigator.popUntil(context,
                          ModalRoute.withName(Navigator.defaultRouteName));
                    },
                    child: Text(
                      'Discard',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                      'Keep',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      contentBodyProvider.clearAll();

      Navigator.pop(context);
    }
  }

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('initState RUN');

      contentBodyProvider.clearAll();

      TextEditingController _temptextController = TextEditingController();
      FocusNode _tempTextFocusNode = FocusNode();

      contentBodyProvider.addText(
          widget: TextContent(
            textEditingController: _temptextController,
            focusNode: _tempTextFocusNode,
            isFocus: false,
            isFirst: true,
          ),
          textController: _temptextController,
          focusNode: _tempTextFocusNode,
          isFirst: true);
      // contentBodyProvider.selectToolbar(WidgetType.text,
      //     isRequestFocus: false, index: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final DatabaseService _databaseService =
    //     Provider.of<DatabaseService>(context);

    contentBodyProvider =
        Provider.of<ContentBodyProvider>(context, listen: false);

    print('Topics rebuilt');

    return WillPopScope(
      onWillPop: () {
        showDialogWhenCancel();
        return null;
      },
      child: ChangeNotifierProvider<CreateTopicsProvider>.value(
        value: _createTopicsProvider,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            titleSpacing: 5,
            title: Text(
              'Create',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            leading: GestureDetector(
                onTap: () {
                  showDialogWhenCancel();
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 25,
                )),
            actions: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePost(
                        // chipSnapshot: _snapshot,
                        topicsProvider: _createTopicsProvider,

                        // writeController: writeController,
                        // contentBodyProvider: contentBodyProvider,
                        titleController: widget.titleController,
                      ),
                    ),
                  );
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
                Expanded(
                  child: Image(
                    height: 120,
                    width: 120,
                    image: AssetImage('assets/images/shy.png'),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 250,
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'What',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              height: 1.1),
                        ),
                        TextSpan(
                          text: ' is\non Your Mind',
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
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: Consumer<CreateTopicsProvider>(
                    builder: (context, topicsProvider, _) {
                      return Wrap(
                        spacing: 15,
                        alignment: WrapAlignment.start,
                        children: topicsProvider.chipSnaps
                            .map(
                              (chipData) => FilterChip(
                                  selected: chipData.checked,
                                  checkmarkColor: Colors.white,
                                  selectedColor: Theme.of(context).primaryColor,
                                  showCheckmark: true,
                                  onSelected: ((onSelected) {
                                    chipData.checked = onSelected;
                                    topicsProvider.updateChips();
                                  }),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  label: Text(chipData.topic),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600,
                                      color: chipData.checked
                                          ? Colors.white
                                          : Theme.of(context).primaryColor)),
                            )
                            .toList()
                            .cast<Widget>(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => {},
                      label: Text(
                        'help',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      icon: Icon(
                        Icons.help_outline_rounded,
                        size: 14,
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatePost(
                              topicsProvider: _createTopicsProvider,

                              // contentBodyProvider: contentBodyProvider,

                              // writeController: writeController,
                              titleController: widget.titleController,
                            ),
                          ),
                        );
                      },
                      child: Consumer<CreateTopicsProvider>(
                        builder: (context, topicsProvider, child) {
                          return Text(
                            topicsProvider.hasSelected ? 'next' : 'later',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Nunito',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
