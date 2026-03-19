import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/dropdown/cliente_dropdown_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dto/agendamento_dto.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/user.dart';
import '../../../data/service/api/agendamento_api.dart';
import '../../../data/service/api/cliente_api.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/data/custom_date_picker_field.dart';

class AddAgendamentoPage extends StatefulWidget {
  const AddAgendamentoPage({super.key});

  @override
  State<AddAgendamentoPage> createState() => _AddAgendamentoPageState();
}

class _AddAgendamentoPageState extends State<AddAgendamentoPage> {

  Cliente? clienteSelected;
  List<Cliente> listaClientes = [];
  final _observacaoController = TextEditingController();
  final _horaController = TextEditingController();
  final _minutoController = TextEditingController();
  final _dataAtendimentoController = TextEditingController();

  bool _finalizado = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _myFocusNodeHora;
  late FocusNode _myFocusNodeMinuto;
  User? user;
  late DateTime _selectedDataAtendimento;

  @override
  void initState() {
    _initFocusNode();
    _loadingUser();
    _loadingClientes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: '',
        onBack: ()  => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
        gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider,
      ),
      body:  Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  Text("Cadastrar Agendamento", style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),
                  Utils.sizedBox(altura: 20.0, largura: 0),
                  ClienteDropdownFormField(
                    initialValue: clienteSelected,
                    listaClientes: listaClientes,
                    onChanged: (cliente) {
                      clienteSelected = cliente;
                    },
                  ),
                  Utils.sizedBox(altura: 20.0, largura: 0),

                  CustomDatePickerField(
                    label: 'Data e Hora',
                    initialDateTime: DateTime.now(),
                    onDateTimeSelected: (dateTime) {
                      print('Selecionado: $dateTime');
                    },
                  )
                ],
              ),
            ),
          )
      )
    );

  }

  Future<bool> _addAgendamento(AgendamentoDTO a, BuildContext context) async {
    return await AgendamentoApi(context).addAgendamento(a);
  }

  Future<void> _loadingClientes() async {
    try {
      final dados = await ClienteApi(context).getList(1, 1);
      setState(() {
        listaClientes = dados;
      });
    } catch (e) {
      // Lida com erro, se quiser
      setState(() {
        //isLoading = false;
      });
    }
  }
  _initFocusNode(){
    _myFocusNodeHora = FocusNode();
    _myFocusNodeMinuto = FocusNode();
  }
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }
}
