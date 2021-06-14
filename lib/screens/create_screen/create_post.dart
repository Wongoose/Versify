import 'package:versify/models/content_widget.dart';
import 'package:versify/providers/create_post/content_body_provider.dart';
import 'package:versify/providers/create_post/create_topics_provider.dart';
import 'package:versify/screens/create_screen/review_post.dart';
import 'package:versify/screens/create_screen/widgets/content_normal_text.dart';
import 'package:versify/screens/create_screen/widgets/my_tags.dart';
import 'package:versify/screens/create_screen/widgets/create_body.dart';
import 'package:versify/screens/create_screen/widgets/quote_text.dart';
import 'package:versify/screens/create_screen/widgets/smart_text.dart';
import 'package:versify/screens/create_screen/widgets/toolBar.dart';
import 'package:versify/services/database.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CreateType { withBot, withoutBot }

class CreatePost extends StatefulWidget {
  final CreateTopicsProvider topicsProvider;
  final TextEditingController titleController;
  final CreateType createType;
  // final ContentBodyProvider contentBodyProvider;

  CreatePost({
    @required this.topicsProvider,
    // this.contentBodyProvider,
    this.titleController,
    this.createType,
  });

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final FocusNode _titleFocusNode = FocusNode();
  bool _loading = false;

  ContentBodyProvider contentBodyProvider;

