import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:app_agendamento_manicure_2026/ui/core/theme/provider/theme_provider.dart';
import 'package:app_agendamento_manicure_2026/ui/data/service/notifications/notifications.dart';
import 'package:app_agendamento_manicure_2026/ui/data/service/worker/alarm_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_agendamento_manicure_2026/ui/core/constants/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Notificações
  await Notifications.initNotifications();
  /// Alarm Manager
  await AndroidAlarmManager.initialize();
  await AlarmManager.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Manicure',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
    );
  }
}


