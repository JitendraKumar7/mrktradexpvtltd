import '../base/libraryExport.dart';

class PartySalesOrderScreen extends StatefulWidget {
  final id;

  const PartySalesOrderScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartySalesOrderState();
}

class _PartySalesOrderState extends State<PartySalesOrderScreen> {
  List<Map> _list;
List<Map>search= new List();
  @override
  void initState() {
    super.initState();

    ApiClient().getSalesOrderData(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _list = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _list.add(v);
              });
            }
            search.addAll(_list);
            print(response);
          }),
        });
  }
  Widget appBarTitle = new Text("Sales Order");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['status'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['status']} == ${value} ');
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
                this.appBarTitle = new Text('Sales Order');
              }


            });
          } ,),],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body:Column(children: [Expanded(child: _list == null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
          : _list.isEmpty
              ? Center(
        child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 200,
          child:Center(

            child:Image(image: AssetImage('images/nodatafound.png'),
            ),
          ),
        ),
      )
              : ListView(
                  children: _list.map((item) {
                  String status = item['status'].toString().toLowerCase();
                  List product =new List();
                  product=item['product'];
                  print(product[0]);
                  Color color;
                  ShapeBorder ashape;

                  if (status == "confirmed") {
                    color = Colors.green;
                    ashape = new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0));
                  } else if (status == "hold") {
                    color = Colors.red;
                    ashape = new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0));
                  } else if (status == "received") {
                    color = Colors.black;
                    ashape = new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    );
                  } else if (status == "canceled") {
                    color = Colors.red;
                  } else if (status == "dispatched") {
                    color = Colors.green;
                  }
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SalesOrderViewScreen(
                                id: item['id'],
                              ),
                            ),
                          );
                        },
                        leading:  Text('#${item['id']}',style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold),),
                        title: Center(
                          child: Row(
                            children: <Widget>[


                          Expanded(   child: Text(product[0].toString().toUpperCase().trim()??"",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                          ),
                              InkWell(
                                onTap: () {
                                  if (status == "received")
                                    AwesomeDialog(
                                        context: context,
                                        dismissOnTouchOutside: true,
                                        dialogType: DialogType.INFO,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Logout',
                                        desc: 'Logout',
                                        body: Text(
                                          'Are you sure want to canceled order',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),

                                        btnOkOnPress: () {
                                          ApiClient().changeOrderStatus(
                                                  item['id'], 'canceled').then((value) {
                                            Map response = value.data;
                                            if (response['status'] == '200') {
                                              item['status'] = 'canceled';
                                              setState(() {
                                                _list[_list.indexWhere(
                                                    (element) =>
                                                        element['id'] ==
                                                        item['id'])] = item;
                                              });
                                            }
                                          });
                                        }).show();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                      width:100,
                                      child: Text(status.toUpperCase().trim(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: color),)),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 4),child:
                      Row( crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(child: Text(
                              "",
                              style: (TextStyle(
                                  fontSize: 12,
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold)),
                            ),

                          ),
                          Text(
                            item['transaction_date'].toString().toUpperCase(),
                            style: (TextStyle(fontSize: 12)),
                          ),

                        ],),),
                      Divider(thickness: 2,),
                    ],
                  );
                }).toList()),
      )],) );
  }
}
