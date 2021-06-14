import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/screens/profile_screen/visit_profile_provider.dart';
import 'package:versify/screens/profile_screen/widgets/follow_action_bar.dart';
import 'package:versify/screens/profile_screen/widgets/sliver_tab_bar.dart';
// import 'package:versify/services/database.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/shared/loading.dart';

class DynamicLinkProfile extends StatefulWidget {
  final String userId;
  DynamicLinkProfile({this.userId});

  @override
  _DynamicLinkProfileState createState() => _DynamicLinkProfileState();
}

class _DynamicLinkProfileState extends State<DynamicLinkProfile> {
  final VisitProfileProvider _visitProfileProvider = VisitProfileProvider();
  MyUser _userProfile;

  void changeTab() {}

  void initState() {
    print('Dynamic Profile Init State');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileDBService()
          .getProfileData(profileUID: widget.userId)
          .then((profileData) {
        _visitProfileProvider.setUserProfile(_userProfile);
        setState(() => _userProfile = profileData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VisitProfileProvider>.value(
          value: _visitProfileProvider,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Text(
            _userProfile.username,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: _userProfile != null
            ? Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: DefaultTabController(
                  initialIndex: 0,
                  length: 3,
                  child: CustomScrollView(
                    // controller: _nestedMasterController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.all(0),
                          color: Colors.white,
                          // height: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 30),
                              Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(300),
                                  side: BorderSide(color: Colors.black12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(300),
                                  child: Image(
                                    fit: BoxFit.contain,
                                    width: 100,
                                    image: CachedNetworkImageProvider(
                                        _userProfile.profileImageUrl,
                                        cacheKey: _userProfile.userUID,
                                        scale: 0.5),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                '@${_userProfile.username}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 25),
                              ProfileActionBar(
                                  editProfileProvider: EditProfileProvider(),
                                  userProfile: _userProfile,
                                  visitProfile: true,
                                  profileDBService: ProfileDBService()),

                              SizedBox(height: 25),
                              SizedBox(
                                width: 300,
                                // height: 50,
                                child: Consumer<EditProfileProvider>(
                                  builder: (context, state, _) => Text(
                                    _userProfile.description ??
                                        'This user has no description',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              Divider(thickness: 0.3),
                              // SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                      TabBarSliver(changeTab: changeTab),
                      SliverFillRemaining(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Quick sign up to see content'),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // SliverToBoxAdapter(child: Text('No data')),
                      // SliverToBoxAdapter(
                      //   child: Builder(builder: (context) {
                      //     if (tabIndex == 0) {
                      //       return Consumer<EditProfileProvider>(
                      //         builder: (context, state, _) => ProfileBlogList2(
                      // nestedViewController: _nestedMasterController,
                      //           userProfile: _userProfile,
                      //           isFromPageView: !widget.bottomNavVisible,
                      //         ),
                      //       );
                      //     } else if (tabIndex == 1) {
                      //       return SingleChildScrollView(
                      //           key: PageStorageKey<String>('Saved'),
                      //           child: Table(
                      //             defaultColumnWidth: FlexColumnWidth(1.0),
                      //             children: [
                      //               TableRow(children: [
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //               ]),
                      //               TableRow(children: [
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //               ]),
                      //               TableRow(children: [
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //               ]),
                      //               TableRow(children: [
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //               ]),
                      //               TableRow(children: [
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //               ]),
                      //               TableRow(children: [
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //               ]),
                      //               TableRow(children: [
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //                 SavedCard(),
                      //               ]),
                      //             ],
                      //           ));
                      //     } else {
                      //       return BadgesTabDisplay();
                      //     }
                      //   }),
                      // ),
                    ],
                  ),
                ),
              )
            : Loading(),
      ),
    );
  }
}
