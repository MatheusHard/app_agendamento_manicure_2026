
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/utils.dart';
import '../../dto/cliente_dto.dart';
import '../../models/cliente.dart';
import 'configurations/dio/configs.dart';

class ClienteApi  {

  BuildContext? _context;
  final Configs _customDio = Configs();
  final URL = "/clientes";
  final FILTRAR = '/filtrar';

  ClienteApi(BuildContext context) {
    _context = context;
  }

  Future<bool> addCliente(ClienteDTO cliente) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.post(URL,
      data: {
        "name": cliente.name,
        "createdAt": cliente.createdAt,
        "updatedAt": cliente.updatedAt,
        "name": cliente.name,
        "cpf": "",
        "email": cliente.email,
        "telephone": cliente.telephone,
        "deletado": cliente.deletado,
        "user": {
          "id":  2
        },
        "photoName": cliente.photoName,
        "imagemBase64": cliente.imagemBase64
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },),
    );

    return true;
  }

  Future<List<Cliente>> getList(int user_id, int cliente_id) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.
    var response = await _customDio.dio.get(URL,  options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },),);
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Cliente
      List<Cliente> clientes = (lista as List)
          .map((json) => Cliente.fromJson(json))
          .toList();

      return clientes;
    }

    return [];
  }

  Future<bool> updateCliente(ClienteDTO cliente, int user_id) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.put(URL,
      data: {
        "id": cliente.id,
        "name": cliente.name,
        "createdAt": cliente.createdAt,
        "updatedAt": cliente.updatedAt,
        "name": cliente.name,
        "cpf": "",
        "email": cliente.email,
        "telephone": cliente.telephone,
        "deletado": cliente.deletado,
        "user": {
          "id":  user_id
        },
        "photoName": cliente.photoName,
        "imagemBase64": cliente.imagemBase64
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },),
    );
    return response.statusCode == 200;
  }

  Future<List<Cliente>> getListByFilter(ClienteDTO cliente) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.
    var response = await _customDio.dio.post(
      URL+FILTRAR,
      data: 	cliente.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },),);
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Agendamento
      List<Cliente> clientes = (lista as List)
          .map((json) => Cliente.fromJson(json))
          .toList();

      return clientes;
    }
    return [];

  }
}