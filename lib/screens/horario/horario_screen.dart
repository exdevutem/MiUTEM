import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';

import 'package:miutem/core/models/horario.dart';
import 'package:miutem/screens/horario/controller/horario_controller.dart';
import 'package:miutem/screens/horario/widgets/custom_app_bar.dart';
import 'package:miutem/screens/horario/widgets/widgets.dart';
import 'package:miutem/widgets/error/custom_error.dart';
import 'package:miutem/widgets/loading/loading_dialog.dart';
import 'package:miutem/widgets/loading/loading_indicator.dart';
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
        // ReviewService.addScreen("HorarioScreen");
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
                if(snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        appBar: CustomAppBar(
                            title: Text("Horario"),
                        ),
                        body: LoadingIndicator.centeredDefault(),
                    );
                }

                final horario = snapshot.data;
                final esErrorOffline = snapshot.hasError && snapshot.error is DioError && (snapshot.error as DioError).type == DioErrorType.cancel && (snapshot.error as DioError).response?.extra["offline"] == true;
                if((snapshot.hasError && !esErrorOffline) || !snapshot.hasData || horario == null) {
                    String errorMessage = "Ocurrió un error al cargar el horario! Por favor intenta más tarde.";
                    final error = snapshot.error;
                    if(error != null) {
                        errorMessage = error is CustomException ? error.message : "Ocurrió un error al cargar el horario! Por favor intenta más tarde.";
                    }

                    return Scaffold(
                        appBar: CustomAppBar(
                            title: Text("Horario"),
                            actions: [
                                IconButton(
                                    onPressed: _reloadData,
                                    icon: Icon(Icons.refresh_sharp),
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
                    appBar: CustomAppBar(
                        title: Text("Horario"),
                        actions: [
                            IconButton(
                                onPressed: _reloadData,
                                icon: Icon(Icons.refresh_sharp),
                                tooltip: "Forzar actualización del horario",
                            ),
                            Obx(() => !horarioController.isCenteredInCurrentPeriodAndDay.value ? IconButton(
                                onPressed: _moveViewportToCurrentTime,
                                icon: Icon(Icons.center_focus_strong),
                                tooltip: "Centrar Horario En Hora Actual",
                            ) : Container()),
                            IconButton(
                                onPressed: () => _captureAndShareScreenshot(horario),
                                icon: Icon(Icons.share),
                                tooltip: "Compartir Horario",
                            )
                        ],
                    ),
                    body: SafeArea(
                        bottom: false,
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
        // AnalyticsService.logEvent("horario_move_viewport_to_current_time");
        horarioController.moveViewportToCurrentPeriodAndDay(context);
    }

    void _captureAndShareScreenshot(Horario horario) async {
        showLoadingDialog(context);
        // AnalyticsService.logEvent("horario_capture_and_share_screenshot");
        final horarioScroller = HorarioMainScroller(
            horario: horario,
            showActive: false,
        );
        final image = await _screenshotController.captureFromWidget(
            horarioScroller.basicHorario,
            targetSize: Size(HorarioMainScroller.totalWidth, HorarioMainScroller.totalHeight),
        );

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/horario.png').create();
        await imagePath.writeAsBytes(image);

        Navigator.pop(context);
        /// Share Plugin
        await Share.shareXFiles([XFile(imagePath.path)]);
    }

    void _reloadData() => setState(() => _forceRefresh = true);
}


// class _HorarioScreenState extends State<HorarioScreen> {
//     bool _forceRefresh = false;
//     Horario? _horario;
//     bool _loading = false;
//
//     @override
//     void initState() {
//         super.initState();
//         /// No entendi donde se cargaba el offline, dejare esto por mientras pero hay que cambiar
//         isOffline().then((isOffline) => Preferencia.isOffline.set(isOffline ? 'true' : 'false'), onError: (err) => Preferencia.isOffline.set('true'));
//         _loadHorario();
//     }
//
//     /// Cargando horario
//     Future<void> _loadHorario() async {
//         setState(() => _loading = true);
//         try {
//             final horario = await Get.find<HorarioService>().getHorario(forceRefresh: _forceRefresh);
//             setState(() => _horario = horario);
//             _logHorario();
//         } catch (e) {
//             logger.e(e);
//         } finally {
//             setState(() => _loading = false);
//         }
//     }
//
//     /// Refresh
//     Future<void> _refresh() async {
//         await _loadHorario();
//     }
//
//     /// Testing como recibo los datos
//     void _logHorario() {
//         final _horario = this._horario;
//         if(_horario != null) {
//             for (var i = 0; i < _horario.horario!.length; i++) {
//                 for (var j = 0; j < _horario!.horario![i].length; j++) {
//                     final bloque = _horario!.horario?[i][j];
//                     if(bloque?.asignatura != null) {
//                         logger.i('Bloque: $i, $j - ${bloque?.asignatura!.nombre}');
//                     }
//                 }
//             }
//         }
//     }
//
//     @override
//     void dispose() {
//         /// todo Implementar la logica de dispose
//         super.dispose();
//     }
//
//
//     @override
//     Widget build(BuildContext context) {
//         return Scaffold(
//             appBar: AppBar(
//                 title: const Text('Horario'),
//             ),
//             body: _loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _horario == null
//                 ? const Center(child: Text('No se pudo cargar el horario'))
//                 : _buildHorarioGrid(),
//         );
//     }
//
//     Widget _buildHorarioGrid() {
//         return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 6, // Número de días
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//             ),
//             itemCount: 18 * 6, // Número de bloques
//             itemBuilder: (context, index) {
//                 final diaIdx = index % 6;
//                 final bloqueIdx = index ~/ 6;
//                 final bloque = _horario!.horario?[bloqueIdx][diaIdx];
//                 return Card(
//                     child: ListTile(
//                         title: Text(bloque?.asignatura?.nombre ?? 'Libre'),
//                         subtitle: Text(bloque?.sala ?? ''),
//                     ),
//                 );
//             },
//         );
//     }
//
//
// }