import '../base/libraryExport.dart';

class LinkUserPayReceiptScreen extends StatefulWidget {
  final id;

  const LinkUserPayReceiptScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkUserPayReceiptState();
}

class _LinkUserPayReceiptState extends State<LinkUserPayReceiptScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Map> _allList;
  List<Map> _list;
List<Map> search = new List();
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    ApiAdmin().getLinkUserPayReceipt(widget.id).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;
            _allList = List<Map>();
            _list = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _allList.add(v);
                if (v['reciept_type'] == 'Debit') {
                  _list.add(v);
                }
              });
            }
            search.addAll(_list);
            print(response);
          }),
        });
  }
  Widget appBarTitle = new Text("Payments");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['company_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['company_name']} == ${value} ');
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
                this.appBarTitle = new Text('Payments');
              }


            });
          } ,),],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: <Widget>[
            Tab(text: 'Payments'),
            Tab(text: 'Receipt'),
          ],
          onTap: (index) {
            setState(() {
              _list = null;
              String value = index == 0 ? 'Debit' : 'Credit';
              _list = List<Map>();
              _allList.forEach((v) {
                if (v['reciept_type'] == value) {
                  _list.add(v);
                }

              });
              search.clear();
              search.addAll(_list);
            });
          },
          controller: _tabController,
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
              : ListView(
          children: _list.map((item) {
            return  Card(child:
            Column(
              children: <Widget>[

                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PayReceiptViewScreen(
                              id: item['id'].toString(),
                            ),
                      ),
                    );
                  },
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('${item['company_name']}',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14))),
                      ),
                      Text('',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 12)))
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('₹${item['amount_figure']}',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 10))),
                      ),
                      Text(item['date'],style: (TextStyle(fontSize: 8))),

                    ],
                  ),

                ),
                Divider(),
              ],
            ));
          }).toList()),
          )],)   );
  }
}
