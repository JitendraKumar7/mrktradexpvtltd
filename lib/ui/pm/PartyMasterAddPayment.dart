import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';

import '../base/libraryExport.dart';

class PartyMasterAddPayment extends StatefulWidget {
  final String name;
  final int id;

  const PartyMasterAddPayment({Key key, this.id, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<PartyMasterAddPayment> {
  TextEditingController _paymentRemark = TextEditingController();
  TextEditingController _amountInFigure = TextEditingController();
  TextEditingController _amountInWords = TextEditingController();
  TextEditingController _datePicker = TextEditingController();
  TextEditingController _receiptNo = TextEditingController();

  //List<String> payModeItems = ['Cash', 'Bank'];
  List<Map> cashBackItems = List<Map>();
  DateTime todayDate = DateTime.now();

  //String payModeValue;
  Map cashBackValue;

  @override
  void initState() {
    super.initState();

    HttpClient().getCashBankGroup().then((value) => {
          setState(() {
            Map response = jsonDecode(value);
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                cashBackItems.add(v);
              });
            }
            print(response);
          })
        });

    final String receipt = 'yyyy/MMdd/HHmm/ss';
    _receiptNo.text = 'RCPT/${DateFormat(receipt).format(todayDate)}';
    _datePicker.text = DateFormat('dd/MM/yyyy').format(todayDate);
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
        title: Text('Add Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        child: ListView(children: <Widget>[
          SizedBox(height: 6.0),
          TextFormField(
            autofocus: false,
            controller: _receiptNo,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Receipt No',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          SizedBox(height: 6.0),
          TextFormField(
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: todayDate,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101))
                  .then((picked) => {
                        if (picked != null && picked != todayDate)
                          setState(() {
                            todayDate = picked;
                            _datePicker.text =
                                DateFormat('dd/MM/yyyy').format(todayDate);
                          })
                      });
            },
            readOnly: true,
            autofocus: false,
            controller: _datePicker,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Date',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          SizedBox(height: 6.0),
          DropdownButtonFormField<Map>(
            isExpanded: true,
            value: cashBackValue,
            hint: Text('Receipt Party Name'),
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black87, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            onChanged: (Map vlaue) {
              setState(() {
                cashBackValue = vlaue;
              });
            },
            items: cashBackItems.map<DropdownMenuItem<Map>>((Map value) {
              return DropdownMenuItem<Map>(
                value: value,
                child: Text(
                  value['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 6.0),
          TextFormField(
            autofocus: false,
            controller: _amountInFigure,
            onChanged: (String value) {
              String words =
                  NumberToWord().convert('en-in', int.tryParse(value));
              _amountInWords.text = words;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Amount In Figure',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          SizedBox(height: 6.0),
          TextFormField(
            maxLines: null,
            autofocus: false,
            controller: _amountInWords,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Amount In Words',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          SizedBox(height: 6.0),
          TextFormField(
            maxLines: null,
            autofocus: false,
            controller: _paymentRemark,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Payment Remark',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          SizedBox(height: 30.0),
          GFButton(
              size: 45,
              text: 'Add Payment',
              fullWidthButton: true,
              color: Colors.blue.shade300,
              onPressed: () {
                if (_receiptNo.text.length > 4 &&
                    _paymentRemark.text.length > 4 &&
                    _amountInFigure.text.length > 1 &&
                    cashBackValue != null) {
                  Map params = Map<String, dynamic>();
                  params['receiptNo'] = _receiptNo.text;
                  params['datepicker'] = _datePicker.text;

                  params['Figure'] = _amountInFigure.text;
                  params['AmountInWords'] = _amountInWords.text;
                  params['receipt_add_remark'] = _paymentRemark.text;

                  params['account_master_id'] = widget.id;
                  params['account_master_id_name'] = widget.name;
                  params['add_from_receipt_party'] = cashBackValue['id'];
                  params['add_from_receipt_party_name'] = cashBackValue['name'];

                  print(params.toString());
                  ProgressDialog dialog =
                      ProgressDialog(context, isDismissible: false);
                  dialog.style(
                      message: 'Please Wait...',
                      progressWidget: CircularProgressIndicator());
                  dialog.show();
                  HttpClient().addPartyMasterPayment(params).then((value) => {
                        print(value),
                        dialog.hide(),
                        AwesomeDialog(
                            title: 'Success',
                            context: context,
                            animType: AnimType.SCALE,
                            dismissOnTouchOutside: false,
                            btnOkIcon: Icons.check_circle,
                            dialogType: DialogType.SUCCES,
                            desc: 'Thank you, payment added successfully!',
                            btnOkOnPress: () {
                              Navigator.of(context).pop(true);
                            }).show(),
                      });
                }
                // Error
                else {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.RIGHSLIDE,
                          headerAnimationLoop: false,
                          title: 'Required',
                          desc: 'Params is required',
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red)
                      .show();
                }
              }),
        ]),
      ),
    );
  }
}
