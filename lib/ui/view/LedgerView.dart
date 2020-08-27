import '../base/libraryExport.dart';

class LedgerViewScreen extends StatefulWidget {
  final String id;

  const LedgerViewScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LedgerViewState();
}

class _LedgerViewState extends State<LedgerViewScreen> {
  Widget dataTable;
  String _sDate;
  String _eDate;
  Map _ledger;

  @override
  void initState() {
    super.initState();

    ApiAdmin().getLedgerById(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            if (response['status'] == '200') {
              _ledger = response['result'][0];

              List<String> _date = _ledger['date'].cast<String>();
              List<String> _type = _ledger['type'].cast<String>();
              List<String> _billno = _ledger['billno'].cast<String>();
              List<String> _account = _ledger['account'].cast<String>();
              List<String> _debit = _ledger['debit'].cast<String>();
              List<String> _credit = _ledger['credit'].cast<String>();
              List<String> _balance = _ledger['balance'].cast<String>();
              List<String> _narration = _ledger['narration'].cast<String>();
              List<String> _count = _ledger['count'].cast<String>();
              //List<String>  _gstno = json['gstno'];

              List<DataRow> rows = List<DataRow>();
              for (var i = 0; i < _date.length + 3; i++) {
                rows.add(DataRow(cells: [
                  getDataCell(_date, i),
                  getDataCell(_type, i),
                  getDataCell(_billno, i),
                  getDataCell(_account, i),
                  getDataCell(_debit, i),
                  getDataCell(_credit, i),
                  getDataCell(_balance, i),
                ]));

                try {
                  if (_date[i]?.isNotEmpty ?? false) {
                    if (_sDate?.isEmpty ?? true) {
                      _sDate = _date[i];
                    }
                    _eDate = _date[i];
                  }
                } catch (e) {
                  print(e);
                }
              }

              dataTable = DataTable(
                columns: [
                  DataColumn(label: Text('DATE')),
                  DataColumn(label: Text('TYPE')),
                  DataColumn(label: Text('BILL')),
                  DataColumn(label: Text('ACC')),
                  DataColumn(label: Text('DR')),
                  DataColumn(label: Text('CR')),
                  DataColumn(label: Text('BALANCE')),
                ],
                rows: rows,
              );
            }
            print(response);
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Ledger View'),
      ),
      body: _ledger == null
          ? Center(
              child: GFLoader(loaderColorOne: Colors.white),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: width),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: height),
                    child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(children: <Widget>[
                          getRowDesign('LEDGER', 18),
                          getRowDesign(_ledger['account_name'], 18),
                          Text(
                            '[ $_sDate TO $_eDate ]',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          dataTable,
                        ])),
                  ),
                ),
              ),
            ),
    );
  }

  DataCell getDataCell(List<String> list, int pos) {
    try {
      return DataCell(
        Text(
          list[pos],
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    } catch (e) {
      return DataCell(
        Text(
          ' ',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }
  }

  Widget getRowDesign(String text, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
