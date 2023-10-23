import 'package:ceps_app/models/cep_model.dart';
import 'package:ceps_app/services/dio_service.dart';

class CepsRepository {
  final _dio = DioService().dio;

  CepsRepository();

  Future<List<CepModel>> getAll() async {
    var response = await _dio.get("/Ceps");
    if (response.statusCode == 200) {
      return List<CepModel>.from(
          response.data["results"]!.map((x) => CepModel.fromJson(x)));
    }
    return <CepModel>[];
  }

  Future<CepModel?> get(String objectId) async {
    var response = await _dio
        .get("/Ceps", queryParameters: {"where": "{'objectId':'$objectId'}"});
    if (response.statusCode == 200) {
      return CepModel.fromJson(response.data);
    }
    return null;
  }

  Future<CepModel?> create(CepModel model) async {
    var response = await _dio.post("/Ceps", data: model.toJson());
    if (response.statusCode == 200) {
      var result = CepModel.fromJson(response.data);
      model.objectId = result.objectId;
      return model;
    }
    return null;
  }

  Future<bool> update(CepModel model) async {
    var response =
        await _dio.put("/Ceps/${model.objectId}", data: model.toJson());
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> delete(String objectId) async {
    var response = await _dio.delete("/Ceps/$objectId");
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
