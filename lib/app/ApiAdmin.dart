import 'package:dio/dio.dart';

import 'AppConstants.dart';

class ApiAdmin extends AppConstants {
  Dio getInstance() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/',
        headers: {'Content-type': 'application/json; charset=utf-8'},
        connectTimeout: 90 * 1000,
        receiveTimeout: 60 * 1000,
      ),
    );
  }

  Future<Response<Map>> getSalesOrder() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getSalesOrder', data: params);
  }

  Future<Response<Map>> getPartyMaster() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getPartyMaster', data: params);
  }

  Future<Response<Map>> getProformaData() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getProformaData', data: params);
  }

  Future<Response<Map>> getPaymentReceipt() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getPaymentReceipt', data: params);
  }

  Future<Response<Map>> getLedger(String from) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['from'] = from;
    return await getInstance().post('getLedger', data: params);
  }

  Future<Response<Map>> getSaleInvoice(String from) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['from'] = from;
    return await getInstance().post('getSaleInvoice', data: params);
  }

  Future<Response<Map>> getPurchaseData(String from) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['from'] = from;
    return await getInstance().post('getPurchaseData', data: params);
  }

  Future<Response<Map>> getLedgerById(String id) async {
    return await getInstance().post('getLedgerById', data: {'id': id});
  }

  Future<Response<Map>> getSalesOrderById(String id) async {
    print('getSalesOrderById $id');
    return await getInstance().post('getSalesOrderById', data: {'id': id});
  }

  Future<Response<Map>> getSalesInvoiceById(String id) async {
    return await getInstance().post('getSalesInvoiceById', data: {'id': id});
  }

  Future<Response<Map>> getPaymentReceiptById(String id) async {
    return await getInstance().post('getPaymentReceiptById', data: {'id': id});
  }

  Future<Response<Map>> getProformaInvoiceById(String id) async {
    return await getInstance().post('getProformaInvoiceById', data: {'id': id});
  }

  Future<Response<Map>> getPurchaseInvoiceById(String id) async {
    return await getInstance().post('getPurchaseInvoiceById', data: {'id': id});
  }

  Future<Response<Map>> getLinkUserLedger(int id, String from) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['from'] = from;
    params['id'] = id;
    return await getInstance().post('getLinkUserSalesOrder', data: params);
  }

  Future<Response<Map>> getLinkUserPayReceipt(int id) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['id'] = id;
    return await getInstance().post('getLinkUserPayReceipt', data: params);
  }

  Future<Response<Map>> getLinkUserSalesOrder(int id) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['id'] = id;
    return await getInstance().post('getLinkUserSalesOrder', data: params);
  }

  Future<Response<Map>> getLinkUserPartyMaster(int id) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['id'] = id;
    return await getInstance().post('getLinkUserPartyMaster', data: params);
  }

  Future<Response<Map>> getLinkUserSalesInvoice(int id, String from) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['from'] = from;
    params['id'] = id;
    return await getInstance().post('getLinkUserSalesInvoice', data: params);
  }

  Future<Response<Map>> getLinkUserProformaInvoice(int id) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    params['id'] = id;
    return await getInstance().post('getLinkUserProformaInvoice', data: params);
  }

  Future<Response<Map>> login(String mobile, String password) async {
    Map params = Map<String, dynamic>();
    params['mobile_number'] = mobile;
    params['konnect_id'] = konnectId;
    params['password'] = password;
    params['user_id'] = userId;
    return await getInstance().post('adminLogin', data: params);
  }

  Future<Response<Map>> coAdminLogin(String mobile, String password) async {
    Map params = Map<String, dynamic>();
    params['mobile_number'] = mobile;
    params['konnect_id'] = konnectId;
    params['password'] = password;
    params['user_id'] = userId;
    return await getInstance().post('coAdminLogin', data: params);
  }

  Future<Response<Map>> linkUserLogin(String mobile, String password) async {
    Map params = Map<String, dynamic>();
    params['mobile_number'] = mobile;
    params['konnect_id'] = konnectId;
    params['password'] = password;
    params['user_id'] = userId;
    return await getInstance().post('linkUserLogin', data: params);
  }

/*https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLedgerById
{"id":"1330"}

https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getSalesInvoiceById
{"id":"1330"}

https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserLedger
{"konnet_id":"1330"}


https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserPayReceipt
{"konnect_id":"1330"}

https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserPartyMaster
{"konnect_id":"1330","user_id":"406"}

https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserSalesInvoice
{"konnect_id":"1330"}

  1 . https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/adminLogin
  {"mobile_number": "9794751890","password":"123456"}

  2. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getPurchaseData
  {"konnect_id": "1330","from":"KMB"}

  3.   https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getProformaData
  {"konnect_id": "1330"}

  4. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLedger
  {"konnect_id": "1330"}

  5. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getSaleInvoice
  {"konnect_id": "1330"}

  6. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getSalesOrder
  {"konnect_id": "1330"}

  7.https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getPartyMaster
  {"konnect_id": "1330","user_id":"406"}

  8. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/linkUserLogin
  {"mobile_number":"9794751890","password":"123456","konnect_id":"6151"}

  9. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/coAdminLogin


  10. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getPaymentReceipt
  {"konnect_id":"1330"}

  12. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getPurchaseInvoiceById
  {"id":"1330"}{"mobile_number":"9794751890","password":"123456","konnect_id":"6151"}

  13. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getSalesOrderById
  {"id":"1330"}

  14. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getProformaInvoiceById
  {"id":"1330"}

  15. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getPaymentReceiptById
  {"id":"1330"}

  16. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserSalesOrder
  {"konnect_id":"1330"}

  17. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserSalesInvoice
  {"konnect_id":"1330"}

  18. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserPurchaseInvoice
  {"konnect_id":"1330"}

  19. https://meo.co.in/meoApiPro/kmbAdmin_v1/index.php/getLinkUserProformaInvoice
  {"konnect_id":"1330"}

  https://meo.co.in/meoApiPro/konnectBusiness_v4/index.php/checkLandingPageShowOrNot
  {"konnect_id":"1330"}

  https://meo.co.in/meoApiPro/konnectBusiness_v4/index.php/getCoverImageWebstorePremium
  {"konnect_id":"1330"}

  https://meo.co.in/meoApiPro/konnectBusiness_v4/index.php/getWebstoreLandingListingData
  {"konnect_id":"1330","top_trending":"0","new_arrival":"0","feature_product":"0","deal_of_the_month":"1"}

  NOTE : send 1 value params for get data of any one.  please send 1 only with 1 params at a time .

  */

}
