import 'package:flutter/material.dart';

import 'ProductDetails.dart';

class CartSummery {
  int id;
  String unit;
  String image;
  String amount;
  String gstRate;
  String product;
  String minOrder;
  String extraParams;

  CartSummery(this.id, this.unit, this.image, this.amount, this.gstRate,
      this.product, this.minOrder, this.extraParams);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraParams'] = this.extraParams;
    data['minOrder'] = this.minOrder;
    data['product'] = this.product;
    data['gstRate'] = this.gstRate;
    data['amount'] = this.amount;
    data['image'] = this.image;
    data['unit'] = this.unit;
    data['id'] = this.id;
    return data;
  }

  CartSummery.fromJson(Map<String, dynamic> json) {
    extraParams = json['extraParams'];
    minOrder = json['minOrder'];
    product = json['product'];
    gstRate = json['gstRate'];
    amount = json['amount'];
    image = json['image'];
    unit = json['unit'];
    id = json['id'];
  }

  CartSummery.fromProductDetails(ProductDetails details) {
    amount = details.tradePrice;
    gstRate = details.gstRate;
    product = details.name;
    image = details.image;
    unit = details.unit;
    id = details.id;

    extraParams = '';
  }

  TextEditingController controller = TextEditingController(text: '1');

}
