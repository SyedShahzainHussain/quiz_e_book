import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/model/contact_model.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class GetContactRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<List<ContactModel>> getContact(String token) async {
    try {
      dynamic response = await baseApiServices.getGetApiResponse(AppUrl.contact,
          headers: {"Authorization": "Bearer $token"});
      final data = response as List;
      return data.map((dynamic json) => ContactModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
