import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/screens/horario/widgets/widgets.dart';

import '../../../core/models/asignaturas/asignatura.dart';
import '../../../core/models/horario.dart';
import '../../../core/services/horario_service.dart';
import '../../../core/utils/utils.dart';
import '../service/remote_config.dart';



class HorarioController{
  final _storage = GetStorage();
  final _randomColors = Colors.primaries.toList()..shuffle();
  final _now = DateTime.now();

  num daysCount = 6;
  num periodsCount = 9;
  String startTime = '07:55';
  Duration periodDuration = const Duration(minutes: 90);
  Duration periodGap = const Duration(minutes: 5);
  List<Color> usedColors = [];

  RxDouble zoom = 0.5.obs;
  RxBool indicatorIsOpen = false.obs;
  RxBool isCenteredInCurrentPeriodAndDay = false.obs;

  TransformationController blockContentController = TransformationController();
  TransformationController daysHeaderController = TransformationController();
  TransformationController pariodHeaderController = TransformationController();
  TransformationController cornerController = TransformationController();

  Function? _onUpdate;

  ///
  /// Funciones usadas para el controlador
  ///

  List<Color> get unusedColors{
        List<Color>  avaliableColors = [..._randomColors].where((Color color) => !usedColors.contains(color)).toList();
        return avaliableColors.isEmpty?[..._randomColors]:avaliableColors;
  }

  double get minutesFromStart => _now.difference(DateTime(_now.year, _now.month, _now.day, int.parse(startTime.split(':')[0]), int.parse(startTime.split(':')[1]))).inMinutes.toDouble();
  int? get indexOfCurrentDayStartingAtMonday => _now.weekday > daysCount ? null : _now.weekday - 1;
  int? get indexOfCurrentPeriod {
    final periodBlockDuration = periodDuration.inMinutes + (periodGap.inMinutes * 2);
    final minutesModule = minutesFromStart % periodBlockDuration;

    if(minutesModule >= periodGap.inMinutes && minutesModule <= (periodBlockDuration - periodGap.inMinutes)){
      return (minutesFromStart ~/ periodBlockDuration);
    }
    return null;
  }

  void init(BuildContext context){
    zoom.value = RemoteConfigService.horarioZoom;
    moveViewporttoCurrentPeriodAndDay(context);
    setZoom(zoom.value);
    _setScrollControllerListeners();
  }

  Future<Horario?> getHorario({ bool forceRefresh = false }) async{
    /// TODO aqui en miutem se ocupaba el carreraId, pero nosotros no lo ocupamos asi que deberia borrar esto
    // final carreraId = (await Get.find<CarreraService>().getCarrera(forceRefresh: forceRefresh))?.id;
    // if(carreraId == null) return null;

    final horario = await Get.find<HorarioService>().getHorario(forceRefresh: forceRefresh);
    if (horario != null) _setRandomColorsByHorario(horario);
    return horario;
  }

  void _setRandomColorsByHorario(Horario horario) => horario.horario?.forEach((dia)=> dia.forEach((bloque){
    final _asignatura = bloque.asignatura;
    if(_asignatura == null) return;

    addAsignaturaAndSetColor(bloque.asignatura!);
  }));

  void addAsignaturaAndSetColor(Asignatura asignatura, {Color? color}){
    bool hasColor = getColor(asignatura) != null;
    if(hasColor) return;

    final _newColor = color ?? unusedColors.first;
    final _key = '${asignatura.codigo}_${asignatura.tipoHora}';
    usedColors.add(_newColor);
    _storage.write(_key, _newColor.value);
  }

  Color? getColor(Asignatura? asignatura){
    if(asignatura == null) return null;
    return let(_storage.read('${asignatura.codigo}_${asignatura.tipoHora}'), (dynamic element)=> Color(element));
  }

  void moveViewportTo(BuildContext context, double x, double y){
    final viewportWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.horizontal;
    final viewportHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;

    /// TODO AQUI QUEDE PERO NECESITABA EL HorarioMainScroller
    x = (x + (HorarioMainScroller.))

  }

}