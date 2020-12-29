import '../base/libraryExport.dart';

class LinkUserSalesOrderScreen extends StatefulWidget {
  final id;

  const LinkUserSalesOrderScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkUserSalesOrderState();
}

class _LinkUserSalesOrderState extends State<LinkUserSalesOrderScreen> {
  List<Map> _list;

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
        title: Text('Sales Order'),
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
                  reverse: true,
                  children: _list.map((item) {
                    int id = item['booking_id'];
                    return Column(
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
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(item['firm_name']),
                              ),
                              Text(item['status'].toString().toUpperCase())
                            ],
                          ),
                          subtitle: Text(
                            item['timestamp'],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }).toList()),
    );
  }
}
