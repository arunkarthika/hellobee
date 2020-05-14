import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {

  final String text;
  final String webViewTitle;

  Webview({Key key,this.text,this.webViewTitle}) : super(key: key);

  WebViewTestState createState() => WebViewTestState(text: text,webViewTitle: webViewTitle);

}

class WebViewTestState extends State<Webview> {

  WebViewController _webViewController;

  final String text;
  final String webViewTitle;

  WebViewTestState({Key key, @required this.text,@required this.webViewTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(webViewTitle),
        ),
      body: WebView(
        initialUrl: text,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(text);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
