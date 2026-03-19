import 'package:app_agendamento_manicure_2026/ui/data/dto/user_dto.dart';
import '../models/cliente.dart';

class AgendamentoDTO {
  int? id;
  String? createdAt;
  String? updatedAt;
  bool? finalizado;
  UserDTO? user;
  Cliente? cliente;
  String? observacao;
  String? dataInicial;
  String? dataFinal;

  AgendamentoDTO(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.finalizado,
        this.user,
        this.cliente,
        this.observacao,
        this.dataInicial,
        this.dataFinal});

  AgendamentoDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    finalizado = json['finalizado'];
    user = json['user'] != null ? UserDTO.fromJson(json['user']) : null;
    cliente = json['cliente'] != null ? Cliente.fromJson(json['cliente']) : null;
    observacao = json['observacao'];
    dataInicial = json['dataInicial'];
    dataFinal = json['dataFinal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['finalizado'] = finalizado;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (cliente != null) {
      data['cliente'] = cliente!.toJson();
    }
    data['observacao'] = observacao;
    data['dataInicial'] = dataInicial;
    data['dataFinal'] = dataFinal;
    return data;
  }
}
