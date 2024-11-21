
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/actions/get_student_or_login.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/utils/http/http_client.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/home/actions/cargar_clases_de_hoy.dart';
import 'package:miutem/screens/home/widgets/acceso_rapido.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/lista_clases.dart';
import 'package:miutem/screens/home/widgets/saludo.dart';
import 'package:miutem/widgets/navigation/top_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? errorAlCargarHorario;
  Estudiante? estudiante;
  List<BloqueHorario>? bloques;

  @override
  void initState() {
    super.initState();

    getStudentOrLogin(context: context).then((estudiante) {
      setState(() => this.estudiante = estudiante);
      _cargarHorario();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TopNavigation(estudiante: estudiante, isMainScreen: true, title: 'Inicio', actions: const []),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            this.estudiante = null;
            bloques = null;
          });
          await HttpClient.clearCache();
          final estudiante = await Get.find<AuthService>().login(forceRefresh: true);
          await _cargarHorario(forceRefresh: true);
          setState(() => this.estudiante = estudiante);
        },
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Clases de Hoy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(getToday(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListaClases(error: errorAlCargarHorario, bloques: bloques, onRefresh: () => _cargarHorario(forceRefresh: true)),
                ],
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
    }), onError: (err) => setState(() => errorAlCargarHorario = err));
  }
}
