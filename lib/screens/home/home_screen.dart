import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/services/firebase/remote_config_service.dart';
import 'package:miutem/core/utils/http/http_client.dart';
import 'package:miutem/screens/auth/login/login_screen.dart';
import 'package:miutem/screens/home/actions/cargar_clases_de_hoy.dart';
import 'package:miutem/screens/home/models/novedad.dart';
import 'package:miutem/screens/home/widgets/acceso_rapido.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/seccion_clases_de_hoy.dart';
import 'package:miutem/screens/home/widgets/novedades/lista_novedades.dart';
import 'package:miutem/screens/home/widgets/saludo.dart';
import 'package:miutem/styles/styles.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger _logger = Logger();

  String? errorAlCargarHorario;
  Estudiante? estudiante;
  List<BloqueHorario>? bloques;
  List<Novedad>? novedades;

  @override
  void initState() {
    super.initState();
    _logger.d("HomeScreen initialized");

    novedades = Get.find<RemoteConfigService>().fetchNovedades().toList();

    Get.find<AuthService>().login().then((estudiante) {
      setState(() => this.estudiante = estudiante);
      _cargarHorario();
    }, onError: (err) {
      if(mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TopNavigation(estudiante: estudiante, isMainScreen: true, title: 'Inicio'),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            this.estudiante = null;
            bloques = null;
          novedades = null;
        });
        await Get.find<RemoteConfigService>().refresh();
          await HttpClient.clearCache();
          final estudiante = await Get.find<AuthService>().login(forceRefresh: true);
          await _cargarHorario(forceRefresh: true);
          setState(() {
          this.estudiante = estudiante;
        novedades = Get.find<RemoteConfigService>().fetchNovedades().toList();
        });},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Saludo(estudiante: estudiante),
              const SizedBox(height: 20),
              const AccesoRapido(),
              const SizedBox(height: 20),
              //const SizedBox(height: 20),
              //      ListaNovedades(novedades: novedades
              //    ),
                  const SizedBox(height: 20),
                  SeccionClasesDeHoy(errorAlCargarHorario: errorAlCargarHorario, bloques: bloques, cargarHorario: _cargarHorario
              ),
            ],
          ),
        ),
      ),
    ),
  );

  _cargarHorario({ bool forceRefresh = false }) async {
    setState(() {
      errorAlCargarHorario = null;
      bloques = null;
    });
    await cargarClasesDeHoy(forceRefresh: forceRefresh).then((bloques) => setState(() {
      errorAlCargarHorario = null;
      this.bloques = bloques;
    }), onError: (err) {
      _logger.e("Error loading schedule: $err");
      setState(() => errorAlCargarHorario = err);
    });
  }
}
