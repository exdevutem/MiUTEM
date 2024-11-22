import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/widgets/icons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/services.dart';

class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final Estudiante? estudiante;
  final bool isMainScreen;
  final String title;
  const TopNavigation({super.key, this.estudiante, required this.isMainScreen, required this.title, required List<IconButton> actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isMainScreen 
          ? let<String, CircleAvatar>(estudiante?.fotoUrl, (String fotoUrl) => CircleAvatar(
              radius: 25,
              foregroundImage: MemoryImage(base64Decode(fotoUrl)),
            )) ?? const Skeleton.keep(child: CircleAvatar(child: Icon(AppIcons.profile, fill: 1, size: 40)))
          : const BackButton(),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(title),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Skeleton.keep(child: IconButton(onPressed: (){}, icon: const Icon(AppIcons.more, weight: 900,))),
        ),
      ],
    );
  }
}
