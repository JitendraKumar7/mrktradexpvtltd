import 'dart:io';


import 'package:mrktradexpvtltd/Pdfview/SalesQuotation.dart';
import 'package:mrktradexpvtltd/Pdfview/Salespdf.dart';
import 'package:path_provider/path_provider.dart';
import '../base/libraryExport.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
class SalesQuotationViewScreen extends StatefulWidget {
  final String id;

  const SalesQuotationViewScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SalesQuotationViewState();
}

class _SalesQuotationViewState extends State<SalesQuotationViewScreen> {
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

    ApiAdmin().getQuotationById(widget.id).then((value) => {
      setState(() {
        print(value.data);
        Map<String, dynamic> response = value.data;
        if (response['status'] == '200') {
          result = response['result'][0];
          print('outputresultvikas$result');

          List<DataRow> rows = List<DataRow>();



          List<String> _quantity = result['description'].cast<String>();
          List<String> _item = result['item'].cast<String>();
          List<String> _amount = result['price'].cast<String>();
          int length = _item.length;
          for (var i = 0; i < length; i++) {
            rows.add(DataRow(cells: [


              getDataCell(_item, i),
              getDataCell(_quantity, i),
              getDataCell1(_amount, i, '₹'),
            ]));
          }

          for (var i = length; i < 12; i++) {
            rows.add(DataRow(cells: [
              getDataCell(List(), i),
              getDataCell(List(), i),
              getDataCell(List(), i),

            ]));
          }
          dataTable = DataTable(
            columns: [

              DataColumn(label: Text('ITEM/SEVICES')),
              DataColumn(label: Text('DESCRIPTION')),
              DataColumn(label: Text('RATE PER UNIT')),
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
    Location  location = konnectDetails.location[0]??"vikas";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Scaffold(


      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Sales  Quotation View"),
        actions: [IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: (){
          reportSalesQuotation(context, basicInfo,result,location);
        })],
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
                                'SALES QUOTATION',
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
                                  '${result['name']}',
                                  17,
                                ),
                                getRowDesign(
                                  'PHN No :- #${result['mobile_number']}',
                                  17,
                                ),
                                getRowDesign(
                                  'GST :- #${result['gst_number']}',
                                  17,
                                ),

                                getRowDesign(
                                  'Address :- ${result['address']}',
                                  17,
                                ),
                                getRowDesign(
                                  'Date :- ${result['date']}',
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
