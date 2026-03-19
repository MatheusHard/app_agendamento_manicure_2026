
import 'package:app_agendamento_manicure_2026/ui/core/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../dto/agendamento_dto.dart';
import '../../models/agendamento.dart';
import 'configurations/dio/configs.dart';

class AgendamentoApi {

  BuildContext? _context;
  final Configs _customDio = Configs();
  final URL = '/agendamentos';
  final FILTRAR = '/filtrar';

  AgendamentoApi(BuildContext context) {
    _context = context;
  }

  Future<bool> addAgendamento(AgendamentoDTO a) async {

    var response = await _customDio.dio.post(URL,
                                             data: a.toJson(),
                                             options: Options(headers: await Utils.requestToken())
    );
    return true;
  }

  Future<bool> updateAgendamento(AgendamentoDTO a) async {

    var response = await _customDio.dio.put(URL,
      data: a.toJson()/*{
        "id": a.id,
        "createdAt": a.createdAt,
        "updatedAt": a.updatedAt,
        "finalizado": a.finalizado,
        "observacao": a.observacao,
        "user": {
          "id": a.user?.id
        },
        "cliente": {
          "id": a.cliente?.id
        }
      },*/,
      options: Options(headers: await Utils.requestToken())
    );
    return response.statusCode == 200;
  }

  Future<List<Agendamento>> getList(int user_id, int cliente_id, bool finalizado) async {

    var response = await _customDio.dio.get(URL,  options: Options(headers: await Utils.requestToken()));
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
    var response = await _customDio.dio.post(
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