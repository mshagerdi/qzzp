import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCheckbox extends StatefulWidget {
  // const ShowCheckbox({super.key});
  final String checkboxKey;
  ShowCheckbox(this.checkboxKey);

  @override
  State<ShowCheckbox> createState() => _ShowCheckboxState();
}

// bool isChecked = false;

class _ShowCheckboxState extends State<ShowCheckbox> {
  late bool _isChecked;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _read().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
                _save();
              });
            },
          );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = widget.checkboxKey;
    final bool value = prefs.getBool(key) ?? false;
    print('read $key: $value');
    _isChecked = value;
    return value;
  }

  _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = widget.checkboxKey;
    final value = _isChecked;
    await prefs.setBool(key, value);
    print('saved $key: $value');
  }
}
