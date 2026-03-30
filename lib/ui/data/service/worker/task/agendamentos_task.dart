
import 'package:app_agendamento_manicure_2026/ui/core/utils/utils.dart';
import 'package:app_agendamento_manicure_2026/ui/data/dto/agendamento_dto.dart';
import 'package:app_agendamento_manicure_2026/ui/data/dto/user_dto.dart';
import 'package:app_agendamento_manicure_2026/ui/data/models/agendamento.dart';
import 'package:app_agendamento_manicure_2026/ui/data/models/cliente.dart';
import 'package:app_agendamento_manicure_2026/ui/data/models/user.dart';
import 'package:app_agendamento_manicure_2026/ui/data/service/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../api/agendamento_api.dart';

class AgendamentosTask {

  AgendamentosTask(){}

  static Future<void> agendamentosDoDiaTask()async {

    User? user = await Utils.recuperarUser();

    List<Agendamento> listaAgendamentos = await _loadingAgendamentos(user);

    int idNot = 10;
    for(Agendamento agendamento in listaAgendamentos){
      await Notifications.showNotification(
          id: idNot,
          title: "Agenda Marcada",
          body:  '''Olá Sr.(a) ${user?.username ?? ''} voce tem um atendiwento hoje: Sr(a) ${agendamento.cliente?.name} às ${Utils.formatarData(agendamento.dataAtendimento ?? '', false) }'''
      );
      idNot ++;
    }

  }
  ///
  static Future<List<Agendamento>> _loadingAgendamentos(User? user) async {

      ///Filters
      AgendamentoDTO a = AgendamentoDTO(cliente: Cliente(), user: UserDTO(id: user?.id));
      a.user = UserDTO(id: user?.id);
      a.cliente = Cliente();
      a.finalizado = false;
      a.deletado = false;
      a.dataInicial = DateTime.now().toIso8601String();
      a.dataFinal = DateTime.now().toIso8601String();

      return await AgendamentoApi().getListByFilter(a);
  }
}