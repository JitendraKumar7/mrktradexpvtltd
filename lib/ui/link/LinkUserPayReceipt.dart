import '../base/libraryExport.dart';

class LinkUserPayReceiptScreen extends StatefulWidget {
  final  int id;

  const LinkUserPayReceiptScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkUserPayReceiptState();
}

class _LinkUserPayReceiptState extends State<LinkUserPayReceiptScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Map> _allList;
  List<Map> _list;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    ApiAdmin().getLinkUserPayReceipt(widget.id).then((value) => {
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
        title: Text('Payments'),
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
            });
          },
          controller: _tabController,
        ),
      ),
      body: _list == null
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
                                id: item['id'].toString(),
                              ),
                            ),
                          );
                        },
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('${item['company_name']}'),
                            ),
                            Text('₹${item['amount_figure']}.00')
                          ],
                        ),
                        subtitle: Text(item['date']),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
    );
  }
}
