import '../ui/base/libraryExport.dart';

class DashboardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String asset;
  final String label;

  const DashboardButton(
      {Key key,
      @required this.onPressed,
      @required this.asset,
      @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          splashColor: Colors.orange,
          onTap: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                asset,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(label,
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
