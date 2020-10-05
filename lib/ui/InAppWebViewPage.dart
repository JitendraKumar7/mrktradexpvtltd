import 'base/libraryExport.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const InAppWebViewPage(
      {Key key, this.title = 'Video Conferencing', this.url = ''})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController _controller;

  @override
  void initState() {
    super.initState();
    initPayload();
  }

  initPayload() async {
    if (widget.url?.isEmpty ?? true) {
      getVideoConferencing();
    } else {
      var microphone = await Permission.microphone.request();
      var camera = await Permission.camera.request();
      var granted = PermissionStatus.granted;
      if (microphone == granted && camera == granted) {
        print('InAppWebViewPage ${widget.url}');
        _controller.loadUrl(url: widget.url);
      }
    }
  }

  getVideoConferencing() async {
    var result = await ApiClient().getVideoConferencing();

    print(result.data);
    Map response = result.data;
    if (response['status'] == '200') {
      var microphone = await Permission.microphone.request();
      var camera = await Permission.camera.request();
      var granted = PermissionStatus.granted;
      if (microphone == granted && camera == granted) {
        final List<Map> _list = List();
        response['result'].forEach((value) {
          _list.add(value);
        });
        AwesomeDialog(
          context: context,
          body: Container(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Select',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                Divider(),
                ListView(
                  shrinkWrap: true,
                  children: _list.map((item) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        String url = item['video_url'];
                        _controller.loadUrl(url: url);
                        print('Video url $url');
                      },
                      title: Text(
                        item['room_name'],
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          btnCancelOnPress: () {
            Navigator.of(context).pop();
          },
          animType: AnimType.SCALE,
          btnCancelColor: Colors.grey,
          dismissOnTouchOutside: false,
          dialogType: DialogType.NO_HEADER,
        ).show();
      }
    }
    // Service not available
    else {
      _loadHtmlFromAssets('try again!');
      AwesomeDialog(
        context: context,
        btnCancelOnPress: () {
          Navigator.of(context).pop();
        },
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: Text('You have not subscribed to this service'),
      ).show();
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
        title: Text(widget.title),
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
            action: PermissionRequestResponseAction.GRANT,
          );
        },
      ),
    );
  }

  _loadHtmlFromAssets(String message) async {
    _controller.loadUrl(
        url: Uri.dataFromString(message,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString());
  }
}
