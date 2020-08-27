import '../base/libraryExport.dart';

class PartyLedgerScreen extends StatefulWidget {
  final int id;

  const PartyLedgerScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyLedgerState();
}

class _PartyLedgerState extends State<PartyLedgerScreen> {
  List<Map> _ledger;

  @override
  void initState() {
    super.initState();

    ApiClient().getLedgerData(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _ledger = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((value) {
                _ledger.add(value);
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
        title: Text("Ledger"),
      ),
      body: _ledger == null
          ? Container(
              width: MediaQuery.of(context).size.height,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
          : _ledger.isEmpty
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
                  children: _ledger.map((item) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LedgerViewScreen(id: item['id']),
                            ),
                          );
                        },
                        title: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              item['account_name'],
                            )),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
    );
  }
}
