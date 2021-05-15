import 'package:versify/screens/feed_screen/create_post_sub/widgets/feature_quote.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuoteBottomSheet extends StatefulWidget {
  final Function updateVerse;

  QuoteBottomSheet({this.updateVerse});

  @override
  _QuoteBottomSheetState createState() => _QuoteBottomSheetState();
}

class _QuoteBottomSheetState extends State<QuoteBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String responseString = '';
  List _listResultsMap = []; //List<Map<String, String>>
  bool _isLoading = false;

  Future<void> getSearchKeywordUrl(String searchText) async {
    print('Seaerch Keyword RAN');

    Uri url = Uri.parse(
        'http://api.biblia.com/v1/bible/search/LEB.txt?query=${searchText.trim().toLowerCase()}&mode=verse&start=0&limit=20&key=6e06343520f70dc72bc1caa13a9fe041');
    http.Response response = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    setState(() {
      List _tempJson = json.decode(response.body)['results'];
      _listResultsMap = _tempJson;
      _tempJson.map((map) {
        return map['title'] + ' - ' + map['preview'];
      }).forEach(print);

      _isLoading = false;
    });
    // print(_tempJson);
  }

  Future<void> getSearchVerseUrl(String searchText) async {
    print('Search Verse URL RAN');
    Uri url = Uri.parse(
        'https://api.biblia.com/v1/bible/content/LEB.txt.txt?passage=${searchText.trim().toLowerCase()}&callback=myCallbackFunction&key=6e06343520f70dc72bc1caa13a9fe041');
    http.Response response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    setState(() {
      _isLoading = false;
      _listResultsMap
          .add({'title': searchText, 'preview': response.body.toString()});
    });

    // if (json.decode(response.body)['valid'] == true) {
    //   print('Json Decode is Valid!');
    //   isValidPhone = true;
    // } else {
    //   isValidPhone = false;
    // }
  }

  Future<dynamic> _checkSearchBarHasVerse(String searchText) async {
    String urlText = searchText.trim().replaceAll(' ', '%20');
    print(urlText);

    Uri url = Uri.parse(
        'http://api.biblia.com/v1/bible/scan.txt?text=$urlText&key=6e06343520f70dc72bc1caa13a9fe041');
    http.Response response = await http.get(url);
    print(response.body);
    List _tempJson = json.decode(response.body)['results'];

    if (_tempJson.isEmpty) {
      print('Do not have verse in search');

      return false;
    } else {
      return _tempJson.first['passage'].toString();
    }
  }

  Future<void> searchEnter({
    String searchText,
  }) async {
    _listResultsMap.clear();

    searchText = searchText[0].toUpperCase() +
        searchText.characters.getRange(1, searchText.length).toString();
    print('Make initial Capital: ' + searchText);

    await _checkSearchBarHasVerse(searchText).then((result) async {
      if (result == false) {
        //no verse
        await getSearchKeywordUrl(searchText);
      } else if ((result as String).isNotEmpty) {
        await getSearchVerseUrl(result.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
              // height: MediaQuery.of(context).size.height * 0.48,
              height: 600,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, -0.5),
                    blurRadius: 5,
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPersistentHeader(
                      floating: true,
                      pinned: false,
                      delegate: _SliverTitleBarDelegate(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Search by verse/keyword',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 320,
                                    child: TextFormField(
                                      // scrollPadding:
                                      //     EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      autofocus: true,
                                      focusNode: _searchNode,
                                      controller: _searchController,
                                      maxLength: 30,
                                      // keyboardType: TextInputType.multiline,
                                      onFieldSubmitted: (searchText) {
                                        if (searchText.length > 1) {
                                          setState(() => _isLoading = true);
                                          searchEnter(searchText: searchText);
                                          // getSearchKeywordUrl(searchText);
                                        }
                                      },
                                      cursorColor: Color(0xffff548e),
                                      validator: (text) {
                                        return text.contains(' ') ? '' : text;
                                      },
                                      textInputAction: TextInputAction.search,
                                      buildCounter: (_,
                                          {currentLength,
                                          maxLength,
                                          isFocused}) {
                                        return Visibility(
                                          visible: false,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${currentLength.toString()}/${maxLength.toString()}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: currentLength > maxLength
                                                    ? Colors.red
                                                    : Colors.black54,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        prefixStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15),
                                        isDense: true,
                                        hintText: 'e.g. John 3:16, love, hope',
                                        hintStyle: TextStyle(
                                            color: Colors.black26,
                                            fontSize: 15),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 0.5),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_searchController.text.length > 1) {
                                        setState(() => _isLoading = true);
                                        searchEnter(
                                            searchText: _searchController.text);

                                        // getSearchKeywordUrl(
                                        //     _searchController.text);
                                      }
                                      _searchNode.unfocus();
                                    },
                                    child: Icon(Icons.search,
                                        color: _searchNode.hasFocus
                                            ? Color(0xffff548e)
                                            : Colors.black45),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        isSearch: true,
                      ),
                    ),
                    SliverPersistentHeader(
                      floating: false,
                      pinned: true,
                      delegate: _SliverTitleBarDelegate(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Text(
                            'Results (${_listResultsMap.length})',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        isSearch: false,
                      ),
                    ),

                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      sliver: _isLoading
                          ? SliverToBoxAdapter(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0.5)))
                          : _listResultsMap.isEmpty
                              ? SliverToBoxAdapter(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No results',
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 12),
                                    ),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildListDelegate(
                                    _listResultsMap
                                        .map((map) {
                                          return GestureDetector(
                                            onTap: () {
                                              widget.updateVerse(
                                                  topic: map['title'],
                                                  verse: map['preview']);
                                              Navigator.pop(context);
                                            },
                                            child: FeatureQuote(
                                              topic: map['title'],
                                              value: map['preview'],
                                            ),
                                          );
                                        })
                                        .toList()
                                        .cast<Widget>(),
                                  ),
                                ),
                    )
                    // SliverToBoxAdapter(
                    //   child: _listResultsMap.isEmpty
                    //       ? Align(
                    //           alignment: Alignment.center,
                    //           child: CircularProgressIndicator(
                    //             strokeWidth: 0.5,
                    //           ))
                    //       : Expanded(
                    //           child: ListView.builder(
                    //               itemCount: _listResultsMap.length,
                    //               itemBuilder: (context, index) {
                    //                 return FeatureQuote(
                    //                   topic: _listResultsMap[index]['title'],
                    //                   value: _listResultsMap[index]['preview'],
                    //                 );
                    //               }),
                    //         ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, offset: Offset(0, 0.5))
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose verse',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.clear_rounded)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTitleBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTitleBarDelegate({this.title, this.isSearch});

  final Widget title;
  final bool isSearch;
  @override
  double get minExtent => isSearch ? 85 : 55;
  @override
  double get maxExtent => isSearch ? 85 : 55;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BottomAppBar(
      elevation: shrinkOffset == 0
          ? 0
          : isSearch
              ? 0
              : 0.5,
      child: new Container(
        alignment: Alignment.centerLeft,
        // decoration: BoxDecoration(
        //     border: Border(top: BorderSide(color: Colors.black38, width: 0.5))),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: Colors.white,
        child: title,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTitleBarDelegate oldDelegate) {
    return true;
  }
}
