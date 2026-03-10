import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/services/mi_utem/miutem_malla_service.dart';
import 'package:miutem/screens/malla_historica/widgets/widgets.dart';
import 'package:miutem/styles/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class MallaHistoricaScreen extends StatefulWidget {
  const MallaHistoricaScreen({super.key});

  @override
  State<MallaHistoricaScreen> createState() => _MallaHistoricaScreenState();
}

class _MallaHistoricaScreenState extends State<MallaHistoricaScreen> {
  Future<List<AsignaturaMalla>>? _mallaFuture;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _mallaFuture = _getMalla();
  }

  Future<List<AsignaturaMalla>> _getMalla({bool forceRefresh = false}) async {
    return await Get.find<MiUTEMMallaService>().getMalla(forceRefresh: forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AsignaturaMalla>>(
      future: _mallaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Malla Histórica"),
            ),
            body: LoadingIndicator.centeredDefault(),
          );
        }

        final esErrorOffline = snapshot.hasError &&
            snapshot.error is DioException &&
            (snapshot.error as DioException).type == DioExceptionType.cancel &&
            (snapshot.error as DioException).response?.extra["offline"] == true;

        if ((snapshot.hasError && !esErrorOffline) || !snapshot.hasData || snapshot.data == null) {
          String errorMessage = "Ocurrió un error al cargar la malla. Por favor intenta más tarde.";
          final error = snapshot.error;
          if (error != null) {
            errorMessage = error is CustomException
                ? error.message
                : "Ocurrió un error al cargar la malla. Por favor intenta más tarde.";
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("Malla Histórica"),
              actions: [
                IconButton(
                  onPressed: _reloadData,
                  icon: const Icon(Icons.refresh_sharp),
                  tooltip: "Forzar actualización de la malla",
                )
              ],
            ),
            body: Center(
              child: CustomErrorWidget(
                title: "Error al cargar la malla",
                error: errorMessage,
              ),
            ),
          );
        }

        final asignaturas = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Malla Histórica"),
            actions: [
              PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: const Icon(Icons.more_vert),
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    onTap: _reloadData,
                    child: const ListTile(
                      leading: Icon(Icons.refresh_sharp),
                      title: Text("Recargar"),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => _captureAndShareScreenshot(context, asignaturas),
                    child: const ListTile(
                      leading: Icon(Icons.share),
                      title: Text("Compartir"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: Screenshot(
              controller: _screenshotController,
              child: MallaMainScroller(
                asignaturas: asignaturas,
              ),
            ),
          ),
        );
      },
    );
  }

  void _captureAndShareScreenshot(BuildContext context, List<AsignaturaMalla> asignaturas) async {
    showLoadingDialog(context);
    final mallaScroller = MallaMainScroller(
      asignaturas: asignaturas,
      forScreenshot: true,
    );

    // Calcular el tamaño necesario para capturar todo el contenido
    final estimatedHeight = _calculateEstimatedHeight(asignaturas);
    final estimatedWidth = _calculateEstimatedWidth(asignaturas);

    final image = await _screenshotController.captureFromWidget(
      context: context,
      mallaScroller,
      targetSize: Size(estimatedWidth, estimatedHeight),
    );

    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await FileSaver.instance.saveFile(
        name: 'malla_historica',
        bytes: image,
        ext: 'png',
        mimeType: MimeType.png,
      );
      // Mostrar toast de éxito
      if(context.mounted) {
        Navigator.pop(context);
        showTextSnackbar(context, title: "Malla guardada", message: "La malla histórica se ha guardado correctamente en tu carpeta de descargas.");
      }
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/malla_historica.png').create();
      await imagePath.writeAsBytes(image);

      if(context.mounted) Navigator.pop(context);

      await Share.shareXFiles([XFile(imagePath.path)]);
    }
  }

  /// Calcula la altura estimada necesaria para capturar todo el contenido de la malla
  double _calculateEstimatedHeight(List<AsignaturaMalla> asignaturas) {
    if (asignaturas.isEmpty) return 100;

    // Encontrar el máximo nivel (semestre)
    final maxNivel = asignaturas.map((a) => a.nivel).reduce((a, b) => a > b ? a : b);

    // Agrupar por semestre para contar máximo de asignaturas por semestre
    final asignaturasPorSemestre = List<List<AsignaturaMalla>>.generate(maxNivel, (_) => []);
    for (final asignatura in asignaturas) {
      if (asignatura.nivel > 0 && asignatura.nivel <= maxNivel) {
        asignaturasPorSemestre[asignatura.nivel - 1].add(asignatura);
      }
    }

    // Calcular la altura máxima de filas
    final maxAsignaturasEnSemestre = asignaturasPorSemestre.map((s) => s.length).reduce((a, b) => a > b ? a : b);

    // Estimaciones de altura (en píxeles):
    // - Header de semestres: 50px
    // - Divider: 1px
    // - Cada fila de asignatura: 180px (aumentado para asegurar que todo se capture)
    // - Espacios/padding adicional: 50px
    final heightFromAsignaturas = (maxAsignaturasEnSemestre * 180).toDouble();
    return 50 + 1 + heightFromAsignaturas + 50;
  }

  /// Calcula el ancho estimado necesario para capturar todo el contenido horizontal de la malla
  double _calculateEstimatedWidth(List<AsignaturaMalla> asignaturas) {
    if (asignaturas.isEmpty) return 600;

    // Encontrar el número máximo de semestres
    final maxNivel = asignaturas.map((a) => a.nivel).reduce((a, b) => a > b ? a : b);

    // Estimaciones de ancho (en píxeles):
    // - Cada semestre/columna: 250px
    // - Padding/espacios: 40px
    return (maxNivel * 250) + 40;
  }

  void _reloadData() {
    setState(() {
      _mallaFuture = _getMalla(forceRefresh: true);
    });
  }
}
