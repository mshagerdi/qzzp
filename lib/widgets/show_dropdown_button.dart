import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../providers/earthquakes.dart';

class ShowDropdownButton extends StatefulWidget {
  // const ShowDropdownButton({super.key, List<String> this.dropdownList});

  final List<String> dropdownList;
  final String dropdownKey;
  ShowDropdownButton(this.dropdownList, this.dropdownKey);

  @override
  State<ShowDropdownButton> createState() => _ShowDropdownButtonState();
}

class _ShowDropdownButtonState extends State<ShowDropdownButton> {
  late String? fCMToken;
  late String _dropdownValue;
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
    // _save();

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: 121,
            child: DropdownButton<String>(
              value: _dropdownValue, //_read(),  _dropdownValue,
              isExpanded: true,
              items: widget.dropdownList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _dropdownValue = value!;
                  _save();
                });
                // if (widget.dropdownKey.contains('display_')) {
                Provider.of<Earthquakes>(context, listen: false)
                    .fetchAndSetEvents();
                // }
              },
            ),
          );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = widget.dropdownKey;
    final String value = prefs.getString(key) ?? widget.dropdownList.first;
    print('read $key: $value');
    fCMToken = await prefs.getString('fCMToken');
    _dropdownValue = value;
    return value;
  }

  _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = widget.dropdownKey;
    final value = _dropdownValue;
    await prefs.setString(key, value);
    print('saved $key: $value');
    String address =
        'http://qzzp.ir/push_notification/get_token.php/?token=$fCMToken&province=$_dropdownValue';
    Uri url = Uri.parse(address);
    final response = await http.get(url);
    print('address: $address');
  }
}
