import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Talepler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
      ),
      )
      ..loadRequest(Uri.parse('https://www.youtube.com/'));
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Talepler Ekranı",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: WebViewWidget(controller: controller,),
        ),
      ),
    );
  }
}