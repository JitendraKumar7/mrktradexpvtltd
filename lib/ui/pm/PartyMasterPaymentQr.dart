import '../base/libraryExport.dart';

class PartyPaymentQrScreen extends StatefulWidget {
  final List<Bank> bank;
  final BasicInfo basic;

  const PartyPaymentQrScreen({Key key, this.bank, this.basic})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PartyPaymentQrScreenState();
}

class PartyPaymentQrScreenState extends State<PartyPaymentQrScreen> {
  final TextEditingController _transaction = TextEditingController();
  final UrlLauncherService _service = locator<UrlLauncherService>();
  String _upi =
      'upi://pay?pa=9654431845@paytm&pn=JITENDRA+KUMAR&am=500.00&tn=Loan+Amount';

  Bank _bankValue;

  void onChanged(String value) {
    setState(() {
      String note = value.isNotEmpty ? value.replaceAll(' ', '+') : 'konnect';
      String name = widget.basic.organisation.replaceAll(' ', '+');
      String bank = '${_bankValue.accNo}@${_bankValue.ifscCode}.ifsc.npci';
      String upi = _bankValue.upi.isEmpty ? bank : _bankValue.upi;

      _upi = 'upi://pay?pa=$upi&pn=$name&tn=$note';
      print(_upi);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (widget.bank.length > 0) {
      _bankValue = widget.bank[0];
      onChanged(_transaction.text);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment QR Code'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
        color: const Color(0xFFFFFFFF),
        child: ListView(
          children: <Widget>[
            DropdownButtonFormField<Bank>(
              isExpanded: true,
              value: _bankValue,
              hint: Text('Select bank UPI'),
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black87, fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
              onChanged: (Bank data) {
                setState(() {
                  _bankValue = data;
                  onChanged(_transaction.text);
                });
              },
              items: widget.bank.map<DropdownMenuItem<Bank>>((Bank value) {
                return DropdownMenuItem<Bank>(
                  value: value,
                  child: Text(
                    value.upi.isEmpty ? value.bankName : value.upi,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              autofocus: false,
              onChanged: onChanged,
              controller: _transaction,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Transaction note',
                prefixIcon: Icon(Icons.message),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
            SizedBox(height: 12.0),
            Container(
              height: 0.5 * height,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Center(
                  child: RepaintBoundary(
                    child: QrImage(
                      data: _upi,
                      size: 0.5 * height,
                      errorStateBuilder: (cxt, err) {
                        return Container(
                          child: Center(
                            child: Text(
                              'Uh oh! Something went wrong...',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            GFButton(
                size: 45,
                text: 'Payment Now',
                color: Colors.blue.shade300,
                fullWidthButton: true,
                onPressed: () {
                  _service.launchUrl(_upi);
                }),
          ],
        ),
      ),
    );
  }
}
