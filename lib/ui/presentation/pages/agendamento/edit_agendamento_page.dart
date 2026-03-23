import 'package:app_agendamento_manicure_2026/ui/data/dto/user_dto.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/buttons/normal_button/custom_button.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/buttons/switch_button/custom_switch_button.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/dropdown/cliente_dropdown_form_field.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/inputs/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dto/agendamento_dto.dart';
import '../../../data/models/agendamento.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/user.dart';
import '../../../data/service/api/agendamento_api.dart';
import '../../../data/service/api/cliente_api.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/data/custom_date_picker_field.dart';

class EditAgendamentoPage extends StatefulWidget {
  final Agendamento? agendamento;
  const EditAgendamentoPage({super.key, required this.agendamento});

  @override
  State<EditAgendamentoPage> createState() => _EditAgendamentoPageState();
}

class _EditAgendamentoPageState extends State<EditAgendamentoPage> {

  Cliente? _clienteSelected;
  List<Cliente> listaClientes = [];
  final _observacaoController = TextEditingController();
  var _mensagemErroCliente;

  bool _finalizado = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _focusNodeObsercacao;
  late FocusNode _myFocusNodeMinuto;
  User? user;
  late DateTime _selectedDataAtendimento = DateTime.now();
  bool _isLoading = false;
  Agendamento? editAgendamento;

  @override
  void initState() {
    _initFocusNode();
    _loadingUser();
    _loadingClientes();
    _initAgendamento();
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
                    Text("Editar Agendamento", style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),
                    Utils.sizedBox(altura: 20.0, largura: 0),

                    ///Cliente
                    ClienteDropdownFormField(
                      initialValue: _clienteSelected,
                      listaClientes: listaClientes,
                      onChanged: (cliente) {
                        _clienteSelected = cliente;
                      },

                    ),
                    Utils.sizedBox(altura: 20.0, largura: 0),
                    ///Data do Atendimento
                    CustomDatePickerField(
                      label: 'Data e Hora',
                      initialDateTime: DateTime.now(),
                      onDateTimeSelected: (dateTime) {
                        _selectedDataAtendimento = dateTime;
                      },
                    ),
                    Utils.sizedBox(altura: 20.0, largura: 0),
                    /// Finalizado
                    CustomSwitchButton(
                      value: _finalizado,
                      onToggle: (value) {
                        setState(() {
                          _finalizado = value;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveColor: Colors.red,
                    ),
                    Utils.sizedBox(altura: 20.0, largura: 0),

                    /// Observação
                    CustomField(
                      controller: _observacaoController,
                      focusNode: _focusNodeObsercacao,
                      hintText: "Observação",
                      icon: Icons.textsms_outlined,
                      keyboardType: TextInputType.text,
                      validator: (value){
                        return null;
                      },
                    ),
                    Utils.sizedBox(altura: 40.0, largura: 0),
                    /// Salvar
                    CustomButton(
                      radios: 20,
                      height: 55,
                      gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider
                      icon: Icons.monetization_on,
                      isLoading: _isLoading,
                      onTap: () async {
                        if(_formKey.currentState!.validate()){
                          await _editAgendamento(_generateAgendamento(),context, Navigator.of(context));
                        }
                      },
                      label: 'Salvar',
                      textStyle: AppTextStyles.textLogin,
                    ),
                  ],
                ),
              ),
            )
        )
    );

  }

  Future<void> _editAgendamento(AgendamentoDTO a, BuildContext context, NavigatorState navigator) async {

    setState(() {_isLoading = true;});
    try{
      await AgendamentoApi(context).updateAgendamento(a);
      if (!mounted) return;
      navigator.pop(true);
    }catch(e){
      print('Erro ao editar o agendamento: $e');

    }finally{
      setState(() {_isLoading = false;});
    }
  }

  Future<void> _loadingClientes() async {
    try {
      final dados = await ClienteApi(context).getList(1, 1); //TODO
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
  void _initFocusNode(){
    _focusNodeObsercacao = FocusNode();
  }
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

  AgendamentoDTO _generateAgendamento() {

    UserDTO userDTO = UserDTO();
    Cliente cliente = Cliente();
    userDTO.id = user?.id;
    cliente.id = _clienteSelected?.id;

    AgendamentoDTO a = AgendamentoDTO();
    a.id = editAgendamento?.id;
    a.observacao = _observacaoController.text;
    a.createdAt = editAgendamento?.createdAt;
    a.updatedAt = Utils.generateDataHoraSpring();
    a.dataAtendimento = _selectedDataAtendimento.toIso8601String();
    a.user = userDTO;
    a.cliente = cliente;
    a.finalizado = _finalizado;

    return a;
  }

  void _initAgendamento() {
    editAgendamento = widget.agendamento;
    _clienteSelected = editAgendamento?.cliente;
    _observacaoController.text = editAgendamento?.observacao ?? '';
    _finalizado = editAgendamento?.finalizado ?? false;
    _selectedDataAtendimento =  Utils.stringToDate(editAgendamento?.dataAtendimento ?? '')!;
  }
}
