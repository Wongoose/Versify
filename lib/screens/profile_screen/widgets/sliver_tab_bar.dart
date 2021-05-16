import 'package:flutter/material.dart';

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
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito'),
          unselectedLabelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontFamily: 'Nunito'),
          tabs: [
            Tab(
              child: Column(children: [
                Text(
                  '78',
                  style: TextStyle(
                      color: _tabIndex == 0
                          ? _theme.primaryColor
                          : Colors.black54),
                ),
                Text(
                  'Blogs',
                  style: TextStyle(
                    color: Colors.black87,
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
                          : Colors.black54),
                ),
                Text(
                  'Saved',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          _tabIndex == 1 ? FontWeight.bold : FontWeight.w500,
                      color: Colors.black),
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
                            : Colors.black54),
                  ),
                  Text(
                    'Badges',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
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
      child: new Container(
        height: _tabBar.preferredSize.height + 10,
        // decoration: BoxDecoration(
        //     border: Border(top: BorderSide(color: Colors.black38, width: 0.5))),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
