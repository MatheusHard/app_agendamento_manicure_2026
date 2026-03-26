import 'package:app_agendamento_manicure_2026/ui/presentation/pages/agendamento/add_agendamento_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/agendamento/agendamento_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/agendamento/edit_agendamento_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/cliente/cliente_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/pix/pix_page.dart';
import 'package:flutter/material.dart';
import '../../../data/models/agendamento.dart';
import '../../../data/models/cliente.dart';
import '../../../presentation/pages/cliente/add_cliente_page.dart';
import '../../../presentation/pages/cliente/edit_cliente_page.dart';
import '../../../presentation/pages/home/home_page.dart';
import '../../../presentation/pages/login/login_page.dart';
import '../../../presentation/pages/perfil/perfil_page.dart';

class AppRoutes {
  static const String home = '/home_page';
  static const String login = '/login_page';
  static const String cliente = '/cliente_page';
  static const String add_cliente = '/add_cliente_page';
  static const String edit_cliente = '/edit_cliente_page';
  static const String agendamento = '/agendamento_page';
  static const String add_agendamento = '/add_agendamento_page';
  static const String edit_agendamento = '/edit_agendamento_page';

  static const String pix = '/pix_page';
  static const String perfil = '/perfil_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage(null));
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case cliente:
        return MaterialPageRoute(builder: (_) => ClientePage(null));
      case add_cliente:
        return MaterialPageRoute(builder: (_) => AddClientePage());
      case edit_cliente:
        final args = settings.arguments as Map<String, dynamic>;
        final cliente = args['cliente'] as Cliente?;
        return MaterialPageRoute(builder: (_) => EditClientePage(cliente: cliente));
      case agendamento:
        return MaterialPageRoute(builder: (_) => AgendamentoPage(null));
      case add_agendamento:
        return MaterialPageRoute(builder: (_) => AddAgendamentoPage());
      case edit_agendamento:
          final args = settings.arguments as Map<String, dynamic>;
          final agendamento = args['agendamento'] as Agendamento?;
        return MaterialPageRoute(builder: (_) => EditAgendamentoPage(agendamento: agendamento));
      case pix:
        return MaterialPageRoute(builder: (_) => PixPage());
      case perfil:
        return MaterialPageRoute(builder: (_) => PerfilPage());
      default:
        return MaterialPageRoute(builder: (_) => HomePage(null));
    }
  }
}
