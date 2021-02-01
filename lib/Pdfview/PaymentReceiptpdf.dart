
import 'dart:typed_data';

import 'package:mrktradexpvtltd/Pdfview/pdf_viewer_page.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;




reportViewpayrecipt(context, basicInfo,result,location) async {



  final Document pdf = Document();




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
            decoration: const BoxDecoration(
                border:
                BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
           );
      },
      footer: (Context context) {
        return Row(
          children:[
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




        Header(level:0,child: Column(
          children: [
        Center(
        child:   Text('ORDER SUMMERY',
          style: Theme.of(context)
              .defaultTextStyle
              .copyWith(color: PdfColors.black,fontSize:14 ,fontWeight: FontWeight.bold)
          ,)
        ),
    Container(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 220,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[

                  getRowDesign(
                    basicInfo.organisation,
                    10,
                  ),
                  getRowDesign(
                    location.address,
                    10,
                  ),
                  getRowDesign(
                    'GST No :- ${location.gstNo}',
                    10,
                  ),
                  getRowDesign(
                    '' + basicInfo.mobileNumber,
                    10,
                  ),

                ],
              ),
            ),
            Container(
                width: 40
            ),
            Container(
width: 220,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  getRowDesign(
                    '${result['company_name']}',
                    10,
                  ),
                  getRowDesign(
                    '${result['address']}',
                    9,
                  ),
                  getRowDesign(
                    'Phone :- ${result['contact_number']}',
                    10,
                  ),
                  getRowDesign(
                    'Email Id :- ${result['email']}',
                    10,
                  ),
                  getRowDesign(
                    'GST No :- ${result['gst']}',
                    10,
                  ),



                ],
              ),
            ),
          ],
        ),

          ])),

        Table.fromTextArray(context: context, cellAlignment: Alignment.center,    cellStyle:TextStyle(color: PdfColors.black ,fontSize: 8) ,rowDecoration:BoxDecoration(borderRadius: 0),border: TableBorder(verticalInside: false,horizontalInside: false),

            headerDecoration: new BoxDecoration(color:  PdfColors.lightBlue,),tableWidth: TableWidth.max,defaultColumnWidth: FixedColumnWidth(250.0),
            headerStyle: TextStyle(color: PdfColors.white,fontWeight: FontWeight.bold),
            data: <List<String>>[
              <String>['Amnt in words', 'Amounts', 'Payment Mode','Receipt Type','Receipt By','Status'],


                <String>[  '${result['amount_figure']}',
                  '${result['amount_words']}',
                  '${result['payment_mode']}',
                  '${result['reciept_type']}',
                  '${result['reciept_by']}',
                  '${result['status']}'
                ],

            ]

        ),


        Header(level: 3,child:Column(children: [
            Container(height: 20),
          Container(height: 3,
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
        )]),),
      Header(level: 4,child: Container(

     height:30,




      )),



      ]));
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/${result['company_name']}receipt.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(path: path),
    ),
  );
}
final Uint8List fontData = File('open-sans.ttf').readAsBytesSync();
final ttf = Font.ttf(fontData.buffer.asByteData());
getRowDesign(String text, double fontSize) {
  return Padding(
    padding: EdgeInsets.only(top: 3, bottom: 3),
    child: Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          font: ttf,
          fontWeight: FontWeight.bold),
    ),
  );
}
