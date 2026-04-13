import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:miutem/core/models/asignaturas/asignatura.dart";
import "package:miutem/core/models/horario.dart";
import "package:miutem/core/services/firebase/remote_config_service.dart";
import "package:miutem/core/services/horario_service.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/screens/horario/widgets/widgets.dart";
import "package:vector_math/vector_math_64.dart" as vector;

class HorarioController {
  final _storage = GetStorage();

  /// Lista de colores pastel de Material Design para las tarjetas de clases
  static final List<Color> _pastelColors = [
    // Material 100
    const Color(0xFFB3E5FC), // Light Blue 100
    const Color(0xFFC8E6C9), // Green 100
    const Color(0xFFF8BBD9), // Pink 100
    const Color(0xFFFFE0B2), // Orange 100
    const Color(0xFFD1C4E9), // Deep Purple 100
    const Color(0xFFB2EBF2), // Cyan 100
    const Color(0xFFFFF9C4), // Yellow 100
    const Color(0xFFFFCCBC), // Deep Orange 100
    const Color(0xFFC5CAE9), // Indigo 100
    const Color(0xFFDCEDC8), // Light Green 100
    const Color(0xFFF0F4C3), // Lime 100
    const Color(0xFFE1BEE7), // Purple 100
    // Material 200
    const Color(0xFFFFE082), // Amber 200
    const Color(0xFF80DEEA), // Cyan 200
    const Color(0xFFCE93D8), // Purple 200
    const Color(0xFFA5D6A7), // Green 200
    const Color(0xFFEF9A9A), // Red 200
    const Color(0xFF90CAF9), // Blue 200
    const Color(0xFFBCAAA4), // Brown 200
    const Color(0xFFB0BEC5), // Blue Grey 200
    // Material 50 (más claros)
    const Color(0xFFE3F2FD), // Blue 50
    const Color(0xFFE8F5E9), // Green 50
    const Color(0xFFFCE4EC), // Pink 50
    const Color(0xFFFFF3E0), // Orange 50
    const Color(0xFFEDE7F6), // Deep Purple 50
    const Color(0xFFE0F7FA), // Cyan 50
    const Color(0xFFFFFDE7), // Yellow 50
    const Color(0xFFFBE9E7), // Deep Orange 50
    // Material 300 (un poco más saturados)
    const Color(0xFF81D4FA), // Light Blue 300
    const Color(0xFFF48FB1), // Pink 300
    const Color(0xFFFFB74D), // Orange 300
    const Color(0xFFB39DDB), // Deep Purple 300
    const Color(0xFF4DD0E1), // Cyan 300
    const Color(0xFFAED581), // Light Green 300
    const Color(0xFFBA68C8), // Purple 300
  ];

  final _randomColors = List<Color>.from(_pastelColors)..shuffle();
  final _now = DateTime.now();

  num daysCount = 6;
  num periodsCount = 9;
  String startTime = "07:55";
  Duration periodDuration = const Duration(minutes: 90);
  Duration periodGap = const Duration(minutes: 5);
  List<Color> usedColors = [];

  RxDouble zoom = 0.5.obs;
  RxBool indicatorIsOpen = false.obs;
  RxBool isCenteredInCurrentPeriodAndDay = false.obs;

  TransformationController blockContentController = TransformationController();
  TransformationController daysHeaderController = TransformationController();
  TransformationController periodHeaderController = TransformationController();
  TransformationController cornerController = TransformationController();

  Function? _onUpdate;

  ///
  /// Funciones usadas para el controlador
  ///
  List<Color> get unusedColors{
    List<Color>  avaliableColors = [..._randomColors].where((Color color) => !usedColors.contains(color)).toList();
    return avaliableColors.isEmpty?[..._randomColors]:avaliableColors;
  }

