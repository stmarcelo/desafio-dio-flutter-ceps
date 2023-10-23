import 'package:ceps_app/models/via_cep_model.dart';
import 'package:dio/dio.dart';

class ViaCEPRepository {
  Future<ViaCepModel?> get(String cep) async {
    var cepUnmasked = cep.replaceAll(".", "").replaceAll("-", "");
    var dio = Dio();
    try {
      var response =
          await dio.get("https://viacep.com.br/ws/$cepUnmasked/json");
      if (response.statusCode == 200) {
        return ViaCepModel.fromJson(response.data);
      }
    } catch (e) {}

    return null;
  }
}
