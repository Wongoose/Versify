import 'package:versify/main.dart';
import 'package:versify/providers/bottom_nav_provider.dart';
import 'package:versify/providers/feed_list_provider.dart';
import 'package:versify/providers/all_posts_provider.dart';
import 'package:versify/screens/feed_screen/feed_list_wrapper.dart';
import 'package:versify/screens/feed_screen/widgets/post_feed_widget.dart';
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
      //red
      'primary': Color(0xFFff699F),
      'secondary': Color(0xFFff89B2),
    },
    {
      //blue
      'primary': Color(0xFFa15ce2),
      'secondary': Color(0xFFa15ce2),
    },
    {
      //green
      'primary': Color(0xFF61C0BF),
      'secondary': Color(0xFF61C0BF),
    }
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

    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    // _feedTypeProvider = Provider.of<FeedTypeProvider>(context, listen: false);
    _feedListProvider = Provider.of<FeedListProvider>(context, listen: true);
    _refresh = Provider.of<RefreshFunc>(context);
    _bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
    _allPostsView = Provider.of<AllPostsView>(context, listen: false);
    // final List<Feed> feeds = Provider.of<List<Feed>>(context);

    // initialScrollPosition();

    print('For You Feed Built');

    return _future == null
        ? Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 55),
            child: Loading(),
          )

        // : FutureBuilder(
        //     future: _future,
        //     builder: (context, snapshot) {
        //       if (snapshot.hasError) print('Error listFeed: ${snapshot.error}');
        //       if (snapshot.connectionState == ConnectionState.done) {
        //         List<Feed> loadedFeeds = snapshot.data;

        : Consumer<AllPostsView>(
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
                        print(
                            'Feed Widget height is: ' + size.height.toString());
                        _dynamicItemExtentList[index] = size.height;
                        // print(_dynamicItemExtentList);
                      },
                      child: PostFeedWidget(
                          index: index,
                          feed: _feedListProvider.forYouData[index]),
                    );
                  },
                ),
              );
            },
          );
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
