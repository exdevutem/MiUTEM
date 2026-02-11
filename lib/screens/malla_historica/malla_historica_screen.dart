import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/services/mi_utem/miutem_malla_service.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/malla_historica/widgets/widgets.dart';
import 'package:miutem/styles/styles.dart';

class MallaHistoricaScreen extends StatefulWidget {
  const MallaHistoricaScreen({super.key});

  @override
  State<MallaHistoricaScreen> createState() => _MallaHistoricaScreenState();
}

class _MallaHistoricaScreenState extends State<MallaHistoricaScreen> {
  Future<List<AsignaturaMalla>>? _mallaFuture;

  @override
  void initState() {
    super.initState();
    _mallaFuture = _getMalla();
  }

  Future<List<AsignaturaMalla>> _getMalla() async {
    try {
      final malla = await MiUTEMMallaService.get.getMalla();
      logger.d(malla);
      return malla;
    } catch (e) {
      logger.e("Error al obtener la malla histórica", error: e);
      rethrow;
    }
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
            snapshot.error is DioError &&
            (snapshot.error as DioError).type == DioErrorType.cancel &&
            (snapshot.error as DioError).response?.extra["offline"] == true;

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
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: MallaMainScroller(
              asignaturas: asignaturas,
            ),
          ),
        );
      },
    );
  }

  void _reloadData() => setState(() => _mallaFuture = _getMalla());
}

