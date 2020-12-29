import '../base/libraryExport.dart';

class AdminLedgerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminLedgerState();
}

class _AdminLedgerState extends State<AdminLedgerScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Map> _list;
List<Map> search= List<Map>();
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    ApiAdmin().getLedger('ERP').then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _list = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((value) {
                _list.add(value);
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
  Widget appBarTitle = new Text("Leader");
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
                this.appBarTitle = Text('Ledger'

                );
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
            Tab(text: 'ERP'),
            Tab(text: 'KMB'),
          ],
          onTap: (index) {
            setState(() {
              _list = null;
              String value = index == 0 ? 'ERP' : 'KMB';
              ApiAdmin().getLedger(value).then((value) => {
                    setState(() {
                      _list = List<Map>();
                      Map<String, dynamic> response = value.data;
                      if (response['status'] == '200') {
                        response['result'].forEach((value) {
                          _list.add(value);
                        });
                      }
                      search.clear();
                      search.addAll(_list);
                      print(response);
                    }),
                  });
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
                  children: _list.map((item) {
                  String id = item['ledger_id'].toString();
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LedgerViewScreen(id: id),
                            ),
                          );
                        },
                        title: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            item['company_name'],style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14))
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
    )]));
  }
}
