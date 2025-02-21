import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/services/controllers/horario_controller.dart';
import 'package:miutem/screens/horario/widgets/custom_app_bar.dart';
import 'package:miutem/screens/horario/widgets/widgets.dart';
import 'package:miutem/styles/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  bool _forceRefresh = false;
  final horarioController = Get.find<HorarioController>();

  @override
  void initState() {
    _forceRefresh = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    horarioController.init(context);
    return FutureBuilder<Horario?>(
      future: () async {
        _moveViewportToCurrentTime();
        final data = await horarioController.getHorario(forceRefresh: _forceRefresh);
        _forceRefresh = false;
        return data;
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Horario"),
            ),
            body: LoadingIndicator.centeredDefault(),
          );
        }

        final horario = snapshot.data;
        final esErrorOffline = snapshot.hasError && snapshot.error is DioError && (snapshot.error as DioError).type == DioErrorType.cancel && (snapshot.error as DioError).response?.extra["offline"] == true;
        if ((snapshot.hasError && !esErrorOffline) || !snapshot.hasData || horario == null) {
          String errorMessage = "Ocurrió un error al cargar el horario! Por favor intenta más tarde.";
          final error = snapshot.error;
          if (error != null) {
            errorMessage = error is CustomException ? error.message : "Ocurrió un error al cargar el horario! Por favor intenta más tarde.";
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("Horario"),
              actions: [
                IconButton(
                  onPressed: _reloadData,
                  icon: const Icon(Icons.refresh_sharp),
                  tooltip: "Forzar actualización del horario",
                )
              ],
            ),
            body: Center(
              child: CustomErrorWidget(
                title: "Error al cargar el horario",
                error: errorMessage,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Horario"),
            actions: [
              IconButton(
                onPressed: _reloadData,
                icon: const Icon(Icons.refresh_sharp),
                tooltip: "Forzar actualización del horario",
              ),
              Obx(() => !horarioController.isCenteredInCurrentPeriodAndDay.value ? IconButton(
                onPressed: _moveViewportToCurrentTime,
                icon: const Icon(Icons.center_focus_strong),
                tooltip: "Centrar Horario En Hora Actual",
              ) : Container()),
              IconButton(
                onPressed: () => _captureAndShareScreenshot(context, horario),
                icon: const Icon(Icons.share),
                tooltip: "Compartir Horario",
              )
            ],
          ),
          body: SafeArea(
            child: Screenshot(
              controller: _screenshotController,
              child: HorarioMainScroller(
                horario: horario,
              ),
            ),
          ),
        );
      },
    );
  }

  void _moveViewportToCurrentTime() {
    horarioController.moveViewportToCurrentPeriodAndDay(context);
  }

  void _captureAndShareScreenshot(BuildContext context, Horario horario) async {
    showLoadingDialog(context);
    final horarioScroller = HorarioMainScroller(
      horario: horario,
      showActive: false,
    );
    final image = await _screenshotController.captureFromWidget(
      context: context,
      horarioScroller.basicHorario(context),
      targetSize: Size(HorarioMainScroller.totalWidth, HorarioMainScroller.totalHeight),
    );

    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await FileSaver.instance.saveFile(
        name: 'horario',
        bytes: image,
        ext: 'png',
        mimeType: MimeType.png,
      );
      if(context.mounted) Navigator.pop(context);

    } else {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/horario.png').create();
      await imagePath.writeAsBytes(image);

      if(context.mounted) Navigator.pop(context);

      await Share.shareXFiles([XFile(imagePath.path)]);
    }
  }

  void _reloadData() => setState(() => _forceRefresh = true);
}