import 'package:flutter/material.dart';
import 'package:miutem/widgets/loading/loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const PopScope(
      child: LoadingIndicator(
        color: Colors.white,
      )
  );
}

void showLoadingDialog(BuildContext context) => showDialog(context: context, builder: (ctx) => LoadingDialog(), barrierDismissible: false);