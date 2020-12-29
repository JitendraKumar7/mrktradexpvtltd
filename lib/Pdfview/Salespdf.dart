import 'package:mrktradexpvtltd/Pdfview/pdf_viewer_page.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;

reportView(context, basicInfo, dataTable, result, location) async {
  final Document pdf = Document();

  List<String> _productId = result['product_id'].cast<String>();
  List<String> _product = result['product'].cast<String>();
  List<String> _quantity = result['quantity'].cast<String>();
  List<String> _unit = result['unit'].cast<String>();
  List<String> _amount = result['amount'].cast<String>();
  int total = 0;
  int length = _product.length;

  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        return Container(
            child: Column(children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              child: Text('ORDER SUMMERY',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getRowDesign(
                      '${result['dispatch_status']}',
                      10,
                    ),
                    getRowDesign(
                      '${result['firm_name']}',
                      12,
                    ),
                    getRowDesign(
                      '' + basicInfo.mobileNumber,
                      10,
                    ),
                    getRowDesign(
                      '${result['address']}',
                      9,
                    ),
                    getRowDesign(
                      ' ${result['address1']} ${result['address2']} ',
                      9,
                    ),
                    getRowDesign(
                      '${result['remark']}',
                      10,
                    ),
                  ],
                ),
              ),
              Container(width: 40),
              Container(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getRowDesign(
                      'ORDER ID:- ${result['booking_id']}',
                      10,
                    ),
                    getRowDesign(
                      basicInfo.organisation,
                      12,
                    ),
                    getRowDesign(
                      location.address,
                      9,
                    ),
                    getRowDesign(
                      'GST No :- ' + location.gstNo,
                      10,
                    ),
                    Container(height: 30),
                    getRowDesign(
                      'Date :- ${result['timestamp']}',
                      10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]));
      },
      footer: (Context context) {
        return Row(children: [
          getRowDesign(
            "This document is powered by Konnectmybusiness.com",
            8,
          ),
          Container(width: 60),
          Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)))
        ]);
      },
      build: (Context context) => <Widget>[
            Table.fromTextArray(
                context: context,
                cellStyle: TextStyle(color: PdfColors.black, fontSize: 8),
                rowDecoration: BoxDecoration(borderRadius: 0),
                border:
                    TableBorder(verticalInside: false, horizontalInside: false),
                headerDecoration: new BoxDecoration(
                  color: PdfColors.lightBlue,
                ),
                tableWidth: TableWidth.max,
                defaultColumnWidth: FixedColumnWidth(250.0),
                headerStyle: TextStyle(
                    color: PdfColors.white, fontWeight: FontWeight.bold),
                data: <List<String>>[
                  <String>[
                    '#ID',
                    'PRODUCT',
                    'UNIT',
                    'QUANTITY',
                    'PRODUCT RATE'
                  ],
                  for (int i = 0; i < length; i++)
                    <String>[
                      '${_productId[i]})',
                      '${_product[i]}',
                      '${_unit[i]}',
                      '${_quantity[i]}',
                      '${_amount[i]}'
                    ],
                  for (int i = 0; i < 3; i++) <String>['', '', '', '', ''],
                ]),
          ]));
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/${result['company_name']}SalesOrder.pdf';
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
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
    ),
  );
}
