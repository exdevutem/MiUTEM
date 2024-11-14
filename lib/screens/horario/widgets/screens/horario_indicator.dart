import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/services/horario_screen_service.dart';

import '../widgets.dart';


class HorarioIndicator extends StatefulWidget {
  static const _height = 2.0;
  static const _circleRadius = 10.0;
  static const _tapAreaRadius = 15.0;

  final EdgeInsets initialMargin;
  final double heightByMinute;
  final double maxWidth;
  final Color color;

  const HorarioIndicator({
    super.key,
    required this.initialMargin,
    required this.heightByMinute,
    required this.maxWidth,
    this.color = Colors.red,
  });

  @override
  State<HorarioIndicator> createState() => _HorarioIndicatorState();
}

class _HorarioIndicatorState extends State<HorarioIndicator> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 30), (Timer t) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  HorarioScreenService _horarioController = Get.find<HorarioScreenService>();

  double get _centerLineYPosition => (_horarioController.minutesFromStart * widget.heightByMinute);

  double get _startLineXPosition => widget.initialMargin.left;

  @override
  Widget build(BuildContext context) {
    final circleTapAreaTop = _centerLineYPosition - HorarioIndicator._circleRadius - HorarioIndicator._tapAreaRadius;
    final circleTapAreaLeft = _startLineXPosition - HorarioIndicator._circleRadius - HorarioIndicator._tapAreaRadius;

    final lineTop = _centerLineYPosition - HorarioIndicator._height / 2;
    final lineLeft = _startLineXPosition;

    return Stack(
      children: [
        if (lineTop > 0 && lineLeft > 0) Container(
          margin: EdgeInsets.only(
            top: lineTop,
            left: lineLeft,
          ),
          height: HorarioIndicator._height,
          width: widget.maxWidth,
          color: widget.color,
        ),
        if (circleTapAreaTop > 0 && circleTapAreaLeft > 0) Container(
          margin: EdgeInsets.only(
            top: circleTapAreaTop,
            left: circleTapAreaLeft,
          ),
          child: GestureDetector(
            onTap: () {
              // AnalyticsService.logEvent('horario_indicator_dot_tap');
              _horarioController.setIndicatorIsOpen(!_horarioController.indicatorIsOpen.value);
            },
            child: Container(
              padding: EdgeInsets.all(HorarioIndicator._tapAreaRadius),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(HorarioIndicator._tapAreaRadius * 2),
              ),
              child: Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: HorarioIndicator._circleRadius * 2,
                width: _horarioController.indicatorIsOpen.value ? 50 : HorarioIndicator._circleRadius * 2,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius:
                  BorderRadius.circular(HorarioIndicator._circleRadius),
                ),
                child: _horarioController.indicatorIsOpen.value ? Center(
                  child: TickerTimeText(time: DateTime.now()),
                ) : Container(),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
