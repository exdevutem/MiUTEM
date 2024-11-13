import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/screens/home/models/novedad.dart';

final remoteConfigDefaults = {
  'novedades': jsonEncode([{
    'icon': 'bell',
    'title': '¡Nuevas Funcionalidades!',
    'subtitle': 'Ahora puedes ver las clases de hoy en la pantalla inicial.'
  }])
};

class RemoteConfigService {

  final remoteConfig = FirebaseRemoteConfig.instance;

  Future initialize() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 12),
      ));
      await remoteConfig.setDefaults(remoteConfigDefaults);
      await remoteConfig.fetchAndActivate();
      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();
        logger.i('Configuración remota actualizada');
      });
    } catch (e) {
      logger.e('Error al inicializar la configuración remota', error: e);
    }
  }

  List<Novedad> fetchNovedades() {
    final novedades = remoteConfig.getValue('novedades');
    return Novedad.fromJsonList(jsonDecode(novedades.asString()) as List<dynamic>);
  }

  Future<void> refresh() async {
    await remoteConfig.fetchAndActivate();
  }
}