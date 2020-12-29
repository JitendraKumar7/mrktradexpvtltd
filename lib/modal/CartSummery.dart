import 'package:flutter/material.dart';

import 'ProductDetails.dart';

class CartSummery {
  int id;
  String unit;
  String image;
  String stock;
  String amount;
  String gstRate;
  String product;
  String minOrder;
  String checkStock;
  String extraParams;

  String price;
  String quantity;
  String discount;
  String discountOn;

  CartSummery(
      this.id,
      this.unit,
      this.image,
      this.amount,
      this.gstRate,
      this.product,
      this.minOrder,
      this.stock,
      this.checkStock,
      this.extraParams,
      this.price,
      this.quantity,
      this.discount,
      this.discountOn) {
    this.controller.text = quantity ?? '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['discountOn'] = this.discountOn;
    data['extraParams'] = this.extraParams;
    data['checkStock'] = this.checkStock;
    data['minOrder'] = this.minOrder;
    data['product'] = this.product;
    data['gstRate'] = this.gstRate;
    data['amount'] = this.amount;
    data['stock'] = this.stock;
    data['image'] = this.image;
    data['unit'] = this.unit;
    data['id'] = this.id;
    return data;
  }

  CartSummery.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    quantity = json['quantity'];
    discount = json['discount'];
    discountOn = json['discountOn'];
    extraParams = json['extraParams'];
    checkStock = json['checkStock'];
    minOrder = json['minOrder'];
    product = json['product'];
    gstRate = json['gstRate'];
    amount = json['amount'];
    stock = json['stock'];
    image = json['image'];
    unit = json['unit'];
    id = json['id'];

    controller.text = json['quantity'];
  }

  CartSummery.fromProductDetails(ProductDetails details) {
    price = details.price;
    discount = details.discount;
    discountOn = details.discountOn;

    checkStock = details.checkStock;
    amount = details.tradePrice;
    gstRate = details.gstRate;
    minOrder = details.moq;
    product = details.name;
    stock = details.stock;
    image = details.image;
    unit = details.unit;
    id = details.id;

    extraParams = '';

  }

  TextEditingController controller = TextEditingController(text: '1');
}
