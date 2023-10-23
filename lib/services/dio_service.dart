import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioService {
  final _dio = Dio();

  DioService() {
    _dio.options.headers = {
      "X-Parse-Application-Id": dotenv.get("BACK4APPAPPLICATIONID"),
      "X-Parse-REST-API-Key": dotenv.get("BACK4APPRESTAPIKEY"),
      "content-type": "application/json"
    };
    _dio.options.baseUrl = dotenv.get("BACK4APPBASEURL");
  }

  Dio get dio => _dio;
}
