import 'package:flutter/material.dart';
import 'package:miutem/widgets/loading/loading_indicator.dart';

class LoadingDialog extends StatelessWidget {

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) => const PopScope(
      child: LoadingIndicator(
        color: Colors.white,
      )
  );
}

void showLoadingDialog(BuildContext context) => showDialog(context: context, builder: (ctx) => const LoadingDialog(), barrierDismissible: false);