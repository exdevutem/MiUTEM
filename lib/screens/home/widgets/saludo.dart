import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Saludo extends StatefulWidget {
  final Estudiante? estudiante;

  const Saludo({super.key, required this.estudiante});

  @override
  State<Saludo> createState() => _SaludoState();
}

class _SaludoState extends State<Saludo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (_controller.isAnimating) return;
    _controller.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 2), () => _controller.stop());
  }

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(let<int, String>(DateTime.now().hour, (hour) => hour >= 6 && hour < 12 ? '¡Buenos Días!,' : (hour >= 12 && hour < 19 ? '¡Buenas Tardes!,' : '¡Buenas Noches!,')) ?? '¡Te damos la Bienvenida!,',
            style: StyleText.headline,
          ),
          Skeletonizer(
            enabled: widget.estudiante == null,
            child: Text(widget.estudiante?.primerNombre ?? "John Doe",
              style: StyleText.headline,
            ),
          ),
        ],
      ),
      const Spacer(),
      GestureDetector(
        onTap: _startAnimation,
        child: AnimatedBuilder(
          animation: _animation,
          child: const Text("👋", style: TextStyle(fontSize: 40)),
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value,
              child: child,
            );
          },
        ),
      ),
    ],
  );
}
