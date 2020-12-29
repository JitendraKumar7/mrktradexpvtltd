

import 'package:mrktradexpvtltd/Pdfview/PurchaseInvoice.dart';

import '../base/libraryExport.dart';

class PurchaseInvoiceViewScreen extends StatefulWidget {
  final String id;

  const PurchaseInvoiceViewScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PurchaseInvoiceViewState();
}

class _PurchaseInvoiceViewState extends State<PurchaseInvoiceViewScreen> {
  KonnectDetails konnectDetails;
  Map<String, dynamic> result;
  Widget dataTable;

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

    ApiAdmin().getPurchaseInvoiceById(widget.id).then((value) => {
          setState(() {
            Map response = value.data;

            if (response['status'] == '200') {
              result = response['result'][0];

              //List<String> desc = _invoiceView.itemDescription;
              List<String> allAmount = result['all_amount'].cast<String>();
              //List<String> gstAmount = result['gst_amount'].cast<String>();
              List<String> quantity = result['quantity'].cast<String>();
              List<String> rate = result['rate'].cast<String>();
              List<String> item = result['item'].cast<String>();
              List<String> unit = result['unit'].cast<String>();
              List<String> hsn = result['hsn'].cast<String>();

              List<DataRow> rows = List<DataRow>();
              for (var i = 0; i < item.length + 3; i++) {
                rows.add(DataRow(cells: [
                  getDataCell(item, i),
                  getDataCell(hsn, i),
                  getDataCell(unit, i),
                  getDataCell1(rate, i, '₹'),
                  getDataCell(quantity, i),
                  //getDataCell(gstAmount, i),
                  getDataCell1(allAmount, i, '₹'),
                ]));
              }

              List<String> sundryName = result['sundry_name'].cast<String>();
              List<String> sundryAmount =
                  result['sundry_amount'].cast<String>();

              for (var i = 0; i < sundryName.length + 1; i++) {
                rows.add(DataRow(cells: [
                  getDataCell12(''),
                  getDataCell12(''),
                  getDataCell12(''),
                  //getDataCell12(''),
                  getDataCell(sundryName, i),
                  getDataCell12(''),
                  getDataCell(sundryAmount, i),
                ]));
              }
              rows.add(DataRow(cells: [
                getDataCell12(''),
                getDataCell12(''),
                getDataCell12(''),
                //getDataCell12(''),
                getDataCell12('Total Amount'),
                getDataCell12(''),
                getDataCell12('₹ ${result['total_amount']}'),
              ]));
              for (var i = 0; i < 3; i++) {
                rows.add(DataRow(cells: [
                  getDataCell12(''),
                  getDataCell12(''),
                  getDataCell12(''),
                  getDataCell12(''),
                  getDataCell12(''),
                  getDataCell12(''),
                ]));
              }

              dataTable = DataTable(
                columns: [
                  DataColumn(label: Text('ITEM')),
                  DataColumn(label: Text('HSN')),
                  DataColumn(label: Text('UNIT')),
                  DataColumn(label: Text('RATE')),
                  DataColumn(label: Text('QTY')),
                  //DataColumn(label: Text('AMT')),
                  DataColumn(label: Text('TOTAL')),
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
    BasicInfo basicInfo = konnectDetails.basicInfo;
    Location location = konnectDetails.location[0]??"";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( actions: [IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: (){reportPurchaseInvoice(context, result,basicInfo,location);})],

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Purchase Invoice'),
      ),
      body: dataTable == null
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
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 2.5 * width,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: getRowDesign('TAX INVOICE', 18),
                                ),
                                FadeInImage.assetNetwork(
                                  image: basicInfo.konnectLogo,
                                  placeholder: 'images/ic_konnect.png',
                                  height: 80,
                                  width: 60,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 1.25 * width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    getRowDesign(basicInfo.organisation, 18),
                                    getRowDesign(location.address, 15),
                                    getRowDesign(
                                        'GST No :- ' + location.gstNo, 15),
                                    getRowDesign(
                                        'Phone :- ' + basicInfo.mobileNumber,
                                        15),
                                    getRowDesign(
                                        'INVOICE NO :- ${result['invoice_no']}',
                                        15),
                                    getRowDesign(
                                        'Date :- ${result['invoice_date']}',
                                        15),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1.25 * width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    getRowDesign(result['invoice_name'], 18),
                                    getRowDesign(
                                        '${result['address'] + result['address1'] + result['address2'] + result['address3']}',
                                        15),
                                    getRowDesign(
                                        'GST No :- ${result['gst']}', 15),
                                    getRowDesign('Phone :- ', 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          dataTable,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  DataCell getDataCell12(String value) {
    try {
      return DataCell(
        Text(
          value,
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

  DataCell getDataCell1(List<String> list, int pos, String spc) {
    try {
      return DataCell(
        Text(
          spc + '' + list[pos],
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
}
