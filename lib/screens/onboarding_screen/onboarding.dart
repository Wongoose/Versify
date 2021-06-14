import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:versify/models/onboarding_page_model.dart';

class OnBoarding extends StatefulWidget {
  final Function completeBoarding;

  OnBoarding({this.completeBoarding});

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<PageModel> onboardingPagesList = [
    PageModel(
      imagePath: 'assets/images/versify_logo_circle.png',
      title: 'Welcome,',
      info:
          'This is where blogging begins. Explore and express your identity in Christ with Versify!',
    ),
    PageModel(
      imagePath: 'assets/images/relatable.png',
      title: 'Relatable',
      info:
          'Feel understood. Feel relatable. Find your personalized feed of blogs that you need daily!',
    ),
    PageModel(
      imagePath: 'assets/images/community.png',
      title: 'Community',
      info:
          'A brand new Social Media with Christ centered. A space for you to be a part of this social community!',
    ),
    PageModel(
      imagePath: 'assets/images/get-started.png',
      title: 'Get Started!',
      info:
          'We can\'t wait for you to join us and share the wonders of God through blogging!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFffdee9),
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFffdee9),
        appBar: null,
        body: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: onboardingPagesList.length,
          itemBuilder: (context, index) {
            PageModel _page = onboardingPagesList[index];

            return Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Container()),
                  Align(
                    alignment: Alignment.center,
                    child:
                        Image.asset(_page.imagePath, height: 280, width: 280),
                  ),
                  Expanded(child: Container()),
                  Text(
                    _page.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    _page.info,
                    style: TextStyle(
                      height: 1.4,
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // Expanded(child: Container()),
                ],
              ),
            );
          },
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Color(0xFFffdee9),
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            height: 150,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: onboardingPagesList
                      .map((pageModel) {
                        bool isFocus = onboardingPagesList.indexOf(pageModel) ==
                            _currentIndex;
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          height: 2,
                          width: 25,
                          color: isFocus ? Colors.black87 : Colors.black45,
                        );
                      })
                      .toList()
                      .cast<Widget>(),
                ),
                GestureDetector(
                  onTap: () {
                    if (_currentIndex == 3) {
                      widget.completeBoarding();
                    } else {
                      _pageController.animateToPage(_currentIndex + 1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
                    decoration: BoxDecoration(
                      color: _currentIndex == 3
                          ? Color(0xFF61c0bf)
                          : Colors.black45,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: FittedBox(
                      child: Text(
                        _currentIndex == 3 ? 'Get Started' : 'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
