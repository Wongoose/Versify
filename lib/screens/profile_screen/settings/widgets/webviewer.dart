import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum WebViewerType { termsAndConditions, privacypolicy }

class SettingsWebViewer extends StatelessWidget {
  final WebViewerType webViewerType;
  final String webViewUrl;
  final Completer<WebViewController> _webViewController =
      Completer<WebViewController>();

  SettingsWebViewer({this.webViewerType, this.webViewUrl});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    print('SettingsWebViewer build');

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          webViewerType == WebViewerType.termsAndConditions
              ? 'Terms & Conditions'
              : 'Privacy Policy',
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w600,
            color: _themeProvider.primaryTextColor,
          ),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // popAccountSettings();
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: _themeProvider.primaryTextColor,
            size: 25,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: WebView(
          initialUrl:
              webViewUrl ?? 'https://versify.flycricket.io/privacy.html',
          onWebViewCreated: (WebViewController webViewController) {
            print('onWebViewCreated | Done');
            _webViewController.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains('google.com')) {
              print('External link prevented');
              return NavigationDecision.prevent;
            } else {
              print('Link allowed');
              return NavigationDecision.navigate;
            }
          },
        ),
      ),
    );
  }
}
