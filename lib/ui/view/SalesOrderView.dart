import '../base/libraryExport.dart';

class SalesOrderViewScreen extends StatefulWidget {
  final String id;

  const SalesOrderViewScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SalesOrderViewState();
}

class _SalesOrderViewState extends State<SalesOrderViewScreen> {
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

    ApiAdmin().getSalesOrderById(widget.id).then((value) => {
          setState(() {
            print(value.data);
            Map<String, dynamic> response = value.data;
            if (response['status'] == '200') {
              result = response['result'][0];
              print(result);

              List<DataRow> rows = List<DataRow>();

              List<String> _productId = result['product_id'].cast<String>();
              List<String> _product = result['product'].cast<String>();
              List<String> _quantity = result['quantity'].cast<String>();
              List<String> _unit = result['unit'].cast<String>();
              List<String> _amount = result['amount'].cast<String>();

              int length = _product.length;
              for (var i = 0; i < length; i++) {
                rows.add(DataRow(cells: [
                  getDataCell1(_productId, i, '#'),
                  getDataCell(_product, i),
                  getDataCell(_unit, i),
                  getDataCell(_quantity, i),
                  getDataCell1(_amount, i, '₹'),
                ]));
              }

              for (var i = length; i < 12; i++) {
                rows.add(DataRow(cells: [
                  getDataCell(List(), i),
                  getDataCell(List(), i),
                  getDataCell(List(), i),
                  getDataCell(List(), i),
                  getDataCell(List(), i),
                ]));
              }
              dataTable = DataTable(
                columns: [
                  DataColumn(label: Text('#ID')),
                  DataColumn(label: Text('PRODUCT')),
                  DataColumn(label: Text('UNIT')),
                  DataColumn(label: Text('QUANTITY')),
                  DataColumn(label: Text('PRODUCT RATE')),
                ],
                rows: rows,
              );
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    BasicInfo basicInfo = konnectDetails.basicInfo;
    Location location = konnectDetails.location[0];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Sales Order View"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: width),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: dataTable == null
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: GFLoader(loaderColorOne: Colors.white),
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              width: 1.5 * width,
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: getRowDesign(
                                      'SALES ORDER',
                                      18,
                                    ),
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
                                  width: 0.75 * width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      getRowDesign(
                                        basicInfo.organisation,
                                        18,
                                      ),
                                      getRowDesign(
                                        location.address,
                                        15,
                                      ),
                                      getRowDesign(
                                        'GST No :- ' + location.gstNo,
                                        15,
                                      ),
                                      getRowDesign(
                                        'Phone :- ' + basicInfo.mobileNumber,
                                        15,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 0.75 * width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      getRowDesign(
                                        'ORDER ID :- #${result['booking_id']}',
                                        20,
                                      ),
                                      getRowDesign(
                                        '${result['firm_name']}',
                                        17,
                                      ),
                                      getRowDesign(
                                        'Address :- ${result['address']}',
                                        17,
                                      ),
                                      getRowDesign(
                                        'Date :- ${result['timestamp']}',
                                        17,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            dataTable,
                          ],
                        )),
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
