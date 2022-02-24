
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewScreen extends StatefulWidget {
  final int index;

  WebViewScreen({required this.index});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
 /* @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }*/

  List urls=[
    'https://www.facebook.com/',
    'https://www.twitter.com/',
    'https://www.instagram.com/',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: urls[widget.index],
        ),
      ),
    );
  }
}