  double get minutesFromStart => _now.difference(DateTime(_now.year, _now.month, _now.day, int.parse(startTime.split(":")[0]), int.parse(startTime.split(":")[1]))).inMinutes.toDouble();
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

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        setZoom(zoom.value);
        moveViewportToCurrentPeriodAndDay(context);
      }
    });


    blockContentController.addListener(_blockContentControllerListener);
    daysHeaderController.addListener(_daysHeaderControllerListener);
    periodHeaderController.addListener(_periodHeaderControllerListener);
  }

  void dispose(){
    blockContentController.removeListener(_blockContentControllerListener);
    daysHeaderController.removeListener(_daysHeaderControllerListener);
    periodHeaderController.removeListener(_periodHeaderControllerListener);
  }

  Future<Horario?> getHorario({ bool forceRefresh = false }) async{
    final horario = await Get.find<HorarioService>().getHorario(forceRefresh: forceRefresh);
    _setRandomColorsByHorario(horario);
    return horario;
  }

  /// Funciones para manejo de colores
  void _setRandomColorsByHorario(Horario horario) {
    for (final dia in horario.horario ?? []) {
      for (final bloque in dia) {
        final asignatura = bloque.asignatura;
        if (asignatura == null) continue;
        addAsignaturaAndSetColor(asignatura);
      }
    }
  }

  void addAsignaturaAndSetColor(Asignatura asignatura, {Color? color}){
    bool hasColor = getColor(asignatura) != null;
    if(hasColor) return;

    final newColor = color ?? unusedColors.first;
    final key = "${asignatura.codigo}_${asignatura.tipoHora}";
    usedColors.add(newColor);
    _storage.write(key, newColor.toARGB32());
  }

  Color? getColor(Asignatura? asignatura){
    if(asignatura == null) return null;
    return let(_storage.read("${asignatura.codigo}_${asignatura.tipoHora}"), (dynamic element)=> Color(element));
  }

  /// Obtiene el color de fondo y el color de texto con contraste para una asignatura
  ({Color background, Color text})? getColorWithContrast(Asignatura? asignatura) {
    final backgroundColor = getColor(asignatura);
    if (backgroundColor == null) return null;
    return (background: backgroundColor, text: _getContrastTextColor(backgroundColor));
  }

  /// Calcula el color de texto ideal (claro u oscuro) para un color de fondo dado
  /// usando el algoritmo de luminancia relativa de WCAG
  static Color _getContrastTextColor(Color backgroundColor) {
    // Calcular luminancia relativa según WCAG 2.0
    final double luminance = backgroundColor.computeLuminance();

    // Si el fondo es claro (luminancia > 0.5), usar texto oscuro
    // Si el fondo es oscuro, usar texto claro
    // Usamos 0.5 como umbral pero ajustado a 0.45 para mejor contraste en colores pastel
    if (luminance > 0.45) {
      return const Color(0xFF1A1A1A); // Gris muy oscuro para mejor legibilidad
    } else {
      return const Color(0xFFFFFFFF); // Blanco
    }
  }

  ///
  /// Funciones para mover dentro del horario
  ///

  void _onChangeAnyController(){
    setIndicatorIsOpen(true);
    isCenteredInCurrentPeriodAndDay.value = false;
    _onUpdate?.call();
  }
  void setIndicatorIsOpen(bool isOpen) {
    indicatorIsOpen.value = isOpen;
  }

  void setOnUpdate(Function? onUpdate) => _onUpdate = onUpdate;

  void moveViewportTo(BuildContext context, double x, double y){
    final viewportWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.horizontal;
    final viewportHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;

    x = (x + (HorarioMainScroller.periodHeight/2)) * zoom.value - (viewportWidth/2);
    y = (y + (HorarioMainScroller.dayHeight/2)) * zoom.value - (viewportHeight/2);
    x = x < 0 ? 0 : x;
    y = y < 0 ? 0 : y;

    final maxXPosition =  (HorarioMainScroller.daysWidth + HorarioMainScroller.periodsHeight) * zoom.value - viewportWidth;
    final maxYPosition =  (HorarioMainScroller.periodsHeight + HorarioMainScroller.dayHeight) * zoom.value - viewportHeight + kToolbarHeight;

    x = x > maxXPosition ? maxXPosition : x;
    y = y > maxYPosition ? maxYPosition : y;

    blockContentController.value = blockContentController.value..setTranslationRaw(-x,-y,0);
    periodHeaderController.value = periodHeaderController.value..setTranslationRaw(0,-y,0);
    daysHeaderController.value = daysHeaderController.value..setTranslationRaw(-x,0,0);

    _onChangeAnyController();
  }

  void moveViewportToPeriodIndexAndDayIndex(BuildContext context, int periodIndex, int dayIndex){
    const blockWidth = HorarioMainScroller.blockWidth;
    final x = (dayIndex * blockWidth) + (blockWidth/2);
    const blockHeight = HorarioMainScroller.blockHeight;
    final y = (periodIndex * blockHeight) + (blockHeight/2);

    moveViewportTo(context, x, y);
  }

  void moveViewportToCurrentPeriodAndDay(BuildContext context){
    final periodIndex = indexOfCurrentPeriod ?? 0;
    final dayIndex = indexOfCurrentDayStartingAtMonday ?? 0;
    
    // Resetear el zoom al valor por defecto
    zoom.value = RemoteConfigService.horarioZoom;
    setZoom(zoom.value);
    
    moveViewportToPeriodIndexAndDayIndex(context, periodIndex, dayIndex);
    isCenteredInCurrentPeriodAndDay.value = true;
  }

  void setZoom(double zoom) {
    blockContentController.value = blockContentController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    periodHeaderController.value = periodHeaderController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    daysHeaderController.value = daysHeaderController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    cornerController.value = cornerController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));

    _onChangeAnyController();
  }

  void _blockContentControllerListener() {
    final xPosition = blockContentController.value.getTranslation().x;
    final yPosition = blockContentController.value.getTranslation().y;
    final currentZoom = blockContentController.value.getMaxScaleOnAxis();

    daysHeaderController.value.setTranslationRaw(xPosition, 0, 0);
    periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

    daysHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1),);
    periodHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
    cornerController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

    zoom.value = currentZoom;
    _onChangeAnyController();
  }

  void _daysHeaderControllerListener() {
    final currentZoom = daysHeaderController.value.getMaxScaleOnAxis();
    final xPosition = daysHeaderController.value.getTranslation().x;
    final contentYPosition = blockContentController.value.getTranslation().y;

    blockContentController.value.setTranslationRaw(xPosition, contentYPosition, 0);

    blockContentController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
    periodHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
    cornerController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

    zoom.value = currentZoom;
    _onChangeAnyController();
  }

  void _periodHeaderControllerListener() {
    final yPosition = periodHeaderController.value.getTranslation().y;
    final currentZoom = periodHeaderController.value.getMaxScaleOnAxis();

    final contentXPosition = blockContentController.value.getTranslation().x;

    periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

    blockContentController.value.setTranslationRaw(contentXPosition, yPosition, 0);

    blockContentController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
    daysHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
    cornerController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

    zoom.value = currentZoom;
    _onChangeAnyController();
  }

}