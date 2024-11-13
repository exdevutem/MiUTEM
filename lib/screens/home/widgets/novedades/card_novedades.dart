import 'package:flutter/material.dart';
import 'package:miutem/core/utils/style_text.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/home/models/novedad.dart';
import 'package:miutem/widgets/icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      width: 350,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: themedColor(context, light: AppTheme.lightGrey, dark: AppTheme.darkLightGrey), width: 2),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(novedad.title, style: StyleText.header.copyWith(color: AppTheme.colorScheme.primary)),
          titleAlignment: ListTileTitleAlignment.top,
          subtitle: Text(novedad.subtitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Theme.of(context).primaryTextTheme.titleMedium?.color)),
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
