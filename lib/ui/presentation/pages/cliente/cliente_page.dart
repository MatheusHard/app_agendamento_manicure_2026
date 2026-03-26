import 'package:app_agendamento_manicure_2026/ui/data/dto/user_dto.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/appbar/app_bar.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/card/card_cliente.dart';

import 'package:flutter/material.dart';


import '../../../core/constants/enums/drawer_sections.dart';
import '../../../core/constants/routes/app_routes.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dto/cliente_dto.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/user.dart';
import '../../../data/screen_arguments/ScreenArgumentsUser.dart';
import '../../../data/service/api/cliente_api.dart';
import '../../widgets/appbar/app_bar_usuario.dart';

class ClientePage extends StatefulWidget {
  final ScreenArgumentsUser? userLogado;

  const ClientePage(this.userLogado, {super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {

  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key
  bool isLoading = true;
  List<Cliente> listaClientes = [];
  User? user;


  @override
  void initState() {
    _loadingUser();
    _carregarClientes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: key,
      ///AppBar
      appBar: AppBarUser(user, "", context),
      ///Body
      body: Container(
          padding: EdgeInsets.all(8),
        child: isLoading ? Center(child: CircularProgressIndicator()): ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: listaClientes.length,
          itemBuilder: (BuildContext context, int index) {
            final Cliente cliente = listaClientes[index];

            return Dismissible(
              key: Key(cliente.id.toString()), // chave única, geralmente o ID do item
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
              onDismissed: (direction) async{
                // remove o cliente da lista
                setState(() {
                  listaClientes.removeAt(index);
                });
                ///Delet Agendamento
                await _deletarCliente(_generateDeletCliente(cliente), context);

              },
              child: CardCliente(
                onTap: () async {
                  final resultado = await Navigator.pushNamed(
                    context,
                    AppRoutes.edit_cliente,
                    arguments: {
                      'cliente': cliente,
                    },
                  );
                  if(resultado == true){
                    await _carregarClientes();
                  }
                },
                title: cliente.name ?? "",
                subtitle: cliente.telephone ?? "",
                photoname: cliente.photoName,
                icon: Icons.phone_forwarded,
              ),
            );
          },
        ),

      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final resultado = await Navigator.pushNamed(context, AppRoutes.add_cliente);
            if(resultado == true){
              await _carregarClientes();
            }
          },
        shape: const CircleBorder(),
        backgroundColor: Colors.green, // verde
        tooltip: 'Adicionar Cliente',
          child: const Icon(Icons.add, color: Colors.white,),),

    );
  }
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

  Future<void> _carregarClientes() async {
    try {
      ///Filters
      ClienteDTO filters = ClienteDTO();
      filters.user = UserDTO(id: user?.id);
      filters.deletado = false;
      final dados = await ClienteApi(context).getListByFilter(filters);
      setState(() {
        listaClientes = dados;
        isLoading = false;
      });
    } catch (e) {
      // Lida com erro, se quiser
      setState(() {
        isLoading = false;
      });
    }
  }

  ClienteDTO _generateDeletCliente(Cliente cliente) {

      ClienteDTO clienteDel = ClienteDTO();
      UserDTO userDTO = UserDTO();
      userDTO.id = user?.id;
      clienteDel.id = cliente.id;
      clienteDel.name = cliente.name;
      clienteDel.telephone = cliente.telephone;
      clienteDel.cpf = cliente.cpf;
      clienteDel.email = cliente.email;
      clienteDel.createdAt = cliente.createdAt;
      clienteDel.updatedAt = DateTime.now().toIso8601String();
      clienteDel.photoName =  cliente.photoName;
      clienteDel.user = userDTO;
      clienteDel.deletado = true;

      return clienteDel;

  }

  Future<void> _deletarCliente(ClienteDTO cliente, BuildContext context) async {
     await ClienteApi(context).updateCliente(cliente);
  }

}
