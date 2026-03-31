import 'package:dio/dio.dart';

class Configs {

  final _dio = Dio();

  get dio => _dio;

  Configs(){
     _dio.options.baseUrl = "https://api-manicure.squareweb.app"; //Produção
    //_dio.options.baseUrl = "http://192.168.0.4:8080"; //Local
    //_dio.options.baseUrl = "https://homologacao-api-manicure.squareweb.app"; //Homologação
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
  }
}