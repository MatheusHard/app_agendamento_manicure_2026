
import 'package:app_agendamento_manicure_2026/ui/core/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../dto/agendamento_dto.dart';
import '../../models/agendamento.dart';
import 'configurations/dio/configs.dart';

class AgendamentoApi {

  final URL = '/agendamentos';
  final FILTRAR = '/filtrar';

  AgendamentoApi() {}

  Future<bool> addAgendamento(AgendamentoDTO a) async {
    final configs = await Configs.create();

    var response = await configs.dio.post(URL,
                                             data: a.toJson(),
                                             options: Options(headers: await Utils.requestToken())
    );
    return true;
  }

  Future<bool> updateAgendamento(AgendamentoDTO a) async {
    final configs = await Configs.create();

    var response = await configs.dio.put(URL,
      data: a.toJson(),
      options: Options(headers: await Utils.requestToken())
    );
    return response.statusCode == 200;
  }

  Future<List<Agendamento>> getList(int user_id, int cliente_id, bool finalizado) async {

    final configs = await Configs.create();
    var response = await configs.dio.get(URL,  options: Options(headers: await Utils.requestToken()));
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Agendamento
      List<Agendamento> agendamentos = (lista as List)
          .map((json) => Agendamento.fromJson(json))
          .toList();

      return agendamentos;
    }
    return [];
  }

  Future<List<Agendamento>> getListByFilter(AgendamentoDTO a) async {
    final configs = await Configs.create();
    var response = await configs.dio.post(
      URL+FILTRAR,
      data: a.toJson(),
      options: Options(headers: await Utils.requestToken()));
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Agendamento
      List<Agendamento> agendamentos = (lista as List)
          .map((json) => Agendamento.fromJson(json))
          .toList();

      return agendamentos;
    }
    return [];
  }
}