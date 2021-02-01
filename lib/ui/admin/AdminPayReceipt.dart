import '../base/libraryExport.dart';

class AdminPayReceiptScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  const AdminPayReceiptScreen({Key key, this.konnectDetails}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminPayReceiptState();
}

class _AdminPayReceiptState extends State<AdminPayReceiptScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Map> _allList;
  List<Map> _list;
  List<Map> search = List<Map>();
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    ApiAdmin().getPaymentReceipt().then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;
            _allList = List<Map>();
            _list = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _allList.add(v);
                if (v['reciept_type'] == 'Debit') {
                  _list.add(v);
                }
              });
            }
            search.addAll(_list);
            print(response);
          }),
        });
  }
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['company_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['company_name']} == ${value} ');
          _list.add(item);
        }
      });

    });



  }
  Widget appBarTitle = new Text("Pay Receipt");
  Icon actionIcon = new Icon(Icons.search);
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
                this.appBarTitle = new Text("Pay/Receipt");
              }


            });
          } ,),],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: <Widget>[
            Tab(text: 'Payments'),
            Tab(text: 'Receipt'),
          ],
          onTap: (index) {
            setState(() {
              _list = null;
              String value = index == 0 ? 'Debit' : 'Credit';
              _list = List<Map>();
              _allList.forEach((v) {
                if (v['reciept_type'] == value) {
                  _list.add(v);
                }
              });
              search.clear();
              search.addAll(_list);
            });
          },
          controller: _tabController,
        ),
      ),
      body: Column(children: <Widget>[

    Expanded(
    child: _list == null
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
              : ListView(
                  children: _list.map((item) {
                  return  Card(child:
                      Column(
                    children: <Widget>[

                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PayReceiptViewScreen(
                                id: item['id'].toString(),
                              ),
                            ),
                          );
                        },
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('${item['company_name']}',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14))),
                            ),
                            Text('ADMIN',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 12)))
                          ],
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('₹${item['amount_figure']}',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 10))),
                            ),
                            Text(item['date'],style: (TextStyle(fontSize: 8))),

                          ],
                        ),
                       trailing: IconButton(icon:Icon(Icons.delete),onPressed: (){},),
                      ),
                      Divider(),
                    ],
                  ));
                }).toList()),
    )]));
  }
}
