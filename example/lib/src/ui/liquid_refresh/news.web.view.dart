import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  final String link;
  const NewsWebView({super.key, required this.link});

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  WebViewController webViewController = WebViewController();
  @override
  void initState() {
    super.initState();
    webViewController..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },

        ),
      )
      ..loadRequest(Uri.parse(widget.link));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        body:WebViewWidget(controller:  webViewController) ,
      ),
    );
  }
}