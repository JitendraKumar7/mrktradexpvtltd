


import 'package:mrktradexpvtltd/Pdfview/PaymentReceiptpdf.dart';

import '../base/libraryExport.dart';

class PayReceiptViewScreen extends StatefulWidget {
  final String id;

  const PayReceiptViewScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PayReceiptViewState();
}

class _PayReceiptViewState extends State<PayReceiptViewScreen> {
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

    ApiAdmin().getPaymentReceiptById(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;
            result = response['result'][0];

            List<DataRow> rows = List<DataRow>();

            /*{
        "id": 415,
        "referral_code": "",
        "user_id": "",
        "company_name": "KISHORI LAL AGENCIES",
        "personal_name": "KISHORI LAL AGENCIES",
        "designation": "",
        "contact_number": "",
        "email": "",
        "gst": "07AAAHD2538Q1Z3",
        "address": "73, CHAWRI BAZAR, DELHI-110006    Delhi India",
        "timestamp": "",
        "account_master_id": "183007",
        "date": "2020-07-22",
        "reciept_by": "KISHORI LAL AGENCIES",
        "amount_words": "fourteen thousand six hundred sixteen only",
        "amount_figure": "14616",
        "reciept_type": "Debit",
        "payment_mode": "Pay via QR",
        "image": "https://meo.co.in/PhpScript/konnect/images/",
        "status": "Admin"
      }*/

            rows.add(DataRow(cells: [
              getDataCell('Amount in words'),
              getDataCell(''),
              getDataCell(''),
              getDataCell(''),
              getDataCell('${result['amount_words']}'),
            ]));

            rows.add(DataRow(cells: [
              getDataCell('Amounts'),
              getDataCell(''),
              getDataCell(''),
              getDataCell(''),
              getDataCell('₹ ${result['amount_figure']}'),
            ]));

            rows.add(DataRow(cells: [
              getDataCell('Payment Mode'),
              getDataCell(''),
              getDataCell(''),
              getDataCell(''),
              getDataCell('${result['payment_mode']}'),
            ]));

            rows.add(DataRow(cells: [
              getDataCell('Receipt Type'),
              getDataCell(''),
              getDataCell(''),
              getDataCell(''),
              getDataCell('${result['reciept_type']}'),
            ]));

            rows.add(DataRow(cells: [
              getDataCell('Receipt By'),
              getDataCell(''),
              getDataCell(''),
              getDataCell(''),
              getDataCell('${result['reciept_by']}'),
            ]));

            rows.add(DataRow(cells: [
              getDataCell('Status'),
              getDataCell(''),
              getDataCell(''),
              getDataCell(''),
              getDataCell('${result['status']}'),
            ]));

            for (var i = 3; i < 12; i++) {
              rows.add(DataRow(cells: [
                getDataCell(''),
                getDataCell(''),
                getDataCell(''),
                getDataCell(''),
                getDataCell(''),
              ]));
            }
            dataTable = DataTable(
              columns: [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('')),
                DataColumn(label: Text('')),
                DataColumn(label: Text('')),
                DataColumn(label: Text('')),
              ],
              rows: rows,
            );
          })
        });
  }

  DataCell getDataCell(var value) {
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

  @override
  Widget build(BuildContext context) {
    BasicInfo basicInfo = konnectDetails.basicInfo;
    Location location = konnectDetails.location[0]??'';
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Pay Receipt'),
        actions: [IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: (){reportViewpayrecipt(context, basicInfo,result,location);})],


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
                child: result != null
                    ? Column(
                        children: <Widget>[
                          Container(
                            width: 1.5 * width,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: getRowDesign(
                                    'Receipt',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      'GST No :- ${location.gstNo}',
                                      15,
                                    ),

                                    getRowDesign(
                                      'Phone :- ${basicInfo.mobileNumber}',
                                      15,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.75 * width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    getRowDesign(
                                      '${result['company_name']}',
                                      20,
                                    ),
                                    getRowDesign(
                                      '${result['address']}',
                                      15,
                                    ),
                                    getRowDesign(
                                      'Phone :- ${result['contact_number']}',
                                      15,
                                    ),
                                    getRowDesign(
                                      'Email Id :- ${result['email']}',
                                      15,
                                    ),
                                    getRowDesign(
                                      'GST No :- ${result['gst']}',
                                      15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          dataTable == null
                              ? Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child:
                                        GFLoader(loaderColorOne: Colors.white),
                                  ),
                                )
                              : dataTable,
                        ],
                      )
                    : Center(
                        child: Text('Loading'),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
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
