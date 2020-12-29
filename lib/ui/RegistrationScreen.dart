import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';

import './base/libraryExport.dart';

class RegisterScreen extends StatelessWidget {
  final KonnectDetails konnectDetails;

  RegisterScreen(this.konnectDetails);

  @override
  Widget build(BuildContext context) {
    final List<CoverImage> _coverImage = konnectDetails.coverImage;
    final List<DrugLic> _drugLic = konnectDetails.drugLic;
    final BasicInfo _basicInfo = konnectDetails.basicInfo;
    final List<GstIn> _gstin = konnectDetails.gstin;
    final List<Msme> _msme = konnectDetails.msme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Registrations'),
      ),
      body: ListView(children: <Widget>[
        CarouselSlider(images: _coverImage, info: _basicInfo),
        GFAccordion(
            title: 'GST IN',
            collapsedIcon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
            expandedIcon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
            textStyle: TextStyle(color: Colors.white, fontSize: 16),
            collapsedTitlebackgroundColor: Colors.blue.shade300,
            expandedTitlebackgroundColor: Colors.blueGrey,
            contentPadding: EdgeInsets.only(top: 9, bottom: 9),
            contentChild: _gstin.isEmpty
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Text(
                          'Empty',
                          style: TextStyle(backgroundColor: Colors.white),
                        )))
                : Column(
                    children: _gstin.map((item) {
                    return ListTile(
                        title: Padding(
                            padding: EdgeInsets.only(top: 6, bottom: 6),
                            child: Text(
                              item.gstin,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        subtitle: Padding(
                            padding: EdgeInsets.only(top: 6, bottom: 6),
                            child: Text(
                              item.state,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            )));
                  }).toList())),
        GFAccordion(
            title: 'MSME Licence',
            textStyle: TextStyle(color: Colors.white, fontSize: 16),
            collapsedIcon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
            expandedIcon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
            collapsedTitlebackgroundColor: Colors.blue.shade300,
            expandedTitlebackgroundColor: Colors.blueGrey,
            contentPadding: EdgeInsets.only(top: 9, bottom: 9),
            contentChild: _msme.isEmpty
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Text(
                          'Empty',
                          style: TextStyle(backgroundColor: Colors.white),
                        )))
                : Column(
                    children: _msme.map((item) {
                    return ListTile(
                        title: Padding(
                            padding: EdgeInsets.only(top: 6, bottom: 6),
                            child: Text(
                              item.enterpriseName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        subtitle: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              item.uanNumber,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            )));
                  }).toList())),
        GFAccordion(
            title: 'Drug Licence',
            textStyle: TextStyle(color: Colors.white, fontSize: 16),
            collapsedIcon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
            expandedIcon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
            collapsedTitlebackgroundColor: Colors.blue.shade300,
            expandedTitlebackgroundColor: Colors.blueGrey,
            contentPadding: EdgeInsets.only(top: 9, bottom: 9),
            contentChild: _drugLic.isEmpty
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Text(
                          'Empty',
                          style: TextStyle(backgroundColor: Colors.white),
                        )))
                : Column(
                    children: _drugLic.map((item) {
                      return Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            item.dlNumber,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ));
                    }).toList(),
                  )),
      ]),
    );
  }
}