  void requestFocusAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bool _isBodyReqFocus = widget.titleController.text != "";
      _isBodyReqFocus ? contentBodyProvider.refocusCurrent() : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Create Post has been built!');

    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context);

    contentBodyProvider =
        Provider.of<ContentBodyProvider>(context, listen: false);
    requestFocusAfterBuild();

    // allChips = [chip1, chip2, chip3, chip4, chip5, chip6, chip7];

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
          elevation: 1,
          backgroundColor: Colors.white,
          titleSpacing: 5,
          title: Text(
            'Create',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
                size: 25,
              )),
          actions: [
            new Builder(
              builder: (context) {
                return TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    backgroundColor: Colors.white,
                  ),
                  label: Text(''),
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                    color: Color(0xffff548e),
                  ),
                  onPressed: () async {
                    // setState(() => _loading = true);
                    bool _validTitle = false;
                    bool _validContent = false;

                    if (widget.titleController.text.length <= 10) {
                      _validTitle = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(widget.titleController.text == ''
                                ? "Please input your title"
                                : "Your title is too short")),
                        duration: Duration(seconds: 3),
                      ));
                    } else {
                      _validTitle = true;
                    }
                    if (!contentBodyProvider.validBodyLength) {
                      _validContent = false;
                      if (_validTitle) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Padding(
                              padding: EdgeInsets.all(8),
                              child:
                                  Text("Please write at least 250 characters")),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    } else {
                      _validContent = true;
                    }

                    if (_validContent && _validTitle) {
                      // await DatabaseService().createNewPost(
                      //     titleController.text, contentBodyProvider.allText,
                      //     tags: topicsProvider.chipSnaps
                      //         .map((chipData) =>
                      //             chipData.checked ? chipData.topic : null)
                      //         .toList());

                      List<Map<String, String>> _tempListMapContent = [];

                      contentBodyProvider.listOfContentWidgets
                          .forEach((contentWidget) {
                        switch (contentWidget.widgetType) {
                          case WidgetType.quote:
                            _tempListMapContent.add({
                              'type': 'quote',
                              'value': contentWidget.controller.text,
                            });
                            break;
                          case WidgetType.text:
                            _tempListMapContent.add({
                              'type': 'text',
                              'value': contentWidget.controller.text,
                            });
                            break;
                          case WidgetType.image:
                            break;
                          case WidgetType.delete:
                            break;
                        }
                      });
                      List _tags = widget.topicsProvider.chipSnaps
                          .map((chipData) =>
                              chipData.checked ? chipData.topic : null)
                          .toList();

                      List<String> _reformatTags =
                          _databaseService.reformatTags(_tags);

                      // await widget.databaseService
                      //     .createPostWithMap(
                      //       myUser: _authService.myUser,
                      //       title: widget.titleController.text,
                      //       listMapContent: _tempListMapContent,
                      //       content: contentBodyProvider.allText,
                      //       tags: widget.topicsProvider.chipSnaps
                      //           .map((chipData) =>
                      //               chipData.checked ? chipData.topic : null)
                      //           .toList(),
                      //     )
                      //     .then((_) => Navigator.popUntil(
                      //         context, ModalRoute.withName(widget.routeName)));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewPost(
                                tags: _reformatTags,
                                listMapContent: _tempListMapContent,
                                titleController: widget.titleController,
                                createTopicsProvider: widget.topicsProvider),
                          ));
                    }
                    // setState(() => _loading = false);
                  },
                );
              },
            ),
          ],
        ),
        body: ChangeNotifierProvider<CreateTopicsProvider>.value(
          value: widget.topicsProvider,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            ListView(
              addRepaintBoundaries: true,
              addAutomaticKeepAlives: true,
              cacheExtent: 3000,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
              children: [
                MyTags(),
                // Divider(
                //   thickness: 1,
                // ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 25, 0),
                  child: SmartTextField(
                    controller: widget.titleController,
                    controllerType: 'title',
                    isFocus: widget.titleController.text == "",
                    focusNode: _titleFocusNode,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 10),
                  child: ContentBody(
                    isFocus: widget.titleController.text != "",
                    // textEditingController: writeController,
                  ),
                ),
                Consumer<ContentBodyProvider>(
                  builder: (context, state, child) => Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        child: Text(
                          state.writeCounter.toString(),
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: CreateToolBar(),
            ),
            Visibility(
              visible: _loading,
              child: Align(
                alignment: Alignment.center,
                child: Loading(),
              ),
            ),
          ]),
        ),
      ),
    );

    // return Container(
    //     height: kToolbarHeight,
    //     padding: EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       border: Border.all(color: Colors.black12),
    //     ),
    //     child: Row(
    //       children: [
    //         Image(
    //           width: 50,
    //           image: state.writeCounter < 40
    //               ? AssetImage('assets/images/no.png')
    //               : state.writeCounter < 100
    //                   ? AssetImage('assets/images/shy.png')
    //                   : state.writeCounter < 200
    //                       ? AssetImage('assets/images/laugh.png')
    //                       : AssetImage('assets/images/fashion.png'),
    //         ),
    //         SizedBox(width: 5),
    //         Text(
    //           state.writeCounter < 40
    //               ? '  hmm . . . such empty 💭'
    //               : state.writeCounter < 100
    //                   ? 'great start! keep going dear! 😊'
    //                   : state.writeCounter < 200
    //                       ? 'wow! such interesting story . . . 😍'
    //                       : 'amazing! can\'t wait to post it! 😎',
    //           style: TextStyle(
    //               color: Colors.black38,
    //               fontSize: 12,
    //               fontWeight: FontWeight.w300),
    //         ),
    //       ],
    //     ));

    // floatingActionButton: Padding(
    //   padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
    //   child: FloatingActionButton.extended(
    //     backgroundColor: Colors.pinkAccent,
    //     foregroundColor: Colors.blueGrey[50],
    //     onPressed: null,
    //     label: Text('Add'),
    //     icon: Icon(Icons.landscape_rounded),
    //   ),

    // ),
  }
}

// Consumer<EditorProvider>(builder: (context, state, _) {
//   return GestureDetector(
//     onTap: () => {_titleFocusNode.requestFocus()},
//     child: Container(
//         padding: EdgeInsets.all(20),
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             SizedBox(height: 50),
//             Image(
//               width: 100,
//               image: state.writeCounter < 40
//                   ? AssetImage('assets/images/no.png')
//                   : state.writeCounter < 100
//                       ? AssetImage('assets/images/shy.png')
//                       : state.writeCounter < 200
//                           ? AssetImage(
//                               'assets/images/laugh.png')
//                           : AssetImage(
//                               'assets/images/fashion.png'),
//             ),
//             SizedBox(height: 15),
//             Text(
//               state.writeCounter < 40
//                   ? '  hmm . . . such empty 💭'
//                   : state.writeCounter < 100
//                       ? 'great start! keep going dear! 😊'
//                       : state.writeCounter < 200
//                           ? 'wow! such interesting story . . . 😍'
//                           : 'amazing! can\'t wait to post it! 😎',
//               style: TextStyle(
//                   color: Colors.black38,
//                   fontWeight: FontWeight.w300),
//             ),
//           ],
//         )),
//   );
// }),
