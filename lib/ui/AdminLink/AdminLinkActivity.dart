import 'package:mrktradexpvtltd/ui/AdminLinkView/AdminLinkActivityView.dart';

import '../base/libraryExport.dart';


class AdminLinkActivityScreen extends StatefulWidget {
  Map id;


  AdminLinkActivityScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminLinkActivityState();
}

class _AdminLinkActivityState extends State<AdminLinkActivityScreen> {
  List<Map> _list;
  List<Map> search = List<Map>();
  // List<ProductDetails> mainDataList = List<ProductDetails>();
  // List<CartSummery> cart = List<CartSummery>();
  // List<ProductDetails> products;
  @override
  void initState() {
    super.initState();
    String LinkuserID=widget.id['userid'].toString();

    ApiAdmin(). getkompassProActivityDetails(LinkuserID).then((value) => {
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
  Widget appBarTitle = new Text(" Activitys");
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
                  this.appBarTitle = new Text('Party Master');
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
              child: Center(
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


                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AdminLinkActivityViewScreen (id:  profile),
                            ),
                          );
                        },
                        title: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(item['customer_name'].toString().toUpperCase() ?? 'Name Error',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 16))
                          ),
                        ),

                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 22,vertical: 4),child:Row( crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(child: InkWell(
                            child:Row(children: [   Icon(Icons.location_on,color: Colors.redAccent,),Text(
                              item['poa'],
                              style: (TextStyle(
                                  fontSize: 14,
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold)),
                            ),],),


                          )),
                          Text(
                            item['date_time'].toString().toUpperCase(),
                            style: (TextStyle(fontSize: 12)),
                          ),

                        ],),),
                      Divider(),
                    ],
                  );
                }).toList()),


          )]));
  }
}
