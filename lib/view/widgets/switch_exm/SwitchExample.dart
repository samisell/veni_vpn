import 'package:flutter/material.dart';

import '../../../utils/my_color.dart';

class SwitchExample extends StatefulWidget {
  final bool switchValue;
  final Function onChanged;
  const SwitchExample({super.key, required this.switchValue, required this.onChanged});
  @override
  _SwitchExampleState createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      switchValue = widget.switchValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: MyColor.yellow,
      value: switchValue,
      onChanged: (value) {
        setState(() {
          switchValue = value;
        });
        widget.onChanged(value);
      },
    );
  }
}

