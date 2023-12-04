abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url, {Map<String, String>? headers});
  Future<dynamic> getPostApiResponse(String url, dynamic body,
      {Map<String, String>? headers});
  Future<dynamic> getRegisterApiResponse(String url, dynamic body);
  Future<dynamic> updateAPiResponse(String url, dynamic body,{Map<String, String>? headers});
}
