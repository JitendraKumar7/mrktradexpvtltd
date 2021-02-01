


import 'package:mrktradexpvtltd/Pdfview/pdf_viewer_page.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;




reportPurchaseInvoice(context, result,basicInfo,location) async {



  final Document pdf = Document();
  List<String> allAmount = result['all_amount'].cast<String>();
  //List<String> gstAmount = result['gst_amount'].cast<String>();
  List<String> quantity = result['quantity'].cast<String>();
  List<String> rate = result['rate'].cast<String>();
  List<String> item = result['item'].cast<String>();
  List<String> unit = result['unit'].cast<String>();
  List<String> hsn = result['hsn'].cast<String>();


  List<String> sundryName = result['sundry_name'].cast<String>();
  List<String> sundryAmount =
  result['sundry_amount'].cast<String>();


  pdf.addPage(MultiPage(
      pageFormat:
      PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(

            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
           );
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
                      .copyWith(color: PdfColors.grey)))]);

      },
      build: (Context context) => <Widget>[



        Header(level:0,child:   Column(
      children: [
        Center(
        child:   Text('PURCHASE INVOICE',
          style: Theme.of(context)
              .defaultTextStyle
              .copyWith(color: PdfColors.black,fontSize:15 ,fontWeight: FontWeight.bold)
          ,)
        ),
    Container(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 200,
              child:Center(child:
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  getRowDesign('FROM', 12),

                  getRowDesign(basicInfo.organisation, 10),
                  getRowDesign(location.address, 10),
                  getRowDesign(
                      'GST No :- ' + location.gstNo, 10),
                  getRowDesign(
                      'Phone :- ' + basicInfo.mobileNumber,
                      10),
                  getRowDesign(
                      'INVOICE NO :- ${result['invoice_no']}',
                      10),
                  getRowDesign(
                      'Date :- ${result['invoice_date']}',
                      10),

                ],
              )),
            ),
            Container(
                width: 40
            ),
            Container(
width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getRowDesign('To', 12),
                  getRowDesign(result['invoice_name'], 10),
                  getRowDesign(
                      '${result['address'] + result['address1'] + result['address2'] + result['address3']}',
                      10),
                  getRowDesign(
                      'GST No :- ${result['gst']}', 10),
                  getRowDesign('Phone :- ', 10),
                ],
              ),
            ),


          ],
        )]),),



        Table.fromTextArray(context: context,cellAlignment: Alignment.center,cellStyle:TextStyle(color: PdfColors.black ,fontSize: 8) ,rowDecoration:BoxDecoration(borderRadius: 0),border: TableBorder(verticalInside: false,horizontalInside: false),

          headerDecoration: new BoxDecoration(color:  PdfColors.lightBlue,),tableWidth: TableWidth.max,defaultColumnWidth: FixedColumnWidth(250.0),
            headerStyle: TextStyle(color: PdfColors.white,fontWeight: FontWeight.bold),
            data: <List<String>>[
              <String>['ITEM', 'HSN', 'UNIT','RATE','QTY','TOTAL',],
              for (int i = 0; i <item.length; i++)

              <String>[
                '${item[i]}',
                '${hsn[i]}',
                '${unit[i]}',

                '${rate[i]}',
                '${quantity[i]}',
                '${allAmount[i]}'
              ],
              for (var j = 0; j < sundryName.length ; j++)
                <String>[
                  '',
                  '',
                  '',

                  '${sundryName[j]}',
                  '',
                  '${sundryAmount[j]}'
                ],
              <String>[
                '',
                '',
                '',

                'Total Amount:',
                '',
                ' ${result['total_amount']}'
              ],
              for (var i = 0; i < 3; i++)
                <String>[
                  '',
                  '',
                  '',

                  '',
                  '',
                  ''
                ],
            ]

        ),




        Header(level: 4,child:Column(children: [
          Container(height: 20),
          Container(height: 5,
              color: PdfColors.lightBlue
          ),
          Container(

            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                Container(
                    height: 30),
                getRowDesign(

                  basicInfo.organisation,
                  15,

                ),
                Container(height: 30),

                getRowDesign(
                  'Auth Signatory',
                  10,

                ),
              ],
            ),
          ),

        ]),
        ),



      ]));
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/receipt.pdf';
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
      text,
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
      text,
      style: TextStyle(
          fontSize: 20,
         color: PdfColors.blue,
          fontWeight: FontWeight.bold),
    ),
  );
}
