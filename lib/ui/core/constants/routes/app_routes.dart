import 'package:app_agendamento_manicure_2026/ui/presentation/pages/agendamento/agendamento_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/cliente/cliente_page.dart';
import 'package:app_agendamento_manicure_2026/ui/presentation/pages/pix/pix_page.dart';
import 'package:flutter/material.dart';
import '../../../presentation/pages/home/home_page.dart';
import '../../../presentation/pages/login/login_page.dart';

class AppRoutes {
  static const String home = '/home_page';
  static const String login = '/login_page';
  static const String cliente = '/cliente_page';
  static const String agendamento = '/agendamento_page';
  static const String pix = '/pix_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage(null));
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case cliente:
        return MaterialPageRoute(builder: (_) => ClientePage(null));
      case agendamento:
        /*final args = settings.arguments as Map<String, dynamic>;
        final gasto = args['gasto'] as Gasto?;
        final isEdit = args['isEdit'] as bool;*/
        return MaterialPageRoute(builder: (_) => AgendamentoPage(null));
      case pix:
        return MaterialPageRoute(builder: (_) => PixPage());
      default:
        return MaterialPageRoute(builder: (_) => HomePage(null));
    }
  }
}
