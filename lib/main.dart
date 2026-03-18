import 'package:app_agendamento_manicure_2026/ui/presentation/agendamento_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/cliente_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/home_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/login_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pix_page.dart';
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


