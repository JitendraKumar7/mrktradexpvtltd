import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../base/libraryExport.dart';

class AdminLinkUserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminLinkUserState();
}

class _AdminLinkUserState extends State<AdminLinkUserScreen> {
  List<Map> _list;
  List<Map> search = List<Map>();
  // List<ProductDetails> mainDataList = List<ProductDetails>();
  // List<CartSummery> cart = List<CartSummery>();
  // List<ProductDetails> products;
  @override
  void initState() {
    super.initState();

    ApiAdmin().getLinkUserList().then((value) => {
      setState(() {
        Map<String, dynamic> response = value.data;




        _list = List<Map>();
        if (response['status'] == '200') {
          response['result'].forEach((value) {
            _list.add(value);
          });
        }
        search.addAll(_list);
        print('assdf$search');
        print('Dio Response $response');
      }),
    });
  }
  Widget appBarTitle = new Text("Link Users");

  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['Name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['Name']} == ${value} ');
          _list.add(item);
        }
      });

    });



  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title:appBarTitle,
          actions: <Widget>[
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle =   new TextFormField(
                    autofocus: false,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Search Here...',
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  );}
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text('Link Users');
                }


              });
            } ,),],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),

        ),
        body: Column(children: <Widget>[

          Expanded(
            child:_list == null
                ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
                : _list.isEmpty
                ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:Center(
                heightFactor:  MediaQuery.of(context).size.height-0,
                widthFactor:   MediaQuery.of(context).size.width-0,
                child:Image(image: AssetImage('images/nodatafound.png'),
                ),
              ),
            )
                :ListView(
                children: _list.map((item) {
                  Map profile;
                  profile = Map();

                  profile['userid'] = item['user_id'];
                  profile['Konnectid'] = item['link_user_konnect_id'];
                  profile['Firstname'] = item['first_name'];
                  profile['Email'] = item['email'];
                  profile['phnno'] = item['phonenumber'];
                  profile['password'] = item['password'];
                  profile['Image'] = item['image'];

                  print(item['email']);


                  Widget myPopMenu() {
                    return PopupMenuButton(
                        onSelected: (value) {
                          if(value==1){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AdminLinkPartyMasterScreen(id: profile),
                              ),
                            );
                          }
                          else if(value==2){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AdminLinkActivityScreen(id: profile),
                              ),
                            );
                          }else if(value==3){

                          }else if(value==4){

                          }else if(value==5){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AdminLinkUserViewScreen(id: profile),
                              ),
                            );
                          }else if(value==6){

                          }


                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                    child:Icon(Icons.business,color: Colors.teal,),
                                  ),
                                  Text('Party List')
                                ],
                              )),
                          PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                    child: Icon(Icons.local_activity,color: Colors.blue,),
                                  ),
                                  Text('Activity List')
                                ],
                              )),
                          PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                    child: Icon(Icons.insert_drive_file,color: Colors.brown,),
                                  ),
                                  Text('Expense Report')
                                ],
                              )),
                          PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                    child: Icon(Icons.calendar_today,color:Colors.blueAccent),
                                  ),
                                  Text('Calendar',)
                                ],
                              )),
                          PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                    child: Icon(Icons.check_circle_outline,color: Colors.green,),
                                  ),
                                  Text('Check I/O',)
                                ],
                              )),
                          PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                    child: Icon(Icons.location_on_outlined,color: Colors.red,),
                                  ),
                                  Text('Location')
                                ],
                              )),
                        ]);
                  }


                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AdminLinkUserViewScreen(id: profile),
                            ),
                          );
                        },

                        title: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('${ item['first_name'].toString().toUpperCase() }'
                             ?? 'Name Error',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 16))
                          ),
                        ),
                        trailing: myPopMenu(),
                        leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                  NetworkImage(item['image'])??Image.asset('images/iv_empty.png'),
                            backgroundColor: Colors.black26,
                  ),
                        subtitle:Text(profile['phnno'] ?? '',style: (TextStyle(color:Colors.blue[600],fontWeight: FontWeight.bold,fontSize: 13))
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),


          )]));
  }
}
