
import 'package:app_agendamento_manicure_2026/ui/core/constants/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dto/agendamento_dto.dart';
import '../../../data/dto/user_dto.dart';
import '../../../data/models/agendamento.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/user.dart';
import '../../../data/screen_arguments/ScreenArgumentsUser.dart';
import '../../../data/service/api/agendamento_api.dart';
import '../../widgets/appbar/app_bar_usuario.dart';
import '../../widgets/card/card_agendamento.dart';

class AgendamentoPage extends StatefulWidget {
  final ScreenArgumentsUser? userLogado;

  const AgendamentoPage(this.userLogado, {super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {

  User? user;
  List<Agendamento> listaAgendamentos = [];
  bool isLoading = true;

  @override
  void initState() {
    _loadingUser();
    _loadingAgendamentos();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBarUser(user, "", context),
      body: Container(
          padding: EdgeInsets.all(8),
          child:  isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: listaAgendamentos.length,
            itemBuilder: (BuildContext context, int index) {
              final Agendamento agendamento = listaAgendamentos[index];

              return Dismissible(
                key: (Key(agendamento.id.toString())), // chave única, geralmente o ID do item
                direction: DismissDirection.startToEnd, // arrasta da direita para a esquerda
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  // opcional: exibir um diálogo de confirmação
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text('Deseja realmente remover este cliente?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Remover')),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  // remove o agendamento da lista
                  setState(() {
                    listaAgendamentos.removeAt(index);
                  });
                  //TODO
                  ///Atualizar o Agendamento pra Deletado:
                  //agendamento.deletado = true;
                  // await _atualizarAgendamento(agendamento, context);

                },
                child: CardAgendamento(
                  title: agendamento.cliente?.name ?? "Sem nome",
                  subtitle: agendamento.updatedAt ?? "Sem data",
                  urlFotoCliente: agendamento.cliente?.photoName,
                  icon: agendamento.finalizado == true
                      ? Icons.check_circle
                      : Icons.schedule,
                  onTap: () async {
                    //await _showDialogSaveAgendamento(context, userLogado!, true, agendamento); TODO
                  },
                ),
              );
            },
          )
      ),
      ///Botão Add
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(context, AppRoutes.add_agendamento);
          if(resultado == true){
            await _loadingAgendamentos();
          }
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.green, // verde
        tooltip: 'Adicionar Agendamento',
        child: const Icon(Icons.add, color: Colors.white,),),
    );



  }
  Future<void> _loadingAgendamentos() async {

    try {
      ///Filters
      AgendamentoDTO a = AgendamentoDTO(cliente: Cliente(), user: UserDTO(id: user?.id));
      a.user = UserDTO(id: user?.id);
      a.cliente = Cliente();
      a.finalizado = false;

      final dados = await AgendamentoApi(context).getListByFilter(a);
      setState(() {
        listaAgendamentos = dados;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }
}
