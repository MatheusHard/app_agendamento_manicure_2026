
import 'package:flutter/material.dart';
import '../../../core/constants/imgs/app_images.dart';
import '../../../core/utils/utils.dart';
import '../../../data/service/api/configurations/dio/configs.dart';


class CardCliente extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap; // Callback de clique
  final String? photoname;
  final Configs _customDio = Configs();

  CardCliente({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    required this.photoname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ff =   '${_customDio.dio.options.baseUrl}/${Utils.URL_UPLOAD}$photoname';
    print('fotos'+ ff);

    return Card(
      child: ListTile(
        onTap: onTap, // Ação de clique
        title: Text(title),
        subtitle: Text(subtitle),
        leading: CircleAvatar(
          backgroundImage: photoname != null ?
                              NetworkImage('${_customDio.dio.options.baseUrl}/${Utils.URL_UPLOAD}$photoname?${DateTime.now().millisecondsSinceEpoch}') :
                              AssetImage(AppImages.semfoto),
        ),
        trailing: Icon(icon),
      ),
    );
  }
}