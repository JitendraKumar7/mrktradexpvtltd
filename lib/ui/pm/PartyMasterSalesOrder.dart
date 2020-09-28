import '../base/libraryExport.dart';

class PartySalesOrderScreen extends StatefulWidget {
  final id;

  const PartySalesOrderScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartySalesOrderState();
}

class _PartySalesOrderState extends State<PartySalesOrderScreen> {
  List<Map> _list;

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
                  children: _list.map((item) {
                  String status = item['status'].toUpperCase();
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
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('#${item['id']}'),
                            ),
                            InkWell(
                              onTap: () {
                                if (status == 'Received'.toUpperCase())
                                  AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
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
                                      btnCancelOnPress: () {
                                        ApiClient()
                                            .changeOrderStatus(
                                                item['id'], 'canceled')
                                            .then((value) {
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
                              child: Text(status),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          item['transaction_date'].toUpperCase(),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
    );
  }
}
