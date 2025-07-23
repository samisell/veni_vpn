import 'package:flutter/material.dart';

class FadeScreenTransition extends StatelessWidget {
  final Widget screen;
  final bool? replace;

  const FadeScreenTransition({super.key, required this.screen, this.replace});

  void navigate(BuildContext context) {
    if(replace??true){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 100),
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }else{
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 100),
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
