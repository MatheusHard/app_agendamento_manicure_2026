import 'dart:io';

import 'package:app_agendamento_manicure_2026/ui/data/dto/user_dto.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/buttons/normal_button/custom_button.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/buttons/switch_button/custom_switch_button.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/dropdown/cliente_dropdown_form_field.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/inputs/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dto/agendamento_dto.dart';
import '../../../data/dto/cliente_dto.dart';
import '../../../data/models/agendamento.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/user.dart';
import '../../../data/service/api/agendamento_api.dart';
import '../../../data/service/api/cliente_api.dart';
import '../../../data/service/api/configurations/dio/configs.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/contatos/contatos.dart';
import '../../widgets/data/custom_date_picker_field.dart';
import '../../widgets/images/photo_gallery_img.dart';

class EditClientePage extends StatefulWidget {
  final Cliente? cliente;
  const EditClientePage({super.key, required this.cliente});

  @override
  State<EditClientePage> createState() => _EditClientePageState();
}

class _EditClientePageState extends State<EditClientePage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ///Dados Cliente
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  late FocusNode _myFocusNodeName;
  late FocusNode _myFocusNodePhone;
  late FocusNode _myFocusNodeEmail;
  User? user;
  bool _isLoading = false;
  File? _imagem;
  var bytes;
  final ImagePicker _picker = ImagePicker();
  String _telefoneSemMascara = '';
  final maskFormatter = Utils.formaterPhone();
  Cliente? editCliente;

  @override
  void initState() {
    _initFocusNode();
    _loadingUser();
    _initCliente();
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
                    Text("Editar Cliente", style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),
                    Utils.sizedBox(altura: 40.0, largura: 0),

                    /// NOme
                    CustomField(
                      controller: _nameController,
                      focusNode: _myFocusNodeName,
                      hintText: "Nome",
                      icon: Icons.textsms_outlined,
                      keyboardType: TextInputType.text,

                    ),
                    Utils.sizedBox(altura: 40.0, largura: 0),
                    /// Telefone
                    /// Telefone
                    CustomField(
                      controller: _phoneController,
                      focusNode: _myFocusNodePhone,
                      hintText: "Telefone",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [maskFormatter],
                      onChanged: (value) {
                        // Atualiza o número sem máscara sempre que digitar
                        _telefoneSemMascara = maskFormatter.getUnmaskedText();
                      },
                    ),
                    Utils.sizedBox(altura: 40.0, largura: 0),
                    /// NOme
                    CustomField(
                      controller: _emailController,
                      focusNode: _myFocusNodeEmail,
                      hintText: "Nome",
                      icon: Icons.textsms_outlined,
                      keyboardType: TextInputType.text,

                    ),
                    Utils.sizedBox(altura: 40.0, largura: 0),
                    /// Foto/Galeria Imagem
                    PhotoGalleryNetworkImg(
                        tirarFoto: _tirarFoto,
                        getImage: _getImage,
                        imagem: _imagem,
                        url: getUrlImg(editCliente?.photoName ?? '')
                    ),
                    Utils.sizedBox(altura: 40.0, largura: 0),
                    WidgetContatos(phone: editCliente!.telephone ?? ''),
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
                          await _editCliente(await _generateCliente(), context, Navigator.of(context));
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

  Future<void> _editCliente(ClienteDTO cliente, BuildContext context, NavigatorState navigator) async {

    setState(() {_isLoading = true;});
    try{
      await ClienteApi(context).updateCliente(cliente);
      if (!mounted) return;
      navigator.pop(true);
    }catch(e){
      print('Erro ao editar o agendamento: $e');

    }finally{
      setState(() {_isLoading = false;});
    }
  }

  void _initFocusNode(){
    _myFocusNodeName = FocusNode();
    _myFocusNodePhone = FocusNode();
    _myFocusNodeEmail = FocusNode();
  }
  void _initCliente() {
    editCliente = widget.cliente;
    _emailController.text = editCliente!.email ?? '';
    _phoneController.text = editCliente!.telephone ?? '';
    _nameController.text = editCliente!.name ?? '';
  }
  Future<void> _loadingUser() async {
    final u = await Utils.recuperarUser();
    setState(() {
      user = u;
    });
  }

  Future<ClienteDTO> _generateCliente() async{

    ClienteDTO cliente = ClienteDTO();
    UserDTO userDTO = UserDTO();
    userDTO.id = user?.id;

    cliente.id = editCliente?.id;
    cliente.name = _nameController.text;
    cliente.telephone = _phoneController.text;
    cliente.cpf = _cpfController.text;
    cliente.email = _emailController.text;
    cliente.createdAt = editCliente?.createdAt;
    cliente.updatedAt = DateTime.now().toIso8601String();
    cliente.imagemBase64 = bytes != null ? await Utils.base64String(bytes) : null;
    cliente.photoName =  editCliente?.photoName;
    cliente.user = userDTO;
    cliente.deletado = false;

    return cliente;
  }
  String getUrlImg(String photoName){
    Configs conf = Configs();
    String BASE_URL = conf.dio.options.baseUrl;
    return "$BASE_URL/${Utils.URL_UPLOAD}$photoName";
  }
// Print Photo
  Future<void> _tirarFoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? fotoFile = await _picker.pickImage(source: ImageSource.camera);
      if (fotoFile != null) {
        final File originalFile = File(fotoFile.path);
        final compressedBytes = await Utils.compressImageBytes(originalFile); // Compactar a foto
        if (compressedBytes != null) {
          setState(() {
            _imagem = originalFile;
            bytes = compressedBytes; // já comprimidos
          });
          print("Foto comprimida: ${bytes!.length / 1024} KB");
        } else {
          print("Falha ao comprimir a imagem");
        }
      }
    } else {
      print("Permissão de câmera negada");
    }
  }
  // Capture Galley
  Future _getImage(ImageSource source) async {
    final galleryFile = await _picker.pickImage(
      source: source,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 50,
    );

    if (galleryFile != null) {
      final File originalFile = File(galleryFile.path);
      final compressedBytes = await Utils.compressImageBytes(originalFile);

      if (compressedBytes != null) {
        setState(() {
          _imagem = originalFile;
          bytes = compressedBytes; // salva os bytes comprimidos
        });
        print("Imagem da galeria comprimida: ${bytes!.length / 1024} KB");
      } else {
        print("Falha ao comprimir a imagem da galeria");
      }
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }
}
