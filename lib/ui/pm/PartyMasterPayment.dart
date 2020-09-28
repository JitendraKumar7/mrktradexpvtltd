import '../base/libraryExport.dart';

class PartyPaymentScreen extends StatefulWidget {
  final name;
  final id;

  const PartyPaymentScreen({Key key, this.id, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyPaymentState();
}

class _PartyPaymentState extends State<PartyPaymentScreen> {
  List<Map> _list;

  load() {
    ApiClient().getPaymentReceipt(widget.id).then((value) => {
          setState(() {
            _list = List<Map>();
            Map response = value.data;

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
  void initState() {
    super.initState();
    load();
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
                                  PayReceiptViewScreen(
                                id: item['id'],
                              ),
                            ),
                          );
                        },
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('#${item['reciept_number']}'),
                            ),
                            Text(item['date'])
                          ],
                        ),
                        subtitle: Html(data: item['amount_figure']),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_circle_outline),
          backgroundColor: Colors.blue.shade300,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PartyMasterAddPayment(
                  name: widget.name,
                  id: widget.id,
                ),
              ),
            ).then((value) {
              if (value)
                setState(() {
                  _list = null;
                  load();
                });
            });
          }),
    );
  }
}
