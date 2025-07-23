import 'package:flutter/material.dart';

import '../../../../utils/app_layout.dart';
import '../../../../utils/my_image.dart';

class RotateWorld extends StatefulWidget {
  final bool isConnected;

  const RotateWorld(
      {Key? key,required this.isConnected,})
      : super(key: key);

  @override
  _RotateWorldState createState() => _RotateWorldState();
}

class _RotateWorldState extends State<RotateWorld> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant RotateWorld oldWidget) {
      // if (widget.isConnected) {
      //   _animationController.repeat();
      // } else {
      //   _animationController.stop();
      // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: widget.isConnected ? 0.6 : 1.6,
        end: widget.isConnected ? 1.6 : 0.6,
      ),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return RotationTransition(
          turns: _animationController,
          child: SizedBox(
            height: AppLayout.getScreenWidth(context) * value,
            width: AppLayout.getScreenWidth(context) * value,
            child: Image.asset(MyImage.earthIcon),
          ),
        );
      },
    );
  }
}
