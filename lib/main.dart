import 'package:app_agendamento_manicure_2026/ui/presentation/pages/agendamento/agendamento_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/cliente/cliente_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/home/home_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/login/login_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/pix/pix_page.dart';
import 'package:flutter/material.dart';

void main() async {


  runApp(
      MaterialApp(
        title: 'Agendamento Manicure',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home_page': (BuildContext context) => HomePage(null),
          '/cliente_page': (BuildContext context) => ClientePage(null),
          '/agendamento_page': (BuildContext context) => AgendamentoPage(null),
          '/login_page': (BuildContext context) =>  LoginPage(),
          '/pix_page': (BuildContext context) =>  PixPage(),

        },
        initialRoute: '/login_page',
      )

  );
}


