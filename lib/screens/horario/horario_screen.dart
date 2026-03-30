import "dart:io";
import "package:dio/dio.dart";
import "package:file_saver/file_saver.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/exceptions/custom_exception.dart";
import "package:miutem/core/models/horario.dart";
import "package:miutem/core/services/controllers/horario_controller.dart";
import "package:miutem/screens/horario/widgets/widgets.dart";
import "package:miutem/styles/styles.dart";
import "package:path_provider/path_provider.dart";
import "package:screenshot/screenshot.dart";
import "package:share_plus/share_plus.dart";

/// Widget contenedor que carga el horario
class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  late Future<Horario?> _horarioFuture;
  final horarioController = Get.find<HorarioController>();

  @override
  void initState() {
    super.initState();
    horarioController.init(context);
    _horarioFuture = _loadHorario();
  }

  @override
  void dispose() {
    horarioController.dispose();
    super.dispose();
  }

  Future<Horario?> _loadHorario({bool forceRefresh = false}) async {
    return await horarioController.getHorario(forceRefresh: forceRefresh);
  }

  void _reloadData() {
    setState(() {
      _horarioFuture = _loadHorario(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Horario?>(
      future: _horarioFuture,
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
        final esErrorOffline = snapshot.hasError && snapshot.error is DioException && (snapshot.error as DioException).type == DioExceptionType.cancel && (snapshot.error as DioException).response?.extra["offline"] == true;
        
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

        // Una vez cargado, pasar el horario al widget stateless
        return HorarioScreenContent(
          horario: horario,
          horarioController: horarioController,
          onReload: _reloadData,
        );
      },
    );
  }
}

/// Widget sin estado que solo muestra el horario cargado
class HorarioScreenContent extends StatelessWidget {
  final Horario horario;
  final HorarioController horarioController;
  final VoidCallback onReload;
  final ScreenshotController _screenshotController = ScreenshotController();

  HorarioScreenContent({
    super.key,
    required this.horario,
    required this.horarioController,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Horario"),
        actions: [
          Obx(() => PopupMenuButton(
            position: PopupMenuPosition.under,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                onTap: onReload,
                child: const ListTile(
                  leading: Icon(Icons.refresh_sharp),
                  title: Text("Recargar"),
                ),
              ),
              PopupMenuItem(
                onTap: () => _captureAndShareScreenshot(context),
                child: const ListTile(
                  leading: Icon(Icons.share),
                  title: Text("Compartir"),
                ),
              ),
              if (!horarioController.isCenteredInCurrentPeriodAndDay.value)
                PopupMenuItem(
                  onTap: () => horarioController.moveViewportToCurrentPeriodAndDay(context),
                  child: const ListTile(
                    leading: Icon(Icons.center_focus_strong),
                    title: Text("Centrar en hora actual"),
                  ),
                ),
            ],
          )),
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
  }

  Future<void> _captureAndShareScreenshot(BuildContext context) async {
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
        name: "horario",
        bytes: image,
        ext: "png",
        mimeType: MimeType.png,
      );
      if (context.mounted) {
        Navigator.pop(context);
        showTextSnackbar(context, title: "Horario guardado", message: "El horario se ha guardado correctamente en tu carpeta de descargas.");
      }
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File("${directory.path}/horario.png").create();
      await imagePath.writeAsBytes(image);

      if (context.mounted) Navigator.pop(context);

      await Share.shareXFiles([XFile(imagePath.path)]);
    }
  }
}