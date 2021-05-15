import 'package:versify/providers/bottom_nav_provider.dart';
import 'package:versify/screens/feed_screen/create_post_sub/create_topics.dart';
import 'package:versify/screens/feed_screen/create_post_sub/create_wrapper.dart';
import 'package:versify/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int pageIndex;
  final PageController controller;
  final ScrollController scrollController;
  // final bool show;
  // final BottomNavProvider bottomNavProvider;

  CustomBottomNavigationBar({
    this.pageIndex,
    this.controller,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    print('BOTTOM Nav BAR Rebuilt!');
    PageViewProvider pageViewProvider =
        Provider.of<PageViewProvider>(context, listen: true);
    DatabaseService _databaseService = Provider.of<DatabaseService>(context);

    return Consumer<BottomNavProvider>(
        builder: (context, bottomNavProvider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          pageViewProvider.pageIndex != 1
              ? SizedBox.shrink()
              : AnimatedBuilder(
                  animation: pageViewProvider,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 2020),
                      padding: EdgeInsets.all(15),
                      child: bottomNavProvider.show
                          ? FloatingActionButton.extended(
                              tooltip: 'Write your story!',
                              elevation: 2.0,
                              label: Text(
                                'Write',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              icon: Icon(
                                FontAwesomeIcons.penAlt,
                                size: 18,
                                color: Colors.white,
                              ),
                              backgroundColor: _theme.primaryColor,
                              onPressed: () => {
                                Navigator.push(context, CupertinoPageRoute(
                                  builder: (context) {
                                    return CreateWrapper();

                                    //   return CreateTopics(
                                    //       databaseService: _databaseService);
                                  },
                                )),
                                // _databaseService.dummyAddData(),
                                // print('FAB clicked!'),
                              },
                            )
                          : FloatingActionButton(
                              elevation: 2.0,
                              child: Icon(FontAwesomeIcons.penAlt,
                                  size: 18, color: Colors.white),
                              backgroundColor: _theme.primaryColor,
                              onPressed: () => {
                                Navigator.push(context, CupertinoPageRoute(
                                  builder: (context) {
                                    return CreateWrapper();
                                    // return CreateTopics(
                                    //   databaseService: _databaseService,
                                    // );
                                  },
                                )),
                                // _databaseService.dummyAddData(),
                              },
                            ),
                    );
                  }),
          AnimatedBuilder(
              animation: pageViewProvider,
              builder: (context, child) {
                return AnimatedContainer(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, -0.1),
                            blurRadius: 5)
                      ],
                      // border: Border(top: BorderSide(color: Colors.black12))
                    ),
                    height: bottomNavProvider != null
                        ? bottomNavProvider.show ||
                                pageViewProvider.pageIndex != 1
                            ? 55
                            : 0
                        : 55,
                    duration: Duration(milliseconds: 200),
                    child: BottomAppBar(
                      elevation: 1,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40, 2, 40, 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Expanded(
                            //   child: TextButton.icon(
                            //     style: TextButton.styleFrom(
                            //       primary: Colors.white,
                            //       padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            //       backgroundColor: Colors.white,
                            //     ),
                            //     onPressed: () => {
                            //       controller.animateToPage(
                            //         0,
                            //         duration: Duration(milliseconds: 300),
                            //         curve: Curves.easeInOut,
                            //       ),
                            //     },
                            //     icon: Icon(
                            //       pageViewProvider.pageIndex != 0
                            //           ? Icons.format_quote_rounded
                            //           : Icons.format_quote_rounded,
                            //       color: pageViewProvider.pageIndex != 0
                            //           ? Colors.black87
                            //           : _theme.primaryColor,
                            //       size: 33,
                            //     ),
                            //     label: Text(''),
                            //   ),
                            // ),
                            Expanded(
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () => {
                                  controller.animateToPage(
                                    1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                                },
                                label: Text(''),
                                icon: pageViewProvider.pageIndex != 1
                                    ? Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Icon(
                                          AntDesign.home,
                                          color: Colors.black87,
                                          size: 27,
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Icon(
                                          Entypo.home,
                                          color: _theme.primaryColor,
                                          size: 29,
                                        ),
                                      ),
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  backgroundColor: Colors.white,
                                ),
                                label: Text(''),
                                onPressed: () => {
                                  controller.animateToPage(
                                    2,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                                },
                                icon: Icon(
                                  pageViewProvider.pageIndex != 2
                                      ? Icons.person_outline_rounded
                                      : Icons.person_rounded,
                                  color: pageViewProvider.pageIndex != 2
                                      ? Colors.black87
                                      : _theme.primaryColor,
                                  size: 34,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              }),
        ],
      );
    });
  }
}
// child: Padding(
//                 padding: EdgeInsets.fromLTRB(25, 2, 25, 8),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Expanded(
//                       child: TextButton.icon(
//                         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                         onPressed: () => {
//                           controller.animateToPage(
//                             0,
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           ),
//                         },
//                         icon: Icon(
//                           bottomNavProvider.pageIndex != 0
//                               ? Icons.auto_stories
//                               : Icons.auto_stories,
//                           color:
//                               bottomNavProvider.pageIndex != 0 ? Colors.white : Colors.pinkAccent,
//                           size: 33,
//                         ),
//                         label: Text(''),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextButton.icon(
//                         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                         onPressed: () => {
//                           controller.animateToPage(
//                             1,
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           )
//                         },
//                         label: Text(''),
//                         icon: bottomNavProvider.pageIndex != 1
//                             ? Icon(
//                                 Icons.home_outlined,
//                                 color: Colors.white,
//                                 size: 32,
//                               )
//                             : Icon(
//                                 Icons.home,
//                                 color: Colors.pinkAccent,
//                                 size: 32,
//                               ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextButton.icon(
//                         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                         label: Text(''),
//                         onPressed: () => {
//                           controller.animateToPage(
//                             2,
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           )
//                         },
//                         icon: Icon(
//                           bottomNavProvider.pageIndex != 2
//                               ? Icons.account_circle_outlined
//                               : Icons.account_circle_sharp,
//                           color:
//                               bottomNavProvider.pageIndex != 2 ? Colors.white : Colors.pinkAccent,
//                           size: 32,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),

//  backgroundColor: Colors.black,
//                   type: BottomNavigationBarType.fixed,
//                   currentIndex: bottomNavProvider.pageIndex,
//                   unselectedItemColor: Colors.white24,
//                   selectedItemColor: Colors.pinkAccent,
//                   unselectedLabelStyle: TextStyle(color: Colors.white24),
//                   onTap: (int indexClicked) => {
//                     controller.animateToPage(
//                       indexClicked,
//                       duration: Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     )
//                   },
//                   items: [
//                     BottomNavigationBarItem(
//                       icon: Padding(
//                         padding: const EdgeInsets.all(1.0),
//                         child: Icon(
//                           FontAwesomeIcons.envelopeOpen,
//                           size: 20,
//                         ),
//                       ),
//                       label: 'Word',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Padding(
//                         padding: const EdgeInsets.all(2.0),
//                         child: Icon(
//                           FontAwesomeIcons.plus,
//                           size: 20,
//                         ),
//                       ),
//                       label: 'Feed',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(
//                         FontAwesomeIcons.user,
//                         size: 20,
//                       ),
//                       label: 'Me',
//                     ),

// ScrollBottomNavigationBar(
//       controller: scrollController,
//       backgroundColor: Colors.black,
//       elevation: 0,
//       unselectedItemColor: Colors.white,
//       type: BottomNavigationBarType.fixed,
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'hello',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'hello',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'hello',
//         )
//       ],
//     );
