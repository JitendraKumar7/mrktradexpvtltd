import 'package:intl/intl.dart';
import 'package:mrktradexpvtltd/ui/LinkView/LinkUserActivityForm.dart';
import 'package:mrktradexpvtltd/ui/LinkView/LinkUserExpanseReportForm.dart';
import 'package:table_calendar/table_calendar.dart';

import '../base/libraryExport.dart';

class LinkUserExpanseReportScreen extends StatefulWidget {
  final id;

  const LinkUserExpanseReportScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LinkUserExpanseReportState();
}

class LinkUserExpanseReportState extends State<LinkUserExpanseReportScreen> {
  List<Map> _list;
  CalendarController _controller;
  DateTime now = new DateTime.now();
  String formattedDate;
  Map<DateTime, List> _events;
  List _selectedEvents;
  @override
  void initState() {
    super.initState();
    var formatter = new DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(now);
    print(formattedDate); // 2016-01-25

    _controller = CalendarController();
    ApiClient().getActivityForm(widget.id,formattedDate).then((value) => {
      setState(() {
        Map<String, dynamic> response = value.data;

        _list = List<Map>();
        if (response['status'] == '200') {
          response['result'].forEach((value) {
            _list.add(value);
          });
        }
        print(response);
      }),
    }
    );
  }
  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      var formatter = new DateFormat('dd-MM-yyyy');
      formattedDate = formatter.format(day);
      ApiClient().getActivityForm(widget.id,formattedDate).then((value) => {
        setState(() {
          Map<String, dynamic> response = value.data;

          _list = List<Map>();
          if (response['status'] == '200') {
            response['result'].forEach((value) {
              _list.add(value);
            });
          }
          print(response);
        }),
      }
      );
      //  _selectedEvents = events;
      print(formattedDate);
    });
  }
  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
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
        title: Text('EXPANSE REPORT'),
      ),
      body:ListView( shrinkWrap:true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(shadowColor: Colors.grey,
              child: TableCalendar(
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                    todayColor: Colors.blue,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.white)
                ),
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  formatButtonShowsNext: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: _onDaySelected,
                onVisibleDaysChanged: _onVisibleDaysChanged,
                onCalendarCreated: _onCalendarCreated,
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )
                  ),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                calendarController: _controller,
              ),),
          ),

          Container(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(

              onPressed:(){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new  LinkUserExpanseReportForm(id: formattedDate,))
                );
              } ,
              child: Icon(Icons.add),
            ),
          ),
          Container(child:
          _list == null
              ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: GFLoader(loaderColorOne: Colors.white),
            ),
          )
              : _list.isEmpty
              ?  Container(
            width: MediaQuery.of(context).size.width,
            height: 200,

            child:Image(image: AssetImage('images/nodatafound.png'),
            ),

          )
              : ListView(
              shrinkWrap:true,
              children: _list.map((item) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shadowColor: Colors.grey,
                    color: Colors.blue,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PartyMasterViewScreen(id: item['activity_id']),
                              ),
                            );
                          },
                          title: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              item['activity_id'].toString() ?? 'Name Error',style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
              }).toList()),


          ),],),




    );
  }
}
