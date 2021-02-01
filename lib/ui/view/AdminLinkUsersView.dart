import 'dart:io';

import '../base/libraryExport.dart';

class AdminLinkUserViewScreen extends StatefulWidget {
  Map id;

   AdminLinkUserViewScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminLinkUserViewState();
}

class _AdminLinkUserViewState extends State<AdminLinkUserViewScreen> {
  Widget _picture;
String firstname;
String email;
String Phn,pass;
String Image;


  void onTap() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('From where do you want to take the photo?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Gallery'),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      File image = await UtilsImage.getFromGallery();

                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Camera'),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      File image = await UtilsImage.getFromCamera();

                    },
                  )
                ],
              ),
            ),
          );
        });
    /*ProgressDialog dialog = ProgressDialog(context);
        ImagePicker()
            .getImage(
                source: ImageSource.gallery,
                imageQuality: 85,
                maxHeight: 512,
                maxWidth: 512)
            .then((pickedFile) => {
                  print('picked file path ${pickedFile.path}'),
                  dialog.show(),
                  ApiClient().uploadFile(pickedFile.path).then((value) => {
                        setState(() {
                          Map response = value.data;
                          _imagePath = response['result'];
                          profile['image'] = response['result'];
                          print('Upload File Result ${value.data}');
                          ApiClient()
                              .updatePartyMaster(profile)
                              .then((value) => {
                                    dialog.hide().then((hide) => {
                                          setState(() {
                                            result = null;
                                            loadProfile();
                                            print(value.data);
                                          })
                                        })
                                  });
                        })
                      }),
                });*/
  }

  @override
  void initState() {
    super.initState();
     firstname = widget.id['Firstname'];
    email=  widget.id['Email'] ;
     Phn= widget.id['phnno'];
     pass= widget.id['password'];
     Image= widget.id['Image'];
print('mapvalue${email}');
    setState(setProfile);
    //loadProfile();
  }

  void setProfile() {
    String _imagePath = widget.id == null ? '' : ''?? '';
    _picture = _imagePath.isEmpty
        ? Icon(
      Icons.person,
      size: 60,
    )
        : ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: FadeInImage.assetNetwork(
        width: 72,
        height: 72,
        image: _imagePath,
        placeholder: 'images/iv_empty.png',
      ),
    );
  }





  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child:ListView(
          padding: EdgeInsets.only(top: 24, bottom: 24),
          children: <Widget>[
          CircleAvatar(
          radius: 100.0,

          backgroundImage:
          NetworkImage('${Image}')?? AssetImage( 'images/iv_empty.png'),
          backgroundColor: Colors.black26,
        ),
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                Center(
                  child: Text(
                    'Activity Details',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
            Divider(height: 24),
            Row(children: <Widget>[
              Expanded(flex: 1, child: Text('Name')),
              Expanded(
                flex: 2,
                child: Text(
                  '${firstname}',
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                ),
              )
            ]),
            Divider(),
            Row(children: <Widget>[
              Expanded(flex: 1, child: Text('Email')),
              Expanded(
                flex: 2,
                child: Text(
                  '${email}',
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                ),
              )
            ]),
            Divider(),
            Row(children: <Widget>[
              Expanded(flex: 1, child: Text('Phone No.')),
              Expanded(
                flex: 2,
                child: Text(
                  '${Phn}',
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                ),
              )
            ]),
            Divider(),
            Row(children: <Widget>[
              Expanded(flex: 1, child: Text('Password')),
              Expanded(
                flex: 2,
                child: Text(
                  '${pass}',
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                ),
              )
            ]),


          ],),
    ));
  }
}
