class ProductDetails {
  int _id;
  String _printName;
  String _name;
  String _unit;
  int _subCategoryId;
  String _subCategory;
  String _productMainCategoryId;
  int _masterCategoryId;
  String _subCategoryImage;
  String _productMainCategory;
  String _productMainSubCategoryId;
  String _productMainSubCategory;
  String _description;
  String _specification1;
  String _specification2;
  String _specification3;
  String _video;
  String _image;
  String _image2;
  String _image3;
  String _moq;
  String _discount;
  String _discountOn;
  String _productCode;
  String _gstRate;
  String _stock;
  String _checkedStock;
  String _price;
  String _offer;
  String _tradePrice;
  String _returnPolicy;
  String _paramsOneSelect;
  String _paramsTwoSelect;
  List<ArrayItemList> _arrayItemList;

  int get id => _id;

  String get printName => _printName;

  String get name => _name;

  String get unit => _unit;

  String get returnPolicy => _returnPolicy;

  int get subCategoryId => _subCategoryId;

  String get subCategory => _subCategory;

  String get productMainCategoryId => _productMainCategoryId;

  int get masterCategoryId => _masterCategoryId;

  String get subCategoryImage => _subCategoryImage;

  String get productMainCategory => _productMainCategory;

  String get productMainSubCategoryId => _productMainSubCategoryId;

  String get productMainSubCategory => _productMainSubCategory;

  String get description => _description;

  String get specification1 => _specification1;

  String get specification2 => _specification2;

  String get specification3 => _specification3;

  String get video => _video;

  String get image => _image;

  String get image2 => _image2;

  String get image3 => _image3;

  String get moq => _moq;

  String get discount => _discount;

  String get discountOn => _discountOn;

  String get productCode => _productCode;

  String get gstRate => _gstRate;

  String get stock => _stock;

  String get checkStock => _checkedStock;

  String get price => _price;

  String get offer => _offer;

  String get tradePrice => _tradePrice;

  String get paramsOneSelect => _paramsOneSelect;

  String get paramsTwoSelect => _paramsTwoSelect;

  List<ArrayItemList> get itemList => _arrayItemList;

  ProductDetails.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _printName = json['print_name'];
    _name = json['name'];
    _unit = json['unit'];
    _subCategoryId = json['sub_category_id'];
    _subCategory = json['sub_category'];
    _productMainCategoryId = json['product_main_category_id'];
    _masterCategoryId = json['master_category_id'];
    _subCategoryImage = json['sub_category_image'];
    _productMainCategory = json['product_main_category'];
    _productMainSubCategoryId = json['product_main_sub_category_id'];
    _productMainSubCategory = json['product_main_sub_category'];
    _description = json['description'];
    _specification1 = json['specification1'];
    _specification2 = json['specification2'];
    _specification3 = json['specification3'];
    _video = json['video'];
    _image = json['image'];
    _image2 = json['image2'];
    _image3 = json['image3'];
    _moq = json['moq'];
    _discount = json['discount'];
    _discountOn = json['discount_on'];
    _productCode = json['product_code'];
    _gstRate = json['gst_rate'];
    _stock = json['stock'];
    _checkedStock = json['checked_stock'];
    _price = json['price'];
    _offer = json['offer'];
    _tradePrice = json['trade_price'];
    _returnPolicy = json['return_policy'];
    _paramsOneSelect = json['parms_one_select'];
    _paramsTwoSelect = json['parms_two_select'];

    _arrayItemList = new List<ArrayItemList>();
    if (json['array_itemlist'] != null) {
      json['array_itemlist'].forEach((v) {
        _arrayItemList.add(ArrayItemList.fromJson(v));
      });
    }

    /* _parmsOne = List<String>.from(json['parms_one']);
    _parmsTwo = List<String>.from(json['parms_two']);
    _parmsStock = List<String>.from(json['parms_stock']);
    _parmsTradePrice = List<String>.from(json['parms_trade_price']);
    _parmsMrp = List<String>.from(json['parms_mrp']);

    if (json['array_itemlist'] != null) {
      _parmsOne = new List<String>();
      json['array_itemlist'].forEach((v) {
        _parmsOne.add(v);
      });
    }
    if (json['parms_two'] != null) {
      _parmsTwo = new List<String>();
      json['_parmsTwo'].forEach((v) {
        _parmsTwo.add(v);
      });
    }
    if (json['parms_stock'] != null) {
      _parmsStock = new List<String>();
      json['parms_stock'].forEach((v) {
        _parmsStock.add(v);
      });
    }
    if (json['parms_trade_price'] != null) {
      _parmsTradePrice = new List<String>();
      json['parms_trade_price'].forEach((v) {
        _parmsTradePrice.add(v);
      });
    }
    if (json['parms_mrp'] != null) {
      _parmsMrp = new List<String>();
      json['parms_mrp'].forEach((v) {
        _parmsMrp.add(v);
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['print_name'] = this._printName;
    data['name'] = this._name;
    data['unit'] = this._unit;
    data['sub_category_id'] = this._subCategoryId;
    data['sub_category'] = this._subCategory;
    data['product_main_category_id'] = this._productMainCategoryId;
    data['master_category_id'] = this._masterCategoryId;
    data['sub_category_image'] = this._subCategoryImage;
    data['product_main_category'] = this._productMainCategory;
    data['product_main_sub_category_id'] = this._productMainSubCategoryId;
    data['product_main_sub_category'] = this._productMainSubCategory;
    data['description'] = this._description;
    data['specification1'] = this._specification1;
    data['specification2'] = this._specification2;
    data['specification3'] = this._specification3;
    data['video'] = this._video;
    data['image'] = this._image;
    data['image2'] = this._image2;
    data['image3'] = this._image3;
    data['moq'] = this._moq;
    data['discount'] = this._discount;
    data['discount_on'] = this._discountOn;
    data['product_code'] = this._productCode;
    data['gst_rate'] = this._gstRate;
    data['stock'] = this._stock;
    data['checked_stock'] = this._checkedStock;
    data['price'] = this._price;
    data['offer'] = this._offer;
    data['trade_price'] = this._tradePrice;
    data['return_policy'] = this._returnPolicy;
    data['parms_one_select'] = this._paramsOneSelect;
    data['parms_two_select'] = this._paramsTwoSelect;

    data['array_itemlist'] =
        this._arrayItemList.map((v) => v.toJson()).toList();
    return data;
  }
}

class ArrayItemList {
  bool _checked;
  String _paramsOne;
  String _paramsTwo;
  String _paramsMrp;
  String _paramsStock;
  String _paramsTradePrice;

  set checked(bool value) {
    _checked = value;
  }

  bool get isChecked => _checked;

  String get paramsMrp => _paramsMrp;

  String get paramsOne => _paramsOne;

  String get paramsTwo => _paramsTwo;

  String get paramsStock => _paramsStock;

  String get paramsTradePrice => _paramsTradePrice;

  ArrayItemList.fromJson(Map<String, dynamic> json) {
    _paramsOne = json['parmsone'];
    _paramsTwo = json['parms_two'];
    _paramsMrp = json['parms_mrp'];
    _paramsStock = json['parms_stock'];
    _paramsTradePrice = json['parms_trade_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parmsone'] = this._paramsOne;
    data['parms_two'] = this.paramsTwo;
    data['parms_mrp'] = this.paramsMrp;
    data['parms_stock'] = this.paramsStock;
    data['parms_trade_price'] = this.paramsTradePrice;
    return data;
  }
}
