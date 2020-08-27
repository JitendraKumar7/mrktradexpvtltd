import '../ui/base/libraryExport.dart';

class KonnectButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;

  KonnectButton({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 3, 12, 3),
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(width: 8.0),
            Expanded(
              child: label,
            ),
          ],
        ),
      ),
    );
  }
}
