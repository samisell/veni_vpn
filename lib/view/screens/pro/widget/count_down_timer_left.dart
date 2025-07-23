import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/my_font.dart';

class CountDownTimerLeft extends StatefulWidget {
  final DateTime? endTime;

  const CountDownTimerLeft({super.key, this.endTime});

  @override
  State<CountDownTimerLeft> createState() => _CountDownTimerLeftState();
}

class _CountDownTimerLeftState extends State<CountDownTimerLeft> {
  late Duration _duration;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if(widget.endTime!=null) {
      _duration = widget.endTime!.difference(DateTime.now());
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = widget.endTime!.difference(DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now().toUtc().add(const Duration(hours: 6)))));
      });
      if (_duration <= Duration.zero) {
        _timer.cancel();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays > 0 ? '${duration.inDays} d : ' : '';
    final hours = twoDigit(duration.inHours.remainder(24));
    final minutes = twoDigit(duration.inMinutes.remainder(60));
    final seconds = twoDigit(duration.inSeconds.remainder(60));
    return '$days$hours h : $minutes m : $seconds s';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_duration),
      style: outfitRegular.copyWith(
          color: MyColor.yellow, fontSize: 14),
    );
  }
}

