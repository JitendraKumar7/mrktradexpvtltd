import 'base/libraryExport.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController _controller;

  @override
  void initState() {
    super.initState();
    getVideoConferencing();
  }

  getVideoConferencing() async {
    var microphone = await Permission.microphone.request();
    var camera = await Permission.camera.request();
    var granted = PermissionStatus.granted;

    if (microphone == granted && camera == granted) {
      ApiClient().getVideoConferencing().then((value) => {
        setState(() {
          print(value.data);
          Map response = value.data;
          if (response['status'] == '200') {
            var url = response['result']['video_url'];
            print('Video conference url $url');
            _controller.loadUrl(url: url);
          }
          // error
          else {
            _loadHtmlFromAssets('try again!');
          }
        }),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Video Conferencing'),
      ),
      body: InAppWebView(
          initialUrl: 'about:blank',
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
              debuggingEnabled: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            _controller = controller;
          },
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          }),
    );
  }

  _loadHtmlFromAssets(String message) async {
    _controller.loadUrl(
        url: Uri.dataFromString(message,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString());
  }
}
/*
https://kmb.daily.co/mrktradex

https://meo.co.in/meoApiPro/kmb_v1/index.php/getVideoConferencing

{
    "status": "200",
    "message": "success",
    "result": {
        "video_url": "https://kmb.daily.co/mrktradex"
    }
}

*/
