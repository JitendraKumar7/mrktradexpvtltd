import '../base/libraryExport.dart';

class LinkUserProformaInvoiceScreen extends StatefulWidget {
  final id;

  const LinkUserProformaInvoiceScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkUserProformaInvoiceState();
}

class _LinkUserProformaInvoiceState
    extends State<LinkUserProformaInvoiceScreen> {
  List<Map> _list;
List<Map> search= new List();
  @override
  void initState() {
    super.initState();

    ApiAdmin().getLinkUserProformaInvoice(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _list = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((value) {
                _list.add(value);
              });
            }
            search.addAll(_list);
            print(response);
          }),
        });
  }
  Widget appBarTitle = new Text("Proforma Invoice");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['invoice_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['invoice_name']} == ${value} ');
          _list.add(item);
        }
      });

    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title:appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon,onPressed:(){
            setState(() {
              if ( this.actionIcon.icon == Icons.search){
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle =   new TextFormField(
                  autofocus: false,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Search Here...',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                );}
              else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text('Proforma Invoice');
              }


            });
          } ,),],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body:Column(children: [Expanded(child:  _list == null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
          : _list.isEmpty
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
      )
              :  ListView(
          children: _list.map((item) {
            return Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProformaInvoiceViewScreen(
                              id: item['invoice_id'].toString(),
                            ),
                      ),
                    );
                  },
                  title: Text(item['invoice_name'],style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14))),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(item['invoice_no'],style: (TextStyle(fontWeight: FontWeight.bold,fontSize: 12))),
                      ),
                      Text(item['invoice_date'],style: (TextStyle(fontSize: 8)))
                    ],
                  ),
                ),
                Divider(),
              ],
            );
          }).toList()),
          )],) );
  }
}
