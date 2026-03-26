import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/imgs/app_images.dart';

class WidgetContatos extends StatelessWidget {
  final String phone;

  const WidgetContatos({Key? key, required this.phone}) : super(key: key);

  Future<void> _abrirWhatsApp(String phone) async {
    final String cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final Uri url = Uri.parse('https://wa.me/55$cleanedPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir o WhatsApp.");
    }
  }

  Future<void> _abrirDiscador(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir o discador.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Contatos: "),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => _abrirWhatsApp(phone),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(AppImages.zap),
              ),
            ),
          ),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () => _abrirDiscador(phone),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(AppImages.phone),
              ),
            ),
          ),
        ),
      ],
    );
  }
}