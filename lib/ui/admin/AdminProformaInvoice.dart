import '../base/libraryExport.dart';

class AdminProformaInvoiceScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  const AdminProformaInvoiceScreen({Key key, this.konnectDetails})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminProformaInvoiceState();
}

class _AdminProformaInvoiceState extends State<AdminProformaInvoiceScreen> {
  List<Map> _list;

  @override
  void initState() {
    super.initState();

    ApiAdmin().getProformaData().then((value) => {
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
        title: Text('Proforma Invoice'),
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
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProformaInvoiceViewScreen(
                                id: item['invoice_id'].toString(),
                              ),
                            ),
                          );
                        },
                        title: Text(item['invoice_no']),
                        subtitle: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(item['invoice_name']),
                            ),
                            Text(item['invoice_date'])
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
    );
  }
}
