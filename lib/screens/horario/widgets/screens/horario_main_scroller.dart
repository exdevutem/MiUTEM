import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';

import '../../../../core/services/controllers/horario_controller.dart';
import 'package:miutem/screens/horario/widgets/widgets.dart';


class HorarioMainScroller extends StatefulWidget {
  static const double blockWidth = 320.0;
  static const double blockHeight = 200.0;
  static const double blockInternalMargin = 10.0;
  static const double dayHeight = 50.0;
  static const double dayWidth = blockWidth;
  static const double periodHeight = blockHeight;
  static const double periodWidth = 65.0;
  static const double borderWidth = 2.0;

  static const double defaultMaxScale = 1.0;
  static const double defaultMinScale = 0.1;

  final Horario horario;
  final bool showActive;

  const HorarioMainScroller({
    super.key,
    required this.horario,
    this.showActive = true,
  });

  @override
  HorarioMainScrollerState createState() => HorarioMainScrollerState();

  static double get daysWidth => dayWidth * Get.find<HorarioController>().daysCount;
  static double get periodsHeight => periodHeight * Get.find<HorarioController>().periodsCount;

  static double get totalWidth => daysWidth + periodWidth;
  static double get totalHeight => periodsHeight + dayHeight;

  Widget get _horarioBlocksContent => HorarioBlocksContent(horario: horario, blockHeight: blockHeight, blockWidth: blockWidth, blockInternalMargin: blockInternalMargin);
  Widget get _horarioDaysHeader => HorarioDaysHeader(horario: horario, height: dayHeight, dayWidth: dayWidth, showActiveDay: showActive);
  Widget get _horarioPeriodsHeader => HorarioPeriodsHeader(horario: horario, width: periodWidth, periodHeight: periodHeight, showActivePeriod: showActive);
  Widget get _horarioCorner => const HorarioCorner(height: dayHeight, width: periodWidth);
  Widget basicHorario(BuildContext context) => Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Column(
      children: [
        Row(children: [
          _horarioCorner,
          _horarioDaysHeader,
        ]),
        Row(children: [
          _horarioPeriodsHeader,
          _horarioBlocksContent,
        ])
      ],
    ),
  );
}

class HorarioMainScrollerState extends State<HorarioMainScroller> {

  final controller = Get.find<HorarioController>();

  @override
  void initState() {
    controller.setOnUpdate(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    controller.setOnUpdate(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(() => Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Stack(
      children: [
        /* Bloques del Horario */
        Container(
          height: HorarioMainScroller.periodsHeight,
          width: HorarioMainScroller.daysWidth,
          margin: EdgeInsets.only(
            top: HorarioMainScroller.dayHeight * controller.zoom.value,
            left: HorarioMainScroller.periodWidth * controller.zoom.value,
          ),
          child: ClipRect(
            child: InteractiveViewer(
              transformationController: controller.blockContentController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              panAxis: PanAxis.free,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: widget._horarioBlocksContent,
              ),
            ),
          ),
        ),
        /* Lista de Días */
        Container(
          width: HorarioMainScroller.daysWidth,
          height: HorarioMainScroller.dayHeight,
          margin: EdgeInsets.only(left: HorarioMainScroller.periodWidth * controller.zoom.value),
          child: ClipRect(child: InteractiveViewer(
            transformationController: controller.daysHeaderController,
            maxScale: HorarioMainScroller.defaultMaxScale,
            minScale: HorarioMainScroller.defaultMinScale,
            panAxis: PanAxis.free,
            scaleEnabled: false,
            clipBehavior: Clip.none,
            constrained: false,
            onInteractionUpdate: (interaction) {},
            child: SafeArea(
              child: widget._horarioDaysHeader,
            ),
          )),
        ),
        /* Esquina del Horario */
        SizedBox(
          width: HorarioMainScroller.periodWidth,
          height: HorarioMainScroller.dayHeight,
          child: ClipRect(child: InteractiveViewer(
            transformationController: controller.cornerController,
            maxScale: HorarioMainScroller.defaultMaxScale,
            minScale: HorarioMainScroller.defaultMinScale,
            panAxis: PanAxis.free,
            scaleEnabled: false,
            panEnabled: false,
            clipBehavior: Clip.none,
            constrained: false,
            onInteractionUpdate: (interaction) {},
            child: SafeArea(
              child: widget._horarioCorner,
            ),
          )),
        ),
        /* Lista de Horas */
        Container(
          width: HorarioMainScroller.periodWidth,
          height: HorarioMainScroller.periodsHeight,
          margin: EdgeInsets.only(top: HorarioMainScroller.dayHeight * controller.zoom.value),
          child: InteractiveViewer(
            transformationController: controller.periodHeaderController,
            maxScale: HorarioMainScroller.defaultMaxScale,
            minScale: HorarioMainScroller.defaultMinScale,
            panAxis: PanAxis.free,
            scaleEnabled: false,
            clipBehavior: Clip.none,
            constrained: false,
            onInteractionUpdate: (interaction) {},
            child: SafeArea(
              child: Stack(
                children: [
                  widget._horarioPeriodsHeader,
                  HorarioIndicator(
                    maxWidth: HorarioMainScroller.daysWidth,
                    initialMargin: const EdgeInsets.only(
                      top: HorarioMainScroller.dayHeight,
                      left: HorarioMainScroller.periodWidth,
                    ),
                    heightByMinute: HorarioMainScroller.blockHeight / 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ));
}
