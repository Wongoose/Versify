import 'package:versify/main.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/home/bottom_nav_provider.dart';
import 'package:versify/providers/feeds/feed_list_provider.dart';
import 'package:versify/providers/feeds/all_posts_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';
import 'package:versify/screens/feed_screen/widgets_feeds/feed_list_wrapper.dart';
import 'package:versify/screens/feed_screen/widgets_feeds/post_feed_widget.dart';
import 'package:versify/services/database.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ForYouFeedList extends StatefulWidget {
  final ScrollController feedListController;

  ForYouFeedList({this.feedListController});

  @override
  _ForYouFeedListState createState() => _ForYouFeedListState();
}

class _ForYouFeedListState extends State<ForYouFeedList> {
  //values
  Future<void> _future;

  bool _firstInit = true;
  bool isScrollingDown = false;
  double _prevScrollPosition = 0;
  Map<int, double> _dynamicItemExtentList = {};
  int _prevIndexFromPageView = 0;

  //providers
  RefreshFunc _refresh;
  DatabaseService _databaseService;
  FeedListProvider _feedListProvider;
  BottomNavProvider _bottomNavProvider;

  final List<Map<String, Color>> _colorScheme = [
    {
      //purple
      'primary': Color(0xFFcc99ff),
      'secondary': Color(0xFFefdaff),
    },
    {
      //biege
      'primary': Color(0xFFffcc99),
      'secondary': Color(0xFFffefda),
    },
    {
      //blue
      'primary': Color(0xFF99ccff),
      'secondary': Color(0xFFdaeaff),
    },
  ];
  // FeedTypeProvider _feedTypeProvider;
  // double _localExtent = 0;

  //controllers
  // ScrollController widget.feedListController =
  //     ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void scrollPositionAfterView(int index) {
    double _currentItemExtent = 0;
    for (var i = 0; i < index; i++) {
      _currentItemExtent += _dynamicItemExtentList[i];
    }
    print('Current Item Extent: ' + _currentItemExtent.toString());

