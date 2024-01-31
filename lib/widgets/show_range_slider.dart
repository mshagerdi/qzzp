import 'package:flutter/material.dart';
import 'package:qzzp/providers/earthquakes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ShowRangeSlider extends StatefulWidget {
  // const ShowRangeSlider({super.key});
  // Function sliderValues;
  List<double> rangeValues;
  final String rangeSliderKey;
  final Color activeColor;
  final Color inactiveColor;
  final Color disableColor;

  ShowRangeSlider(
    // this.sliderValues,
    this.rangeValues,
    this.rangeSliderKey,
    this.activeColor,
    this.inactiveColor,
    this.disableColor,
  );

  @override
  State<ShowRangeSlider> createState() => _ShowRangeSliderState();
}

class _ShowRangeSliderState extends State<ShowRangeSlider> {
  late RangeValues _currentRangeValues;
  late double rangeValueStart;
  late double rangeValueEnd;

  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _read().then((_) {
        if (_currentRangeValues.start < widget.rangeValues.first) {
          widget.rangeValues.insert(0, _currentRangeValues.start);
        }
        if (_currentRangeValues.end > widget.rangeValues.last) {
          widget.rangeValues
              .insert(widget.rangeValues.length, _currentRangeValues.end);
        }
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
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: RangeSlider(
              values: _currentRangeValues,
              max:
                  // _currentRangeValues.end > widget.rangeValues.last
                  //     ? _currentRangeValues.end
                  //     :
                  widget.rangeValues.last,
              min:
                  // _currentRangeValues.start < widget.rangeValues.first
                  //     ? _currentRangeValues.start
                  //     :
                  widget.rangeValues.first,
              activeColor: widget.activeColor,
              inactiveColor: widget.inactiveColor,
              divisions: widget.rangeValues.length - 1,
              // divisions: widget.rangeValues[2].toInt(),
              labels: RangeLabels(
                '${_currentRangeValues.start.round().toString()} ${widget.rangeSliderKey.contains('_distance') ? 'km' : 'Richter'}',
                '${_currentRangeValues.end.round().toString()} ${widget.rangeSliderKey.contains('_distance') ? 'km' : 'Richter'}',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  // widget.sliderValues(values.start, values.end);
                  _currentRangeValues = values;
                  _save();
                });
                if (widget.rangeSliderKey.contains('display_')) {
                  Provider.of<Earthquakes>(context, listen: false)
                      .fetchAndSetEvents();
                }
              },
            ),
          );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = widget.rangeSliderKey;
    final List<String> value = (prefs.getStringList(key) ??
        [
          ((widget.rangeValues.first).toString()),
          ((widget.rangeValues.last).toString()),
        ]);
    final RangeValues resultValue =
        RangeValues(double.parse(value[0]), double.parse(value[1]));
    print('read $key: $value');
    setState(() {
      // resultValue.start < widget.rangeValues.first
      //     ? rangeValueStart = widget.rangeValues.first
      //     : rangeValueStart = resultValue.start;
      // resultValue.end > widget.rangeValues.last
      //     ? rangeValueEnd = widget.rangeValues.last
      //     : rangeValueEnd = resultValue.end;
      // _currentRangeValues = RangeValues(rangeValueStart, rangeValueEnd);
      //above or under
      _currentRangeValues = resultValue;
      print('range values: $_currentRangeValues');
    });
    return resultValue;
  }

  _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = widget.rangeSliderKey;
    final value = _currentRangeValues;
    // setState(() {
    //   _currentRangeValues.start < widget.rangeValues.first
    //       ? rangeValueStart = widget.rangeValues.first.floor().toDouble()
    //       : rangeValueStart = _currentRangeValues.start;
    //   _currentRangeValues.end > widget.rangeValues.last
    //       ? rangeValueEnd = widget.rangeValues.last.ceil().toDouble()
    //       : rangeValueEnd = _currentRangeValues.end;
    //   _currentRangeValues = RangeValues(rangeValueStart, rangeValueEnd);
    // });
    await prefs.setStringList(key, [
      _currentRangeValues.start.round().toString(),
      _currentRangeValues.end.round().toString()
    ]);
    print('saved $key: $value');
  }
}
