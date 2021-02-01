import '../base/libraryExport.dart';

class PartyLedgerScreen extends StatefulWidget {
  final id;

  const PartyLedgerScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyLedgerState();
}

class _PartyLedgerState extends State<PartyLedgerScreen> {
  List<Map> _ledger;
List<Map> search =new List();
  @override
  void initState() {
    super.initState();

    ApiClient().getLedgerData(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _ledger = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((value) {
                _ledger.add(value);
              });
            }
            search.addAll(_ledger);
            print(response);
          }),
        });
  }
  Widget appBarTitle = new Text("Ledger");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _ledger= List<Map>();
    search.forEach((item) {
      String q1= item['account_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['account_name']} == ${value} ');
          _ledger.add(item);
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
      body:Column(children: [Expanded(child:  _ledger == null
          ? Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
          : _ledger.isEmpty
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
                  children: _ledger.map((item) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LedgerViewScreen(id: item['id']),
                            ),
                          );
                        },
                        title: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              item['account_name'],style:  TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14),
                            )),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
          )],) );
  }
}
