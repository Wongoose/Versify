import 'package:versify/providers/create_post/content_body_provider.dart';
import 'package:versify/providers/create_post/create_topics_provider.dart';
import 'package:versify/providers/create_post/suggestion_topics_provider.dart';
import 'package:versify/screens/create_screen/sub_screens/create_post.dart';
import 'package:versify/screens/create_screen/widgets/content_normal_text.dart';
import 'package:versify/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateBoarding extends StatefulWidget {
  final TextEditingController titleController;

  CreateBoarding({this.titleController});

  @override
  _CreateBoardingState createState() => _CreateBoardingState();
}

class _CreateBoardingState extends State<CreateBoarding> {
  final SuggestionTopicsProvider _suggestionTopicsProvider =
      SuggestionTopicsProvider();

  final CreateTopicsProvider _createTopicsProvider = CreateTopicsProvider();

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
    final AuthService _authService = Provider.of<AuthService>(context);

    contentBodyProvider =
        Provider.of<ContentBodyProvider>(context, listen: false);

    return ChangeNotifierProvider<SuggestionTopicsProvider>.value(
      value: _suggestionTopicsProvider,
      child: WillPopScope(
        onWillPop: () async {
          showDialogWhenCancel();
          return null;
        },
        child: Scaffold(
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
                onTap: () => showDialogWhenCancel(),
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
                    CupertinoPageRoute(
                      builder: (context) => CreatePost(
                        topicsProvider: _createTopicsProvider,

                        // contentBodyProvider: contentBodyProvider,

                        // writeController: writeController,
                        titleController: widget.titleController,
                      ),
                    ),
                  );
                },
                label: Text(''),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 25,
                  color: Color(0xffff548e),
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container()),
                  Align(
                    alignment: Alignment.center,
                    child: Image(
                      height: 120,
                      width: 120,
                      image: AssetImage('assets/images/shy.png'),
                    ),
                  ),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 270,
                      child: Text(
                        'Hi ${_authService.myUser != null ? _authService.myUser.username : 'friend'}, here are some popular suggestions that I\'ve picked for you!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 250,
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Popular',
                            style: TextStyle(
                                color: Color(0xffff548e),
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                height: 1.1),
                          ),
                          TextSpan(
                            text: ' suggestions',
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
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.fromLTRB(2, 0, 10, 0),
                    child: Text(
                      'FROM THE PEOPLE',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Consumer<SuggestionTopicsProvider>(
                      builder: (context, topicsProvider, _) {
                        return Wrap(
                          spacing: 15,
                          alignment: WrapAlignment.start,
                          children: topicsProvider.chipFromPeople
                              .map(
                                (chipData) => FilterChip(
                                    selected: chipData.checked,
                                    checkmarkColor: Colors.white,
                                    selectedColor: Color(0xffff548e),
                                    showCheckmark: false,
                                    onSelected: ((onSelected) {
                                      topicsProvider.uncheckAll();

                                      chipData.checked = onSelected;
                                      topicsProvider.updateChips();
                                      widget.titleController.text = onSelected
                                          ? chipData.topic + '...'
                                          : "";
                                    }),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: chipData.checked
                                            ? Color(0xffff548e)
                                            : Colors.black38,
                                        width: chipData.checked ? 1 : 0,
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    label: Container(
                                      constraints: BoxConstraints(
                                          minWidth: 0, maxWidth: 200),
                                      child: Text(
                                        chipData.topic + '...',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: chipData.checked
                                            ? Colors.white
                                            : Colors.black45)),
                              )
                              .toList()
                              .cast<Widget>(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 0.5),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      'FOR YOU',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Consumer<SuggestionTopicsProvider>(
                      builder: (context, topicsProvider, _) {
                        return Wrap(
                          spacing: 15,
                          alignment: WrapAlignment.start,
                          children: topicsProvider.chipForYou
                              .map(
                                (chipData) => FilterChip(
                                    selected: chipData.checked,
                                    checkmarkColor: Colors.white,
                                    selectedColor: Color(0xffff548e),
                                    showCheckmark: false,
                                    onSelected: ((onSelected) {
                                      topicsProvider.uncheckAll();
                                      chipData.checked = onSelected;
                                      topicsProvider.updateChips();
                                      widget.titleController.text = onSelected
                                          ? chipData.topic + '...'
                                          : "";
                                    }),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: chipData.checked
                                            ? Color(0xffff548e)
                                            : Colors.black38,
                                        width: chipData.checked ? 1 : 0,
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    label: Container(
                                      constraints: BoxConstraints(
                                          minWidth: 0,
                                          maxWidth: MediaQuery.of(context)
                                              .size
                                              .width),
                                      child: Text(chipData.topic + '...',
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: chipData.checked
                                            ? Colors.white
                                            : Colors.black45)),
                              )
                              .toList()
                              .cast<Widget>(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
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
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CreatePost(
                                topicsProvider: _createTopicsProvider,
                                titleController: widget.titleController,
                              ),
                            ),
                          );
                        },
                        child: Consumer<SuggestionTopicsProvider>(
                          builder: (context, topicsProvider, child) {
                            return Text(
                              topicsProvider.hasSelected ? 'next' : 'skip',
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
                ]),
          ),
        ),
      ),
    );
  }
}
