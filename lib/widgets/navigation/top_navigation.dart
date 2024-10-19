import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/widgets/icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopNavigation extends StatelessWidget {

  final Estudiante? estudiante;

  const TopNavigation({super.key, required this.estudiante});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      let<String, CircleAvatar>(estudiante?.fotoUrl, (String fotoUrl) => CircleAvatar(
        radius: 25,
        foregroundImage:
        MemoryImage(base64Decode(fotoUrl)),
      )) ?? const Skeleton.keep(child: CircleAvatar(child: Icon(AppIcons.profile, fill: 1, size: 40))),
      const Spacer(),
      // const Skeleton.keep(child: Icon(AppIcons.more, size: 30)),
      Skeleton.keep(child: IconButton(onPressed: (){}, icon: const Icon(AppIcons.more,weight: 900,))),
    ],
  );
}
