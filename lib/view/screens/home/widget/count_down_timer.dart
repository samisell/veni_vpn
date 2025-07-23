import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../utils/my_color.dart';
import '../../../../utils/my_font.dart';

class CountDownTimer extends StatefulWidget {
  final bool startTimer;
  final DateTime? startTime;

  const CountDownTimer({super.key, required this.startTimer, this.startTime});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration _duration = const Duration();
  Timer? _timer;
  bool _timerRunning = false;

  @override
  void initState() {
    super.initState();
    _duration = widget.startTime != null ? DateTime.now().difference(widget.startTime!) : Duration.zero;
    if (widget.startTimer) {
      _startTimer();
      _timerRunning = true;
    }
  }


  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(mounted) {
        setState(() {
          _duration = DateTime.now().difference(widget.startTime ?? DateTime.now());
          // _duration = Duration(seconds: _duration.inSeconds + 1);
        });
      }
    });
  }

  _stopTimer() {
    setState(() {
      _timer?.cancel();
      // _timer = null;
      // _duration = Duration();
      _timerRunning = false;
    });
  }

  // @override
  // void didUpdateWidget(covariant CountDownTimer oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //
  //   // Check if the external startTimer property has changed
  //   if (widget.startTimer) {
  //     // If it's true and the timer isn't running, start the timer
  //     if (!_timerRunning) {
  //       _startTimer();
  //       _timerRunning = true;
  //     }
  //   } else {
  //     // If it's false and the timer is running, stop the timer
  //     if (_timerRunning) {
  //       _stopTimer();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.startTimer && !_timerRunning) {
      _startTimer();
      _timerRunning = true;
    } else if (!widget.startTimer && _timerRunning) {
      _stopTimer();
    }

    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigit(_duration.inMinutes.remainder(60));
    final seconds = twoDigit(_duration.inSeconds.remainder(60));
    final hours = twoDigit(_duration.inHours.remainder(60));
    final milliseconds = (_duration.inMilliseconds.remainder(60));

    if (hours == '00') {
      return Text('$minutes m : $seconds s', style: outfitMedium.copyWith(color: MyColor.yellow, fontSize: 14, height: 1.05));
    } else {
      return Text('$hours h : $minutes m : $seconds s', style: outfitMedium.copyWith(color: MyColor.yellow, fontSize: 14, height: 1.05));
    }
  }
}
