import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:mrktradexpvtltd/ui/view/LegerViewGST.dart';

import '../base/libraryExport.dart';

class AdminSalesOrderScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  const AdminSalesOrderScreen({Key key, this.konnectDetails}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminSalesOrderState();
}

class _AdminSalesOrderState extends State<AdminSalesOrderScreen> {
  ScrollController _scrollController= new ScrollController();
  List<Map> _list;
  List<Map> search = List<Map>();
  final Comment = TextEditingController();
  ProgressDialog pr;

  int valuepag=1;
fetch(){
  ApiAdmin().getSalesOrder(valuepag.toString()).then((value) => {
    setState(() {
      _list = List<Map>();
      Map<String, dynamic> response = value.data;
      if (response['status'] == '200') {
        response['result'].forEach((v) {
          _list.add(v);
        });
      }
      search.addAll(_list);
      print(response);
      print(_list.length);
    }),
  });
}

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        valuepag++;
        fetch();
        debugPrint("reach the top");
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if(valuepag>1){
        valuepag--;}
        fetch();
        debugPrint("reach the top");
      });
    }
  }
  @override
  void initState() {
    super.initState();
    fetch();
    _scrollController.addListener( _scrollListener);





  }
  @override
  void dispose(){
    _scrollController.dispose();
super.dispose();
  }

  onChanged(String value) {
    _list = List<Map>();
    search.forEach((item) {
      String q1 = item['firm_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())) {
          print('search item name ${item['firm_name']} == ${value} ');
          _list.add(item);
        }
      });
    });
  }

  Widget appBarTitle = new Text("Sales Orders");
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    String gfg = "Geeks-ForGeeks";
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    // Splitting each
    // character of the string
    print(gfg.split("-"));

    String _singleValue = "Text alignment right";

    int i = 0;
    List<String> _status = ["Confirmed", "Canceled", "Hold", "Dispatched"];

    String _verticalGroupValue ;

    // set up the buttons

    // set up the AlertDialog

    // show the dialog

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          centerTitle: true,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextFormField(
                      autofocus: false,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Search Here...',
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                      ),
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Sales Order");
                  }
                });
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: _list == null
                ? Container(
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: GFLoader(loaderColorOne: Colors.white),
                    ),
                  )
                : _list.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            'Empty',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : ListView(
              controller: _scrollController,
                        children: _list.map((item) {

                       // String ids = item['ledger_id'].toString();
                        Color color, addformcolor;
                        ShapeBorder ashape;
                        String viewledger;
                        String a = "";
                        List<dynamic>listbrd =item['btob_registration_details'];

                        if(listbrd!=null){
                          viewledger="ViewLeger";
                        }
                        int id = item['booking_id'];
                        String t = item['status']
                                .toString()
                                .split("-")
                                .first
                                .toLowerCase()
                                .trim(),
                            addform = item['add_from']
                                .toString()
                                .toLowerCase()
                                .trim();

                        if (addform == "admin") {
                          addformcolor = Colors.teal;
                        } else {
                          addformcolor = Colors.indigo;
                        }
                        if (t == "confirmed") {
                          color = Colors.blue;
                          ashape = new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0));
                        } else if (t == "hold") {
                          color = Colors.brown;
                          ashape = new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0));
                        } else if (t == "received") {
                          color = Colors.black;
                          ashape = new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          );
                        } else if (t == "canceled") {
                          color = Colors.red;
                        } else if (t == "dispatched") {
                          color = Colors.green;
                        }

                        return Container(
                            child: Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SalesOrderViewScreen(
                                      id: id.toString(),
                                    ),
                                  ),
                                );
                              },
                              trailing: (Expanded(
                                  child: Column(
                                children: [
                                  InkWell(

                                      onTap: () {
                                        if (t == "confirmed" ||
                                            t == "received" ||
                                            t == "hold") {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Change  Order Status",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                                content: Container(
                                                  height: 330,

                                                  child:SingleChildScrollView(
                                                    scrollDirection: Axis.vertical,
                                                  child:Container(height: 330,
                                                    child:
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width:200,
                                                        child:CustomRadioButton(

                                                 unSelectedColor: Theme.of(context).canvasColor,
                                                  buttonLables: [
                                                    "Confirmed",
                                                    "Cancelled",
                                                    "Hold",
                                                    "Dispatched"
                                                  ],
                                                  buttonValues: [
                                                    "Confirmed",
                                                    "Canceled",
                                                    "Hold",
                                                    "Dispatched"
                                                  ],
                                                          horizontal: true,
                                                          enableShape: true,
                                                  radioButtonValue: (value){
                                                    _verticalGroupValue=value;
                                                    print( _verticalGroupValue);
                                                  },
                                                  selectedColor: Theme.of(context).accentColor,
                                                ),),


                                                      SizedBox(
                                                        height: 0,
                                                      ),
                                                      TextFormField(
                                                        controller: Comment,
                                                        autofocus: true,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Comment',
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ))),
                                                actions: [
                                                  Center(child:RaisedButton(
                                                    textColor:Colors.white,
                                                    color: Colors.blue,
                                                    child: Text("Save"),
                                                    onPressed: () {
                                                      pr.show();
                                                      Future.delayed(Duration(
                                                              seconds: 2))
                                                          .then((value) {
                                                        pr
                                                            .hide()
                                                            .whenComplete(() {
                                                          ApiAdmin()
                                                              .changeOrderStatus(
                                                                  id,
                                                                  _verticalGroupValue,
                                                                  Comment.text)
                                                              .then((value) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Map response =
                                                                value.data;
                                                            if (response[
                                                                    'status'] ==
                                                                '200') {
                                                              setState(() {
                                                                print(
                                                                    'outputqwerty ${response}');
                                                              });

                                                              pr.show();
                                                              Future.delayed(
                                                                      Duration(
                                                                          seconds: 5))
                                                                  .then(
                                                                      (value) {
                                                                pr
                                                                    .hide()
                                                                    .whenComplete(
                                                                        () {
                                                                  ApiAdmin()
                                                                      .getSalesOrder(valuepag.toString())
                                                                      .then(
                                                                          (value) =>
                                                                              {
                                                                                setState(() {
                                                                                  _list = List<Map>();
                                                                                  _list.clear();
                                                                                  Map<String, dynamic> response = value.data;
                                                                                  if (response['status'] == '200') {
                                                                                    response['result'].forEach((v) {
                                                                                      _list.add(v);
                                                                                    });
                                                                                  }
                                                                                  search.addAll(_list);
                                                                                  print(response);
                                                                                }),
                                                                              });
                                                                });
                                                              });
                                                            }
                                                          });
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  )],
                                              );
                                            },
                                          );
                                        }
                                      },



                                      child: Container(
                                        height: 50,
                                          width: 90,
                                          child: Column(
                                        children: [
                                          Text(
                                            '${item['status'].toString().split("-").first.toUpperCase()}',
                                            style: (TextStyle( color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                                          ),
                                        ],
                                      )))
                                ],
                              ))),
                              title: Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item['firm_name']}",
                                    style: (TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                  ),
                                  SizedBox(height: 10,),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black, fontSize: 12),
                                      children: <TextSpan>[
                                        TextSpan(text: 'ORDER ID: ', style: TextStyle( fontSize: 12,color: Colors.black)),
                                        TextSpan(text: '#${item['booking_id']},', style: TextStyle( fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
                                        TextSpan(text: ' ${ item['add_from'] }',style: TextStyle( fontSize: 14,fontWeight: FontWeight.bold,color: addformcolor)),

                                      ],
                                    ),
                                  ),


                                ],
                              )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text(
                                    item['dispatch_status'],
                                    style: (TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                                  ),



                                ],
                              ),
                            ),

Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 4),child:Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Expanded(child: InkWell(
                                  child: Text(
                                    viewledger,
                                    style: (TextStyle(
                                        fontSize: 12,
                                        color: Colors.indigoAccent,
                                        fontWeight: FontWeight.bold)),
                                  ),
                                  onTap: () {
                                    if(item['gst']==null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LedgerViewGSTScreen(
                                                  id: id.toString()),
                                        ),
                                      );
                                    }},
                                )),
                                Text(
                                  item['timestamp'].toString().toUpperCase(),
                                  style: (TextStyle(fontSize: 12)),
                                ),

                              ],),),

                            Divider(thickness: 2,),

                          ],
                        ));
                      }).toList()),
          )
        ]));
  }
}
