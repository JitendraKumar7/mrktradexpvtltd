class KonnectDetails {
  BasicInfo _basicInfo;

  List<Bank> _bank;
  List<Msme> _msme;
  List<Offer> _offer;
  List<About> _about;
  List<GstIn> _gstin;
  List<Website> _website;
  List<DrugLic> _drugLic;
  List<Location> _location;
  List<CoverImage> _coverimage;
  List<WhatsAppHeader> _whatsappheader;
  List<CustomerSupport> _customerSupport;
  List<WhatsAppTemplate> _whatsappTemplate;
  List<WebStoreHeader> _konnectWebstoreHeader;
  List<WebStoreTemplate> _konnectWebstoreTemplate;

  BasicInfo get basicInfo => _basicInfo;

  List<Bank> get bank => _bank;

  List<Msme> get msme => _msme;

  List<Offer> get offer => _offer;

  List<About> get about => _about;

  List<GstIn> get gstin => _gstin;

  List<Website> get website => _website;

  List<DrugLic> get drugLic => _drugLic;

  List<Location> get location => _location;

  List<CoverImage> get coverImage => _coverimage;

  List<WhatsAppHeader> get whatsappheader => _whatsappheader;

  List<CustomerSupport> get customerSupport => _customerSupport;

  List<WhatsAppTemplate> get whatsappTemplate => _whatsappTemplate;

  List<WebStoreHeader> get konnectWebstoreHeader => _konnectWebstoreHeader;

  List<WebStoreTemplate> get konnectWebstoreTemplate =>
      _konnectWebstoreTemplate;

  KonnectDetails.fromJson(Map<String, dynamic> json) {
    if (json['konnect_webstore_header'] != null) {
      _konnectWebstoreHeader = new List<WebStoreHeader>();
      json['konnect_webstore_header'].forEach((v) {
        _konnectWebstoreHeader.add(new WebStoreHeader.fromJson(v));
      });
    }
    if (json['konnect_webstore_template'] != null) {
      _konnectWebstoreTemplate = new List<WebStoreTemplate>();
      json['konnect_webstore_template'].forEach((v) {
        _konnectWebstoreTemplate.add(new WebStoreTemplate.fromJson(v));
      });
    }
    if (json['whatsapp_template'] != null) {
      _whatsappTemplate = new List<WhatsAppTemplate>();
      json['whatsapp_template'].forEach((v) {
        _whatsappTemplate.add(new WhatsAppTemplate.fromJson(v));
      });
    }
    _basicInfo = json['basicInfo'] != null
        ? new BasicInfo.fromJson(json['basicInfo'])
        : null;
    if (json['about'] != null) {
      _about = new List<About>();
      json['about'].forEach((v) {
        _about.add(new About.fromJson(v));
      });
    }
    if (json['website'] != null) {
      _website = new List<Website>();
      json['website'].forEach((v) {
        _website.add(new Website.fromJson(v));
      });
    }
    if (json['location'] != null) {
      _location = new List<Location>();
      json['location'].forEach((v) {
        _location.add(new Location.fromJson(v));
      });
    }
    if (json['customerSupport'] != null) {
      _customerSupport = new List<CustomerSupport>();
      json['customerSupport'].forEach((v) {
        _customerSupport.add(new CustomerSupport.fromJson(v));
      });
    }
    if (json['bank'] != null) {
      _bank = new List<Bank>();
      json['bank'].forEach((v) {
        _bank.add(new Bank.fromJson(v));
      });
    }
    if (json['gstin'] != null) {
      _gstin = new List<GstIn>();
      json['gstin'].forEach((v) {
        _gstin.add(new GstIn.fromJson(v));
      });
    }
    if (json['drug_lic'] != null) {
      _drugLic = new List<DrugLic>();
      json['drug_lic'].forEach((v) {
        _drugLic.add(new DrugLic.fromJson(v));
      });
    }
    if (json['msme'] != null) {
      _msme = new List<Msme>();
      json['msme'].forEach((v) {
        _msme.add(new Msme.fromJson(v));
      });
    }
    if (json['offer'] != null) {
      _offer = new List<Offer>();
      json['offer'].forEach((v) {
        _offer.add(new Offer.fromJson(v));
      });
    }
    if (json['whatsappheader'] != null) {
      _whatsappheader = new List<WhatsAppHeader>();
      json['whatsappheader'].forEach((v) {
        _whatsappheader.add(new WhatsAppHeader.fromJson(v));
      });
    }
    if (json['coverimage'] != null) {
      _coverimage = new List<CoverImage>();
      json['coverimage'].forEach((v) {
        _coverimage.add(new CoverImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._konnectWebstoreHeader != null) {
      data['konnect_webstore_header'] =
          this._konnectWebstoreHeader.map((v) => v.toJson()).toList();
    }
    if (this._konnectWebstoreTemplate != null) {
      data['konnect_webstore_template'] =
          this._konnectWebstoreTemplate.map((v) => v.toJson()).toList();
    }
    if (this._whatsappTemplate != null) {
      data['whatsapp_template'] =
          this._whatsappTemplate.map((v) => v.toJson()).toList();
    }
    if (this._basicInfo != null) {
      data['basicInfo'] = this._basicInfo.toJson();
    }
    if (this._about != null) {
      data['about'] = this._about.map((v) => v.toJson()).toList();
    }
    if (this._website != null) {
      data['website'] = this._website.map((v) => v.toJson()).toList();
    }
    if (this._location != null) {
      data['location'] = this._location.map((v) => v.toJson()).toList();
    }
    if (this._customerSupport != null) {
      data['customerSupport'] =
          this._customerSupport.map((v) => v.toJson()).toList();
    }
    if (this._bank != null) {
      data['bank'] = this._bank.map((v) => v.toJson()).toList();
    }
    if (this._gstin != null) {
      data['gstin'] = this._gstin.map((v) => v.toJson()).toList();
    }
    if (this._drugLic != null) {
      data['drug_lic'] = this._drugLic.map((v) => v.toJson()).toList();
    }
    if (this._msme != null) {
      data['msme'] = this._msme.map((v) => v.toJson()).toList();
    }
    if (this._offer != null) {
      data['offer'] = this._offer.map((v) => v.toJson()).toList();
    }
    if (this._whatsappheader != null) {
      data['whatsappheader'] =
          this._whatsappheader.map((v) => v.toJson()).toList();
    }
    if (this._coverimage != null) {
      data['coverimage'] = this._coverimage.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WebStoreHeader {
  int _webHeaderId;
  String _webHeader;

  WebStoreHeader({int webHeaderId, String webHeader}) {
    this._webHeaderId = webHeaderId;
    this._webHeader = webHeader;
  }

  int get webHeaderId => _webHeaderId;

  String get webHeader => _webHeader;

  WebStoreHeader.fromJson(Map<String, dynamic> json) {
    _webHeaderId = json['konnect_webstore_header_id'];
    _webHeader = json['konnect_webstore_header'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['konnect_webstore_header_id'] = this._webHeaderId;
    data['konnect_webstore_header'] = this._webHeader;
    return data;
  }
}

class WebStoreTemplate {
  int _webTemplateId;
  String _webTemplate;

  int get webTemplateId => _webTemplateId;

  String get webTemplate => _webTemplate;

  WebStoreTemplate.fromJson(Map<String, dynamic> json) {
    _webTemplateId = json['whatsapp_webstore_template_id'];
    _webTemplate = json['whatsapp_webstore_template'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['whatsapp_webstore_template_id'] = this._webTemplateId;
    data['whatsapp_webstore_template'] = this._webTemplate;
    return data;
  }
}

class WhatsAppHeader {
  int _id;
  String _contact;

  WhatsAppHeader({int id, String contact}) {
    this._id = id;
    this._contact = contact;
  }

  int get id => _id;

  String get contact => _contact;

  WhatsAppHeader.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['contact'] = this._contact;
    return data;
  }
}

class WhatsAppTemplate {
  int _templateId;
  String _template;

  int get templateId => _templateId;

  String get template => _template;

  WhatsAppTemplate.fromJson(Map<String, dynamic> json) {
    _templateId = json['whatsapp_template_id'];
    _template = json['whatsapp_template'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['whatsapp_template_id'] = this._templateId;
    data['whatsapp_template'] = this._template;
    return data;
  }
}

class BasicInfo {
  String _name;
  String _email;
  String _designation;
  String _konnectLogo;
  String _mobileNumber;
  String _organisationName;
  String _otherDescription;
  String _natureOfBusiness;
  String _categoryOfBusiness;

  String get name => _name;

  String get natureOfBusiness => _natureOfBusiness;

  String get categoryOfBusiness => _categoryOfBusiness;

  String get otherDescription => _otherDescription;

  String get designation => _designation;

  String get email => _email;

  String get organisation => _organisationName;

  String get mobileNumber => _mobileNumber;

  String get konnectLogo => _konnectLogo;

  BasicInfo.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _natureOfBusiness = json['nature_of_business'];
    _categoryOfBusiness = json['category_of_business'];
    _otherDescription = json['other_description'];
    _designation = json['designation'];
    _email = json['email'];
    _organisationName = json['organisation_name'];
    _mobileNumber = json['mobile_number'];
    _konnectLogo = json['konnect_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['nature_of_business'] = this._natureOfBusiness;
    data['category_of_business'] = this._categoryOfBusiness;
    data['other_description'] = this._otherDescription;
    data['designation'] = this._designation;
    data['email'] = this._email;
    data['organisation_name'] = this._organisationName;
    data['mobile_number'] = this._mobileNumber;
    data['konnect_logo'] = this._konnectLogo;
    return data;
  }
}

class About {
  int _id;
  String _description;

  About({int id, String description}) {
    this._id = id;
    this._description = description;
  }

  int get id => _id;

  String get description => _description;

  About.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['description'] = this._description;
    return data;
  }
}

class Website {
  int _id;
  String _website;

  Website({int id, String website}) {
    this._id = id;
    this._website = website;
  }

  int get id => _id;

  String get website => _website;

  Website.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['website'] = this._website;
    return data;
  }
}

class Location {
  int _id;
  String _addressType;
  String _companyName;
  String _addressLine1;
  String _addressLine2;
  String _addressLine3;
  String _email;
  String _gstNo;
  String _websiteUrl;
  String _landline;
  String _latitude;
  String _longitude;

  int get id => _id;

  String get addressType => _addressType;

  String get companyName => _companyName;

  String get addressLine1 => _addressLine1;

  String get addressLine2 => _addressLine2;

  String get addressLine3 => _addressLine3;

  String get email => _email;

  String get gstNo => _gstNo;

  String get websiteUrl => _websiteUrl;

  String get landline => _landline;

  String get latitude => _latitude;

  String get longitude => _longitude;

  String get address => addressLine1 + ' ' + addressLine2 + ' ' + addressLine3;

  Location.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _companyName = json['company_name'];
    _addressLine1 = json['address_line1'];
    _addressLine2 = json['address_line2'];
    _addressLine3 = json['address_line3'];
    _email = json['email'];
    _gstNo = json['gst_no'];
    _websiteUrl = json['website_url'];
    _landline = json['landline'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['address_type'] = this._addressType;
    data['company_name'] = this._companyName;
    data['address_line1'] = this._addressLine1;
    data['address_line2'] = this._addressLine2;
    data['address_line3'] = this._addressLine3;
    data['email'] = this._email;
    data['gst_no'] = this._gstNo;
    data['website_url'] = this._websiteUrl;
    data['landline'] = this._landline;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    return data;
  }
}

class CustomerSupport {
  int _id;
  String _title;
  String _contactNumber;
  String _mailId;
  String _tolfreeNumber;

  CustomerSupport(
      {int id,
      String title,
      String contactNumber,
      String mailId,
      String tolfreeNumber}) {
    this._id = id;
    this._title = title;
    this._contactNumber = contactNumber;
    this._mailId = mailId;
    this._tolfreeNumber = tolfreeNumber;
  }

  int get id => _id;

  String get title => _title;

  String get contactNumber => _contactNumber;

  String get mailId => _mailId;

  String get tolfreeNumber => _tolfreeNumber;

  CustomerSupport.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _contactNumber = json['contact_number'];
    _mailId = json['mail_id'];
    _tolfreeNumber = json['tolfree_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['contact_number'] = this._contactNumber;
    data['mail_id'] = this._mailId;
    data['tolfree_number'] = this._tolfreeNumber;
    return data;
  }
}

class Bank {
  int _id;
  String _bankName;
  String _accNo;
  String _ifscCode;
  String _newBranch;
  String _upi;

  Bank(
      {int id,
      String bankName,
      String accNo,
      String ifscCode,
      String newBranch,
      String upi}) {
    this._id = id;
    this._bankName = bankName;
    this._accNo = accNo;
    this._ifscCode = ifscCode;
    this._newBranch = newBranch;
    this._upi = upi;
  }

  int get id => _id;

  String get bankName => _bankName;

  String get accNo => _accNo;

  String get ifscCode => _ifscCode;

  String get newBranch => _newBranch;

  String get upi => _upi;

  Bank.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _bankName = json['bank_name'];
    _accNo = json['acc_no'];
    _ifscCode = json['ifsc_code'];
    _newBranch = json['new_branch'];
    _upi = json['upi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['bank_name'] = this._bankName;
    data['acc_no'] = this._accNo;
    data['ifsc_code'] = this._ifscCode;
    data['new_branch'] = this._newBranch;
    data['upi'] = this._upi;
    return data;
  }

  int get hashCode => id.hashCode;

  bool operator ==(Object other) => other is Bank && other.id == id;
}

class GstIn {
  int _id;
  String _gstin;
  String _state;

  GstIn({int id, String gstin, String state}) {
    this._id = id;
    this._gstin = gstin;
    this._state = state;
  }

  int get id => _id;

  String get gstin => _gstin;

  String get state => _state;

  GstIn.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _gstin = json['gstin'];
    _state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['gstin'] = this._gstin;
    data['state'] = this._state;
    return data;
  }
}

class DrugLic {
  int _id;
  String _dlNumber;

  DrugLic({int id, String dlNumber}) {
    this._id = id;
    this._dlNumber = dlNumber;
  }

  int get id => _id;

  String get dlNumber => _dlNumber;

  DrugLic.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _dlNumber = json['dl_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['dl_number'] = this._dlNumber;
    return data;
  }
}

class Msme {
  int _id;
  String _enterpriseName;
  String _uanNumber;

  Msme({int id, String enterpriseName, String uanNumber}) {
    this._id = id;
    this._enterpriseName = enterpriseName;
    this._uanNumber = uanNumber;
  }

  int get id => _id;

  String get enterpriseName => _enterpriseName;

  String get uanNumber => _uanNumber;

  Msme.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _enterpriseName = json['enterprise_name'];
    _uanNumber = json['uan_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['enterprise_name'] = this._enterpriseName;
    data['uan_number'] = this._uanNumber;
    return data;
  }
}

class Offer {
  int _id;
  String _title;
  String _image;
  String _image2;
  String _image3;
  String _image4;
  String _campaign;

  Offer(
      {int id,
      String title,
      String image,
      String image2,
      String image3,
      String image4,
      String campaign}) {
    this._id = id;
    this._title = title;
    this._image = image;
    this._image2 = image2;
    this._image3 = image3;
    this._image4 = image4;
    this._campaign = campaign;
  }

  int get id => _id;

  String get title => _title;

  String get image => _image;

  String get image2 => _image2;

  String get image3 => _image3;

  String get image4 => _image4;

  String get campaign => _campaign;

  Offer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _image2 = json['image2'];
    _image3 = json['image3'];
    _image4 = json['image4'];
    _campaign = json['campaign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['image'] = this._image;
    data['image2'] = this._image2;
    data['image3'] = this._image3;
    data['image4'] = this._image4;
    data['campaign'] = this._campaign;
    return data;
  }
}

class CoverImage {
  int _id;
  String _coverimage;

  CoverImage({int id, String coverimage}) {
    this._id = id;
    this._coverimage = coverimage;
  }

  int get id => _id;

  String get image => _coverimage;

  CoverImage.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _coverimage = json['coverimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['coverimage'] = this._coverimage;
    return data;
  }
}
