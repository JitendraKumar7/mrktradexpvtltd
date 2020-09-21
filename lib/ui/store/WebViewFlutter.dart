import '../../ui/base/libraryExport.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewFlutter extends StatefulWidget {
  final String paymentCode;

  const WebViewFlutter({Key key, @required this.paymentCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebViewFlutterState();
}

class _WebViewFlutterState extends State<WebViewFlutter> {
  WebViewController _controller;

  _loadHtmlFromAssets(String paymentCode) async {
    String fileText =
        '<form><script src="https://cdn.razorpay.com/static/widget/payment-button.js" data-payment_button_id="pl_FQBhTsmRHDJkZv"> </script> </form>';
    _controller.loadUrl(
      Uri.dataFromString(
        paymentCode,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets(widget.paymentCode);
          },
          onPageStarted: (String url) {
            print('Payment Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Payment Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }
}
