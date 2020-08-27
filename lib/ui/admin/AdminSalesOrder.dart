import '../base/libraryExport.dart';

class AdminSalesOrderScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  const AdminSalesOrderScreen({Key key, this.konnectDetails}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminSalesOrderState();
}

class _AdminSalesOrderState extends State<AdminSalesOrderScreen> {
  List<Map> _list;

  @override
  void initState() {
    super.initState();

    ApiAdmin().getSalesOrder().then((value) => {
          setState(() {
            _list = List<Map>();
            Map<String, dynamic> response = value.data;
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
        title: Text("Sales Order"),
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
                      "Empty",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : ListView(
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
                              child: Text('#$id'),
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
