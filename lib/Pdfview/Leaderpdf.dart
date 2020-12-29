import 'package:mrktradexpvtltd/Pdfview/pdf_viewer_page.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;




reportleader(context,basicInfo, _ledger,_eDate,_sDate) async {



  final Document pdf = Document();


  List<String> _date = _ledger['date'].cast<String>();
  List<String> _type = _ledger['type'].cast<String>();
  List<String> _billno = _ledger['billno'].cast<String>();
  List<String> _account = _ledger['account'].cast<String>();
  List<String> _debit = _ledger['debit'].cast<String>();
  List<String> _credit = _ledger['credit'].cast<String>();
  List<String> _balance = _ledger['balance'].cast<String>();
  List<String> _narration = _ledger['narration'].cast<String>();
  List<String> _count = _ledger['count'].cast<String>();
print('date ki maa ki akh ${_date}');
int length=_date.length;
  for (int i = 0; i < length ; i++)

  print('date ki maa ki akh ${_ledger['date'][i]}');
  String  org = (basicInfo.organisation).toUpperCase();
  pdf.addPage(MultiPage(
      pageFormat:
      PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 0) {
          return null;
        }
        return Container(child:
        Column(children: [
          Container(  alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),

              child: Text('ACCOUNT LEDGER',
                  style: TextStyle(color: PdfColors.blueAccent400,fontWeight:FontWeight.bold,fontSize: 12) ),

          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(

                child:Center(child:
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: <Widget>[


                    Text('${org }',style:TextStyle(color: PdfColors.black,fontWeight:FontWeight.bold,fontSize: 15) ),
                    Container(height: 10),
                    Text(
                      '[ $_sDate TO $_eDate ]',
                      style: TextStyle(
                          fontSize: 10,
                          color: PdfColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(height: 10),
                    getRowDesign(_ledger['account_name'], 12),
                  ],
                )),
              ),
              Container(
                  height: 30
              ),

            ],
          ),])  );
      },
      footer: (Context context) {
        return Row(children:[
          getRowDesign(
          "This document is powered by Konnectmybusiness.com",
          8,),Container(width: 60),

          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey))
        )]);
      },
      build: (Context context) => <Widget>[







        Table.fromTextArray(context: context,cellStyle:TextStyle(color: PdfColors.black ,fontSize: 8) ,rowDecoration:BoxDecoration(borderRadius: 0),border: TableBorder(verticalInside: false,horizontalInside: false),

            headerDecoration: new BoxDecoration(color:  PdfColors.lightBlue,),tableWidth: TableWidth.max,defaultColumnWidth: FixedColumnWidth(250.0),
            headerStyle: TextStyle(color: PdfColors.white,fontWeight: FontWeight.bold),
            data: <List<String>>[
              <String>['DATE', 'TYPE', 'BILL','ACC','DR','CR','BALANCE'],
              for (int i = 0; i <length; i++)

              <String>[
                '${_date[i]}',
                '${_type[i]}',
                '${_billno[i]}',
                '${_account[i]}',
                '${_debit[i]}',
                '${_credit[i]}',
                '${_balance[i]}'
              ],

            ]

        ),




        Header(level: 4,child: Container(

          height:30,




        )),


      ]));
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/${_ledger['account_name']}receipt.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(path: path),
    ),
  );
}

getRowDesign(String text, double fontSize) {
  return Padding(
    padding: EdgeInsets.only(top: 3, bottom: 3),
    child: Text(
      text??"",
      style: TextStyle(
          fontSize: fontSize,

          fontWeight: FontWeight.bold),
    ),
  );
}
getdesign(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 3, bottom: 3),
    child: Text(
      text??"",
      style: TextStyle(
          fontSize: 20,
         color: PdfColors.blue,
          fontWeight: FontWeight.bold),
    ),
  );
}
