import '../base/libraryExport.dart';

class PartyInvoiceScreen extends StatefulWidget {
  final int id;

  const PartyInvoiceScreen({Key key, this.id})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyInvoiceState();
}

class _PartyInvoiceState extends State<PartyInvoiceScreen> {
  List<Map> _invoice;

  @override
  void initState() {
    super.initState();

    ApiClient().getSaleInvoiceData(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _invoice = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((value) {
                _invoice.add(value);
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
        title: Text("Invoice"),
      ),
      body: _invoice == null
          ? Container(
              width: MediaQuery.of(context).size.height,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
          : _invoice.isEmpty
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
                  children: _invoice.map((item) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SalesInvoiceViewScreen(
                                    id: item['id'],
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
