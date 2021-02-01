import 'package:mrktradexpvtltd/ui/view/LegerViewGST.dart';

import '../base/libraryExport.dart';

class LinkUserSalesOrderScreen extends StatefulWidget {
  final id;

  const LinkUserSalesOrderScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkUserSalesOrderState();
}

class _LinkUserSalesOrderState extends State<LinkUserSalesOrderScreen> {
  List<Map> _list;
List<Map> search=new List();
  @override
  void initState() {
    super.initState();

    ApiAdmin().getLinkUserSalesOrder(widget.id).then((value) => {
          setState(() {
            Map response = value.data;

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
      String q1= item['firm_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['firm_name']} == ${value} ');
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
      body: Column(children: [Expanded(child:_list == null
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
            String t = item['status'].toString().split("-").first.toLowerCase().trim();
            String tcomment = item['status'].toString().split("-").last.toLowerCase().trim(),
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
              color = Colors.green;
              ashape = new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0));
            } else if (t == "hold") {
              color = Colors.red;
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
                      trailing: (
                          Column(
                            children: [
                              InkWell(





                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(width: 100,
                                          child:
                                          Column(
                                            children: [
                                              Text(
                                                '${item['status'].toString().split("-").first.toUpperCase()}',
                                                style: (TextStyle( color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                                              ),
                                              SizedBox(height: 5,),



                                            ],
                                          )




                                      )))
                            ],
                          )),
                      title:
                      Container(
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

                                  ],
                                ),
                              ),


                            ],
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            '${item['dispatch_status']}${tcomment}',
                            style: (TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                          ),



                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 4),child:
                    Row( crossAxisAlignment: CrossAxisAlignment.start,
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
          )],) );
  }
}
