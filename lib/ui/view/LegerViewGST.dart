


import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrktradexpvtltd/Pdfview/Leaderpdf.dart';
import 'package:mrktradexpvtltd/ui/view/PurchaseInvoiceThrewInvoiceNo.dart';

import '../base/libraryExport.dart';
import 'SalesInvoiceThrewInvoiceNo.dart';

class LedgerViewGSTScreen extends StatefulWidget {
  final String id;

  const LedgerViewGSTScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LedgerViewGSTState();
}

class _LedgerViewGSTState extends State<LedgerViewGSTScreen> {
  Widget dataTable;
  String _sDate;
  String _eDate;
  Map _ledger;
  String Gstno;
  KonnectDetails konnectDetails;
  @override
  void initState() {
    super.initState();
    String key1 = AppConstants.KONNECT_DATA;

    AppPreferences.getString(key1).then((value) => {
      setState(() {
        Map<String, dynamic> result = jsonDecode(value);
        konnectDetails = KonnectDetails.fromJson(result);
      })
    });
    ApiAdmin().getLedgerThrewGst(widget.id).then((value) => {
      setState(() {
        Map<String, dynamic> response = value.data;

        if (response['status'] == '200') {

          _ledger = response['result'][0];


                Gstno=_ledger['gstno'];

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


          for (var i = 0; i < _date.length ; i++) {
            rows.add(
                DataRow(cells: [

                  getDataCell(_date, i),
                  getDataCell(_type, i),
                  new DataCell(
                    Text(
                      _billno[i],
                      style: TextStyle(fontSize: 18, color: Colors.blue,fontWeight: FontWeight.bold),
                    ),
                  onTap: (){
                    var details = new Map();
                    details['gstno'] = Gstno;
                    details['Invoiceno'] =_billno[i] ;
                    print(details);
                    if(_type[i]=='Rcpt'){
                      ApiAdmin().getPurchaseInvoiceThrewInvoiceNo(_billno[i] ,Gstno).then((value) => {
                        setState(() {
                          Map<String, dynamic> response = value.data;

                          if (response['status'] == '200') {

                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PurchaseInvoiceThrewInvoiceNoViewScreen(id: details,),),
                            );



                          }else{   Fluttertoast.showToast(
                            msg: "No Data Found",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,

                          );}
                          print(response);
                        }),
                      });


                  }
                    else{
                      ApiAdmin().getSalesInvoiceThrewInvoiceNo(_billno[i],Gstno).then((value) => {
                        setState(() {
                          Map<String, dynamic> response = value.data;

                          if (response['status'] == '200') {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SalesInvoiceThrewInvoiceNo(id: details),
                              ),
                            );




                          }else{   Fluttertoast.showToast(
                            msg: "No SalesInvoice Found",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,

                          );}
                          print(response);
                        }),
                      });

                    }
                    }),
                  getDataCell(_account, i),
                  getDataCell(_debit, i),
                  getDataCell(_credit, i),
                  getDataCell(_balance, i),

                ],
                )

            );


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
    BasicInfo basicInfo = konnectDetails.basicInfo;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: (){reportleader(context,basicInfo, _ledger,_eDate,_sDate);})],

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Ledger View'),
      ),
      body:_ledger == null
          ? Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: GFLoader(loaderColorOne: Colors.white),
        ),
      ): _ledger.isEmpty
          ? Center(
        child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 200,
          child:Center(

            child:Image(image: AssetImage('images/nodatafound.png'),
            ),
          ),
        ),
      ) : SingleChildScrollView(
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
        text??"vikas",
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
