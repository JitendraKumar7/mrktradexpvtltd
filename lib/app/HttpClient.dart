import 'dart:convert';
import 'AppConstants.dart';

import 'package:http/http.dart' as http;

class HttpClient extends AppConstants {
  //final String base = 'https://meo.co.in/meoApiPro/konnectBusiness_v4/index.php/';
  final String base = 'https://meo.co.in/meoApiPro/kmb_v1/index.php/';

  Future<String> getListingData(int pos) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['new_arrival'] = 0;
    params['top_trending'] = 0;
    params['feature_product'] = 0;
    params['deal_of_the_month'] = 0;

    switch (pos) {
      case 0:
        params['top_trending'] = 1;
        break;
      case 1:
        params['new_arrival'] = 1;
        break;
      case 2:
        params['deal_of_the_month'] = 1;
        break;
      case 3:
        params['feature_product'] = 1;
        break;
    }

    print(params);
    final http.Response response = await http.post(
      '${base}getWebstoreLandingListingData',
      body: jsonEncode(params),
    );

    print('Response Body ${response.body}');
    return response.body;
  }

  Future<String> getCoverImage() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;

    final http.Response response = await http.post(
      '${base}getCoverImageWebstorePremium',
      body: jsonEncode(params),
    );

    print('Response Body ${response.body}');
    return response.body;
  }

  Future<String> landingPage() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;

    final http.Response response = await http.post(
      '${base}checkLandingPageShowOrNot',
      body: jsonEncode(params),
    );

    print('Response Body ${response.body}');
    return response.body;
  }

  Future<String> getCashBankGroup() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;

    final http.Response response = await http.post(
      '${base}getCashBankGroup',
      body: jsonEncode(params),
    );

    print('Response Body ${response.body}');
    return response.body;
  }

  Future<String> addPartyMasterPayment(Map params) async {
    params['konnect_id'] = konnectId;
    params['ReceiptType'] = 'Credit';
    params['PaymentMode'] = 'Cash';
    params['receipt_by'] = '';

    print('addPartyMasterPayment ${params.toString()}');
    final http.Response response = await http.post(
      '${base}addPartyMasterPayment',
      body: jsonEncode(params),
    );

    print('Response Body ${response.body}');
    return response.body;
  }
}