    widget.feedListController.animateTo(_currentItemExtent - 50,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOutExpo);
  }

  _ForYouFeedListState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstInit = _feedListProvider.forYouFirstInit;
      if (_firstInit) {
        myWidgetState(true);
      } else {
        myWidgetState(false);
      }
    }); //purpose to get all providers
  }
  void myWidgetState(bool first) {
    if (first) {
      _firstInit = false;
      _feedListProvider.forYouFirstInit = false;
    }
    widget.feedListController.addListener(() {
      // bool isEnd = widget.feedListController.position.pixels ==
      //     widget.feedListController.position.maxScrollExtent;

      bool isStart = widget.feedListController.position.pixels == 0.0;
      _feedListProvider.forYouScrollPosition =
          widget.feedListController.position.pixels;

      if (isStart) {
        _bottomNavProvider.showBottomBar();
        // isScrollingDown = false;G
      }
      // ? widget.feedListController.position.pixels >= G
      //     widget.feedListController.position.maxScrollExtent

      if (widget.feedListController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _prevScrollPosition = widget.feedListController.position.pixels;
        isScrollingDown = true;

        _bottomNavProvider.hideBottomBar();
      }
      if (widget.feedListController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          if (_prevScrollPosition - widget.feedListController.position.pixels >
              50) {
            _prevScrollPosition = widget.feedListController.position.pixels;

            isScrollingDown = false;
            print('ForYou Feedlist before show bottom bar because scroll');
            _bottomNavProvider.showBottomBar();
          }
        }
      }
      // if (isEnd) {
      //   _future = _loadData();
      // }
    });

    // if (first) _future = _loadData();
    if (first) {
      _future = loadForYou();
    } else {
      _future = _dummyFuture();
    }
  }

  Future<void> loadForYou() async {
    print('load data RAN!');

    await _databaseService.getNewFeeds;

    _feedListProvider.callFuture();
  }

  Future<String> _dummyFuture() async {
    _feedListProvider.callFuture();
    return 'done';
  }

  // Future<void> initialScrollPosition() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (widget.feedListController.hasClients) {
  //       print('Animate Following COntroller start');
  //       widget.feedListController
  //           .jumpTo(_feedListProvider.forYouScrollPosition);
  //       print('Animate Following COntroller END');
  //     }
  //   });
  //   return null;
  // }

  //methods
  // Future<void> _loadData() async {
  //   print('load data RAN!');

  //   await _databaseService.getNewFeeds;

  //   _feedListProvider.callFuture();
  // }

  Future<void> _refreshData() async {
    // await _loadData().then((value) => setState(() {}));
  }

  AllPostsView _allPostsView;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: true);

    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    // _feedTypeProvider = Provider.of<FeedTypeProvider>(context, listen: false);
    _feedListProvider = Provider.of<FeedListProvider>(context, listen: true);
    _refresh = Provider.of<RefreshFunc>(context);
    _bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
    _allPostsView = Provider.of<AllPostsView>(context, listen: false);
    // final List<Feed> feeds = Provider.of<List<Feed>>(context);

    // initialScrollPosition();

    print('For You Feed Built');

    if (_future == null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 55),
        child: Loading(),
      );
    } else {
      if (_tutorialProvider.viewFirstPost) {
        //tutorial view first post
        _feedListProvider.insertForYouFeed(_welcomeFeed, 0);
        return SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              PostFeedWidget(
                  isWelcome: true,
                  isGrey: false,
                  index: 0,
                  feed: _feedListProvider.forYouData[0]),
              Stack(
                children: [
                  Column(
                    children: _feedListProvider.forYouData
                        .map((feed) {
                          int indexOfFeed =
                              _feedListProvider.forYouData.indexOf(feed);

                          return indexOfFeed == 0
                              ? SizedBox.shrink()
                              : PostFeedWidget(
                                  isWelcome: false,
                                  isGrey: true,
                                  index: indexOfFeed,
                                  feed: _feedListProvider
                                      .forYouData[indexOfFeed]);
                        })
                        .toList()
                        .cast<Widget>(),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Consumer<AllPostsView>(
          builder: (context, state, child) {
            if (widget.feedListController.hasClients == true &&
                _prevIndexFromPageView != state.forYouCurrentIndex) {
              if (state.allPostsViewCurrentFeedType == FeedType.forYou) {
                scrollPositionAfterView(state.forYouCurrentIndex);
                _prevIndexFromPageView = state.forYouCurrentIndex;
              }
            }

            return SmartRefresher(
              key: PageStorageKey<String>('forYouFeedList'),
              enablePullDown: true,
              enablePullUp: true,
              header: MaterialClassicHeader(
                height: 40,
                color: _theme.primaryColor,
                backgroundColor: Colors.white,
                distance: 50,
              ),
              physics: AlwaysScrollableScrollPhysics(),
              reverse: false,
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (_feedListProvider.noforYouData) {
                    body = Text('None left for today!');
                  } else if (mode == LoadStatus.idle) {
                    body = Text(
                      "",
                      style: TextStyle(color: Colors.black),
                    );
                  } else if (mode == LoadStatus.loading) {
                    body = SpinKitThreeBounce(
                      color: _theme.primaryColor,
                      size: 30,
                    );
                  } else if (mode == LoadStatus.failed) {
                    body = Text(
                      "Load Failed!Click retry!",
                      style: TextStyle(color: Colors.black),
                    );
                  } else if (mode == LoadStatus.canLoading) {
                    body =
                        SpinKitThreeBounce(color: Colors.pink[200], size: 30);
                  } else {
                    body = Text(
                      "No more Data",
                      style: TextStyle(color: Colors.black),
                    );
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              scrollController: widget.feedListController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.separated(
                primary: false,
                addAutomaticKeepAlives: true,
                itemCount: _feedListProvider.forYouData.length,
                scrollDirection: Axis.vertical,
                // controller: widget.feedListController,
                // physics: BouncingScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  int _colorIndex = 0;
                  int _nextIndex = index + 1;
                  int _nextColorIndex;

                  if (index > 2) {
                    _colorIndex = index % 3;
                  } else {
                    _colorIndex = index;
                  }
                  if (_nextIndex > 2) {
                    _nextColorIndex = _nextIndex % 3;
                  } else {
                    _nextColorIndex = _nextIndex;
                  }
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(5.5, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _colorScheme[_colorIndex]['primary'],
                            _colorScheme[_nextColorIndex]['primary']
                          ],
                        ),
                        color: _colorScheme[_colorIndex]['primary'],
                      ),
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  return SizeProviderWidget(
                    //when change between following and forYou may not render hence size is null
                    onChildSize: (size) {
                      print('Feed Widget height is: ' + size.height.toString());
                      _dynamicItemExtentList[index] = size.height;
                      // print(_dynamicItemExtentList);
                    },
                    child: PostFeedWidget(
                        isGrey: false,
                        isWelcome: false,
                        index: index,
                        feed: _feedListProvider.forYouData[index]),
                  );
                },
              ),
            );
          },
        );
      }
    }
  }
  //   return ListView.builder(
  //     itemCount: _feedListProvider.data.length,
  //     scrollDirection: Axis.vertical,
  //     controller: widget.feedListController,
  //     physics: BouncingScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return PostFeedWidget(
  //           index: index, feed: _feedListProvider.data[index]);
  //     },
  //   );
  // });

  void _onLoading() async {
    // monitor network fetch
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (_refresh != null) {
      print('Loading Ran');

      await loadForYou();

      // _refresh();

      _refreshController.loadComplete();
    }
  }

  Future<void> _onRefresh() async {
    print('Refresh Ran with postsView: ' + _allPostsView.toString());
    _allPostsView.forYouClearViews();
    _dynamicItemExtentList.clear();
    _feedListProvider.forYouDataClear();

    print('ForYou Views:' + _allPostsView.forYouViews.toString());

    await loadForYou();

    _refreshController.refreshCompleted();
  }

  Feed _welcomeFeed = Feed(
    userID: 'OuPlwP2MaSWrLQiKH78BYAy5Pj22',
    username: 'versify_wongoose',
    hasViewed: false,
    contentLength: 0,
    featuredTopic: 'New post!',
    featuredValue: null,
    giftLove: 0,
    giftBird: 0,
    title: 'Welcome to Versify',
    tags: ['#love30', '#peace30'],
    initLike: false,
    numberOfLikes: 1203,
    numberOfViews: 292999,
    listMapContent: [
      {
        'type': 'text',
        'value':
            'Hello brother, today is the only day that the world is like htisdoqiwjdoiwqjd oqiehd oiwefh owief oiwefjoiwejfoiwe jfoiwejfoiwe oifjwoefjweoif jweoi fjwoij foije oifj weoifj iowefj weoi fjiowe ofiw eoifjweoifjweoifj weoi fwoei fwio fweoif oie oi weoi fweoihf we fwei oi owei hfowi hfowie hfowi hwoi fhweoi fhweoif hw \nfwefwefwefwefwefwefwefwe\nfwefwefewfwefwfwefwefwef\nfwfwefwefwefwefwfwfwfwefwefwefweefwefwefw\wnfwefwefwfef w efw efw w ff wf\n wfwefwef w'
      }
    ],
    postedTimestamp: DateTime.now(),
  );
}

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({Key key, this.onChildSize, this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChildSize(context.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
