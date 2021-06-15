import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';

class TabBarSliver extends StatefulWidget {
  final Function changeTab;

  TabBarSliver({this.changeTab});

  @override
  _TabBarSliverState createState() => _TabBarSliverState();
}

class _TabBarSliverState extends State<TabBarSliver> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
        TabBar(
          isScrollable: false,
          indicatorPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (selectionIndex) {
            setState(() {
              _tabIndex = selectionIndex;
            });
            widget.changeTab(_tabIndex);
          },
          indicatorColor: _theme.primaryColor,
          labelPadding: EdgeInsets.symmetric(horizontal: 0),
          // labelColor: Colors.black,
          // unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(fontFamily: 'Nunito'),
          unselectedLabelStyle: TextStyle(fontFamily: 'Nunito'),
          tabs: [
            Tab(
              child: Column(children: [
                Text(
                  '78',
                  style: TextStyle(
                      color: _tabIndex == 0
                          ? _theme.primaryColor
                          : _themeProvider.secondaryTextColor),
                ),
                Text(
                  'Blogs',
                  style: TextStyle(
                    color: _themeProvider.primaryTextColor,
                    fontSize: 15,
                    fontWeight:
                        _tabIndex == 0 ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ]),
            ),
            Tab(
              child: Column(children: [
                Text(
                  '15',
                  style: TextStyle(
                      color: _tabIndex == 1
                          ? _theme.primaryColor
                          : _themeProvider.secondaryTextColor),
                ),
                Text(
                  'Saved',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          _tabIndex == 1 ? FontWeight.bold : FontWeight.w500,
                      color: _themeProvider.primaryTextColor),
                ),
              ]),
            ),
            Tab(
              child: Column(
                children: [
                  Text(
                    '8',
                    style: TextStyle(
                        color: _tabIndex == 2
                            ? _theme.primaryColor
                            : _themeProvider.secondaryTextColor),
                  ),
                  Text(
                    'Badges',
                    style: TextStyle(
                      fontSize: 15,
                      color: _themeProvider.primaryTextColor,
                      fontWeight:
                          _tabIndex == 2 ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        // updateTabBar: widget.updateTabBar,
      ),
      pinned: true,
      floating: false,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;
  // final Function updateTabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 10;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 10;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // if (shrinkOffset != 0) {
    //   updateTabBar(true);
    // } else {
    //   updateTabBar(false);
    // }
    return BottomAppBar(
      elevation: shrinkOffset == 0 ? 0.3 : 1,
      color: Theme.of(context).backgroundColor,
      child: new Container(
        height: _tabBar.preferredSize.height + 10,

        // decoration: BoxDecoration(
        //     border: Border(top: BorderSide(color: Colors.black38, width: 0.5))),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        color: Colors.transparent,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
