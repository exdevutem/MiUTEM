import 'package:flutter/material.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/home/models/novedad.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:miutem/styles/styles.dart';

class CardNovedades extends StatelessWidget {
  final Novedad novedad;

  const CardNovedades({
    super.key,
    required this.novedad,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      final uri = novedad.url;
      if(uri == null) return;

      launchUrlString(uri);
    },
    child: SizedBox(
      height: 120,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: themedColor(context, light: AppTheme.lightGrey, dark: AppTheme.darkLightGrey), width: 2),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
          title: Text(novedad.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.colorScheme.primary)),
          titleAlignment: ListTileTitleAlignment.top,
          subtitle: Text(novedad.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          leading: CircleAvatar(
            backgroundColor: AppTheme.colorScheme.primary,
            radius: 16,
            child: Icon(AppIcons.getIcon(novedad.icon), color: AppTheme.white),
          ),
        ),
      ),
    ),
  );
}
