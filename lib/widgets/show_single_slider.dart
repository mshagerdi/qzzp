import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/earthquakes.dart';

class ShowSingleSlider extends StatefulWidget {
  // const ShowSingleSlider({super.key});
  List<double> rangeValues;
  final String sliderKey;
  final Color activeColor;
  final Color inactiveColor;
  final Color disableColor;

  ShowSingleSlider(
    this.rangeValues,
    this.sliderKey,
    this.activeColor,
    this.inactiveColor,
    this.disableColor,
  );

  @override
  State<ShowSingleSlider> createState() => _ShowSingleSliderState();
}

class _ShowSingleSliderState extends State<ShowSingleSlider> {
  late String? fCMToken;
  late double _currentValue;
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
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Slider(
            divisions: widget.rangeValues[2].toInt(),
            max: widget.rangeValues[1],
            value: _currentValue,
            inactiveColor: widget.inactiveColor,
            thumbColor: (widget.sliderKey.contains('_magnitude'))
                ? (_currentValue == 10)
                    ? widget.disableColor
                    : widget.inactiveColor
                : (_currentValue == 0)
                    ? widget.disableColor
                    : widget.activeColor,
            activeColor: _currentValue.round() == 0
                ? widget.disableColor
                : widget.activeColor,
            label: ((_currentValue.round() == 0 &&
                        widget.sliderKey.contains('_distance')) ||
                    (_currentValue.round() == 10 &&
                        widget.sliderKey.contains('_magnitude')))
                ? 'disable'
                : '${_currentValue.round()} ${widget.sliderKey.contains('_distance') ? 'km' : 'Richter'}',
            onChanged: (value) {
              setState(() {
                _currentValue = value;
                _save();
                Provider.of<Earthquakes>(context, listen: false)
                    .fetchAndSetEvents();
              });
            },
          );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = widget.sliderKey;
    final double value =
        prefs.getDouble(key) ?? (key == 'alert_magnitude' ? 10 : 0);
    print('read $key: $value');
    fCMToken = await prefs.getString('fCMToken');
    _currentValue = value;
    return value;
  }

  _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = widget.sliderKey;
    final value = _currentValue;
    await prefs.setDouble(key, value);
    print('saved $key: $value');
    if (key == 'alert_magnitude') {
      String address =
          'http://qzzp.ir/push_notification/get_token.php/?token=$fCMToken&magnitude=$_currentValue';
      Uri url = Uri.parse(address);
      final response = await http.get(url);
      print('address: $address');
    }
  }
}
