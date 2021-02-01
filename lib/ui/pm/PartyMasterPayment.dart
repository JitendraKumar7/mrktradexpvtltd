import '../base/libraryExport.dart';

class PartyPaymentScreen extends StatefulWidget {
  final name;
  final id;

  const PartyPaymentScreen({Key key, this.id, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyPaymentState();
}

class _PartyPaymentState extends State<PartyPaymentScreen> {
  List<Map> _list;
  List<Map>search =new List();

  load() {
    ApiClient().getPaymentReceipt(widget.id).then((value) => {
          setState(() {
            _list = List<Map>();
            Map response = value.data;

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

  @override
  void initState() {
    super.initState();
    load();
  }
  Widget appBarTitle = new Text("Payments");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['reciept_number'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['reciept_number']} == ${value} ');
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
                this.appBarTitle = new Text('Ledger');
              }


            });
          } ,),],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _list == null
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
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PayReceiptViewScreen(
                                id: item['id'],
                              ),
                            ),
                          );
                        },
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('#${item['reciept_number']}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                            ),
                            Text(item['date'] ,style:  TextStyle(color:Colors.black26,fontWeight: FontWeight.bold,fontSize: 12),)
                          ],
                        ),
                        subtitle: Html(data: item['amount_figure']),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_circle_outline),
          backgroundColor: Colors.blue.shade300,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PartyMasterAddPayment(
                  name: widget.name,
                  id: widget.id,
                ),
              ),
            ).then((value) {
              if (value)
                setState(() {
                  _list = null;
                  load();
                });
            });
          }),
    );
  }
}
