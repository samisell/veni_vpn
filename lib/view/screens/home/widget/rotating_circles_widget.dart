import 'package:flutter/material.dart';

import '../../../../utils/my_color.dart';

class RotatingCircles extends StatefulWidget {
  final bool isConnected;

  const RotatingCircles({
    super.key,
    required this.isConnected,
  });

  @override
  _RotatingCirclesState createState() => _RotatingCirclesState();
}

class _RotatingCirclesState extends State<RotatingCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Stack(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: MyColor.yellow, width: 1)),
          ),
          Container(
            width: 25,
            height: 25,
            margin: EdgeInsets.all(18),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyColor.yellow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
