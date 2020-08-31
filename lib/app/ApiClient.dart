import 'package:dio/dio.dart';

import 'AppConstants.dart';

class ApiClient extends AppConstants {
  Dio getInstance() {
    return Dio(BaseOptions(
      headers: {'Content-type': 'application/json; charset=utf-8'},
      baseUrl: 'https://meo.co.in/meoApiPro/kmb_v1/index.php/',
      connectTimeout: 90 * 1000,
      receiveTimeout: 60 * 1000,
    ));
  }

  Future<Response<Map>> getGallery() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getGallery', data: params);
  }

  Future<Response<Map>> getPaymentButton() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getPaymentButton', data: params);
  }

  Future<Response<Map>> addPartyMaster(Map params) async {
    params['konnect_id'] = konnectId;
    params['add_from'] = 'KMB';
    return await getInstance().post('addPartyMasterAccount', data: params);
  }

  Future<Response<Map>> updatePartyMaster(Map params) async {
    print(params);
    return await getInstance().post('updatePartyMasterDB', data: params);
  }

  Future<Response<Map>> uploadFile(String filePath) async {
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    return await getInstance().post('uploadFile', data: formData);
  }

  Future<Response<Map>> getPartyMasterProfile(int id) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['party_master_id'] = id;
    return await getInstance().post('getPartyMasterProfileData', data: params);
  }

  Future<Response<Map>> forgetPasswordOtp(String phone) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['mobile_number'] = phone;
    return await getInstance().post('forgetPasswordOtp', data: params);
  }

  Future<Response<Map>> loginPartyMaster(String id, String pwd) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['contact_number'] = id;
    params['password'] = pwd;
    return await getInstance().post('loginPartyMaster', data: params);
  }

  Future<Response<Map>> resetPass(String phone, String otp, String pwd) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['mobile_number'] = phone;
    params['new_password'] = pwd;
    params['otp_code'] = otp;
    return await getInstance().post('forgetPasswordForReset', data: params);
  }

  Future<Response<Map>> getWebstoreL1() async {
    return await getInstance()
        .post('getWebstoreL1', data: {'showcase_id': konnectId});
  }

  Future<Response<Map>> getCardDetails() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getCardDetail', data: params);
  }

  Future<Response<Map>> getProductCart() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('getAllKonnectItem', data: params);
  }

  Future<Response<Map>> checkPartyPermission() async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['user_id'] = userId;
    return await getInstance().post('checkPartyPermission', data: params);
  }

  Future<Response<Map>> getItemById(int itemId) async {
    return await getInstance().post('getWebstoreL5ById', data: {"id": itemId});
  }

  Future<Response<Map>> getWebstoreL2(int categoryId) async {
    print('getWebstoreL2');
    return await getInstance()
        .post('getWebstoreL2WithL3', data: {'master_category_id': categoryId});
  }

  Future<Response<Map>> getWebstoreL3(int subCategoryId) async {
    return await getInstance().post('getWebstoreL3WithL4',
        data: {'subcategoryItemwise_id': subCategoryId});
  }

  Future<Response<Map>> getWebstoreL4(int subCategoryId) async {
    return await getInstance().post('getWebstoreL4',
        data: {'showcase_id': konnectId, 'l3_id': subCategoryId});
  }

  Future<Response<Map>> checkPartyMaster(String loginId) async {
    Map params = Map<String, dynamic>();
    params['konnect_id'] = konnectId;
    params['login_id'] = loginId;
    return await getInstance().post('checkPartyMaster', data: params);
  }

  // Product List -- L2
  Future<Response<Map>> getSubCategoryProduct(int categoryId) async {
    Map params = Map<String, dynamic>();
    params['sub_category_id'] = categoryId;
    params['showcase_id'] = konnectId;
    return await getInstance().post('getWebstoreL5FromL2', data: params);
  }

  // Product List -- L3 or L4
  Future<Response<Map>> get3FourthProduct(int catId, int subId) async {
    return await getInstance().post('getWebstoreL5FromL3OrL4', data: {
      'showcase_id': konnectId,
      'categoryItemwise_id': catId,
      'subcategoryItemWise_id': subId
    });
  }

  Future<Response<Map>> addBooking(Map params) async {
    params['konnect_id'] = konnectId;
    params['card_user_id'] = userId;
    return await getInstance().post('addBookingNew', data: params);
  }

  // Party Master
  Future<Response<Map>> getLedgerData(int masterId) async {
    return await getInstance().post('getLedgerData',
        data: {'konnect_id': konnectId, 'partymaster_id': masterId});
  }

  Future<Response<Map>> getPaymentReceipt(int masterId) async {
    return await getInstance().post('getPaymentReceiptData',
        data: {'konnect_id': konnectId, 'partymaster_id': masterId});
  }

  Future<Response<Map>> getSalesOrderData(int masterId) async {
    return await getInstance().post('getSalesOrderData',
        data: {'konnect_id': konnectId, 'partymaster_id': masterId});
  }

  Future<Response<Map>> getSaleInvoiceData(int masterId) async {
    return await getInstance().post('getSaleData',
        data: {'konnect_id': konnectId, 'partymaster_id': masterId});
  }
}
