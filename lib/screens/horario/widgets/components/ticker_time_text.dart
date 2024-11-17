import 'dart:async';

import 'package:flutter/material.dart';

class TickerTimeText extends StatefulWidget {
  final DateTime time;

  const TickerTimeText({
    super.key,
    required this.time,
  });

  @override
  State<TickerTimeText> createState() => __TickerTimeTextState();
}

class __TickerTimeTextState extends State<TickerTimeText> {
  Timer? _timer;
  bool _showColon = true;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() => _showColon = !_showColon));
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => RichText(
    overflow: TextOverflow.fade,
    maxLines: 1,
    text: TextSpan(
      children: [
        TextSpan(
          text: "${widget.time.hour}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
        ),
        TextSpan(
          text: ":",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: _showColon ? Colors.white : Colors.transparent,
          ),
        ),
        TextSpan(
          text: "${widget.time.minute}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}