import 'package:flutter/cupertino.dart';
import 'package:mrktradexpvtltd/ui/base/libraryExport.dart';

class LinkUserActivityReportForm extends StatefulWidget{

  final id;

  const LinkUserActivityReportForm ({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return LinkUserActivityReportForm1();
  }
}
class LinkUserActivityReportForm1 extends State<LinkUserActivityReportForm>{
  ProgressDialog pr;
  TextEditingController Title = TextEditingController();
  TextEditingController Location =  TextEditingController();
  TextEditingController Remark = TextEditingController();
  TextEditingController Date =  TextEditingController();
  TextEditingController Activity= TextEditingController();
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  bool _load = false;
  DateTime _selectedDate;
  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
Date.text= widget.id;
    return Scaffold(
      appBar: AppBar(title: Text('Activity Form'), leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
    child:Column(children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            height: 20,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .4),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                      )
                    ]
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[100]))
                      ),
                      child: TextFormField(

                        controller:Title ,
                        decoration: InputDecoration(
                            prefixIcon:IconButton (icon: Icon(Icons.title,color:Colors.lightBlue)),
                            border: InputBorder.none,
                            hintText: " Title",
                            hintStyle: TextStyle(color: Colors.grey[400])
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[100]))
                      ),

                            child:  TextFormField(
                                  readOnly: true,
                               controller: Date,
                              decoration: InputDecoration(
                                  prefixIcon:IconButton (icon: Icon(Icons.date_range,color:Colors.lightBlue)),
                                  border: InputBorder.none,
                                  hintText: " Date",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[100]))
                      ),
                      child: TextFormField(

                        controller:Location ,
                        decoration: InputDecoration(
                            prefixIcon:IconButton (icon: Icon(Icons.location_on,color:Colors.lightBlue)),
                            border: InputBorder.none,
                            hintText: "Location/Place",
                            hintStyle: TextStyle(color: Colors.grey[400])
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[100]))
                      ),child:  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        new Flexible(
                          child:  Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[100]))
                            ),
                            child: new TextField(
                              controller:Activity ,
                              decoration: InputDecoration(
                                  prefixIcon:IconButton (icon: Icon(Icons.local_activity,color:Colors.lightBlue)),
                                  border: InputBorder.none,
                                  hintText: "Activity",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                            ),
                          ),

                        ),
                        SizedBox(width: 10.0,),
                        new Flexible(child:Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child:
                          new TextField(
                            controller: Remark,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon:IconButton (icon: Icon(Icons.edit_location_rounded,color: Colors.lightBlue)),

                                border: InputBorder.none,
                                hintText: "Remarks",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                        )],
                    ),),

                  ],
                ),
              ),

              SizedBox(height: 30,),
              InkWell(child:
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,0,0),
                child: Container(
                  alignment: Alignment.centerRight,
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [
                            Colors.lightBlueAccent,

                            Colors.lightBlue
                          ]
                      )
                  ),
                  child:
                  Center(
                    child: Icon(Icons.add,color: Colors.white,),
                  ),),
              ),onTap: () async {
                //Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
              },
              ),
              SizedBox(height: 30,),
              InkWell(child:
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,

                          Colors.lightBlue
                        ]
                    )
                ),
                child:
                Center(
                  child: Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),),onTap: () async {

                Map<String, dynamic> params = Map<String, dynamic>();
                params['add_name_of_activity'] = Activity.text;
                params['add_remark'] = Remark.text;
                params['doa'] = widget.id;
                params['poa'] = Location.text;
                params['user_id'] = widget.id;
                ApiClient().addActivityForm(params).then((value) => {
                  setState(() {

                    print(value.data);
                    Map<String, dynamic> response = value.data;
                    if (response['status'] == '200') {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SplashScreen(),
                        ),
                      );
                    }
                    print(value);
                  })
                });
                //Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
                },
              ),
              SizedBox(height: 70,),
            ],


          ),
        ),],

      ),
    ));
  }
}