import '../base/libraryExport.dart';

class LinkUserLedgerScreen extends StatefulWidget {
  final id;

  const LinkUserLedgerScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkUserLedgerState();
}

class _LinkUserLedgerState extends State<LinkUserLedgerScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Map> _list;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    ApiAdmin().getLinkUserLedger(widget.id, 'ERP').then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _list = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((value) {
                _list.add(value);
              });
            }
            print(response);
          }),
        });
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
        title: Text('Ledger'),
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
              ApiAdmin().getLinkUserLedger(widget.id, value).then((value) => {
                    setState(() {
                      _list = List<Map>();
                      Map<String, dynamic> response = value.data;
                      if (response['status'] == '200') {
                        response['result'].forEach((value) {
                          _list.add(value);
                        });
                      }
                      print(response);
                    }),
                  });
            });
          },
          controller: _tabController,
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
                            item['company_name'] ?? 'company_name Null',
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
    );
  }
}
