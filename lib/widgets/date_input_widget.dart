import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../widgets/show_datepicker.dart';

class DateInputWidget extends StatefulWidget {
  const DateInputWidget({super.key});

  @override
  State<DateInputWidget> createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<DateInputWidget> {
  @override
  void initState() {
    _read();
    // TODO: implement initState
    super.initState();
  }

  bool _isCustom = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text('isCustom: $_isCustom')],
    );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'events_duration';
    setState(() {
      _isCustom = prefs.getString(key) == 'Custom';
    });

    return _isCustom;
  }
}
