import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';
import '../../presentation/home_page.dart';
import '../models/login.dart';
import '../models/user.dart';
import '../screen_arguments/ScreenArgumentsUser.dart';
import 'configurations/dio/configs.dart';
import 'interfaces/iloginapi.dart';

class LoginApi implements ILoginApi{

  BuildContext? _context;

  LoginApi(BuildContext context){
    _context = context;
  }

  @override
  Future<bool> login(String username, String password, bool isChecked) async {

    bool flag = false;
    var customDio = Configs();

    try{
      var response = await customDio.dio.post("/login", data: {
        "username": username,
        "password": password
      });

      if(response.statusCode == 200){
        Login login =  Login.fromJson(response.data);
        if(login.token != null){
          await Utils.salvarToken(login.token ?? "");
          ///Caso queira salvar a sessão:
          if(isChecked){
            login.user?.username = username;
            login.user?.password = password;
            await Utils.salvarUser(login.user as User);
            await Utils.salvarManterConectado(isChecked);
          }else{
            await Utils.removerUser();
          }
          flag = true;
          Navigator.push(
                        _context!,
                        MaterialPageRoute(builder: (context) => HomePage(ScreenArgumentsUser(login)))
          );

        }
      }
    }catch(error){
      Utils.showDefaultSnackbar(_context!, '''Verifique suas credenciais!!!''');
      flag = false;
    }
    return flag;
  }


}