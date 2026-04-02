import 'dart:io';

import 'package:app_agendamento_manicure_2026/ui/data/dto/user_dto.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/buttons/normal_button/custom_button.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/buttons/switch_button/custom_switch_button.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/dropdown/cliente_dropdown_form_field.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/images/photo_gallery_img.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/widgets/inputs/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/provider/theme_provider.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import '../../../core/utils/utils.dart';
import '../../../data/dto/agendamento_dto.dart';
import '../../../data/dto/cliente_dto.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/user.dart';
import '../../../data/service/api/agendamento_api.dart';
import '../../../data/service/api/cliente_api.dart';
import '../../widgets/appbar/app_bar_back.dart';
import '../../widgets/data/custom_date_picker_field.dart';

class AddClientePage extends StatefulWidget {
  const AddClientePage({super.key});

  @override
  State<AddClientePage> createState() => _AddClientePageState();
}

class _AddClientePageState extends State<AddClientePage> {


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

  @override
  void initState() {
    _initFocusNode();
    _loadingUser();
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
                    Text("Cadastrar Cliente", style: AppTextStyles.textoSentimentoNegritoWhite( 20, context),),



                    Utils.sizedBox(altura: 40.0, largura: 0),


                    /// NOme
                    CustomField(
                      controller: _nameController,
                      focusNode: _myFocusNodeName,
                      hintText: "Nome",
                      icon: Icons.textsms_outlined,
                      keyboardType: TextInputType.text,

                    ),
                    Utils.sizedBox(altura: 20.0, largura: 0),
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
                    Utils.sizedBox(altura: 20.0, largura: 0),
                    /// E-mail
                    CustomField(
                      controller: _emailController,
                      focusNode: _myFocusNodeEmail,
                      hintText: "Email",
                      icon: Icons.mail,
                      keyboardType: TextInputType.text,

                    ),
                    Utils.sizedBox(altura: 40.0, largura: 0),
                    /// Foto/Galeria Imagem
                    PhotoGalleryNetworkImg(
                        tirarFoto: _tirarFoto,
                        getImage: _getImage,
                        imagem: _imagem,
                    ),
                    /// Salvar
                    CustomButton(
                      radios: 20,
                      height: 55,
                      gradient: context.watch<ThemeProvider>().currentGradient, // vem do provider
                      icon: Icons.people_alt_outlined,
                      isLoading: _isLoading,
                      onTap: () async {
                        if(_formKey.currentState!.validate()){
                          await _addCliente(await _generateCliente(), context, Navigator.of(context));
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

  void _initFocusNode(){
      _myFocusNodeName = FocusNode();
      _myFocusNodePhone = FocusNode();
      _myFocusNodeEmail = FocusNode();
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

      cliente.name = _nameController.text;
      cliente.telephone = _phoneController.text;
      cliente.cpf = _cpfController.text;
      cliente.email = _emailController.text;
      cliente.createdAt = DateTime.now().toIso8601String();
      cliente.updatedAt = DateTime.now().toIso8601String();
      cliente.imagemBase64 = bytes != null ? await Utils.base64String(bytes) : null;
      cliente.photoName =  "foto_${userDTO.id}${DateTime.now().millisecondsSinceEpoch}.jpg";
      cliente.user = userDTO;
      cliente.deletado = false;

    return cliente;
  }
  ///Add Cliente
  Future<void> _addCliente(ClienteDTO c, BuildContext context, NavigatorState navigator) async {

    setState(() {_isLoading = true;});
    try{
      await ClienteApi(context).addCliente(c);
      if (!mounted) return;
      navigator.pop(true);
    }catch(e){
      print('Erro ao cadastrar o agendaiemnto: $e');

    }finally{
      setState(() {_isLoading = false;});
    }
  }

  // Capture photo
  Future<void> _tirarFoto() async {
    var status = await Permission.camera.request();
    print('status'+status.toString());

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
