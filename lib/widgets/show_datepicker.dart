// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// class CustomPicker extends CommonPickerModel {
//   String digits(int value, int length) {
//     return '$value'.padLeft(length, "0");
//   }

//   CustomPicker({DateTime? currentTime, LocaleType? locale})
//       : super(locale: locale) {
//     this.currentTime = currentTime ?? DateTime.now();
//     this.setLeftIndex(this.currentTime.hour);
//     this.setMiddleIndex(this.currentTime.minute);
//     this.setRightIndex(this.currentTime.second);
//   }

//   @override
//   String? leftStringAtIndex(int index) {
//     if (index >= 0 && index < 24) {
//       return this.digits(index, 2);
//     } else {
//       return null;
//     }
//   }

//   @override
//   String? middleStringAtIndex(int index) {
//     if (index >= 0 && index < 60) {
//       return this.digits(index, 2);
//     } else {
//       return null;
//     }
//   }

//   @override
//   String? rightStringAtIndex(int index) {
//     if (index >= 0 && index < 60) {
//       return this.digits(index, 2);
//     } else {
//       return null;
//     }
//   }

//   @override
//   String leftDivider() {
//     return "|";
//   }

//   @override
//   String rightDivider() {
//     return "|";
//   }

//   @override
//   List<int> layoutProportions() {
//     return [1, 2, 1];
//   }

//   @override
//   DateTime finalTime() {
//     return currentTime.isUtc
//         ? DateTime.utc(
//             currentTime.year,
//             currentTime.month,
//             currentTime.day,
//             this.currentLeftIndex(),
//             this.currentMiddleIndex(),
//             this.currentRightIndex())
//         : DateTime(
//             currentTime.year,
//             currentTime.month,
//             currentTime.day,
//             this.currentLeftIndex(),
//             this.currentMiddleIndex(),
//             this.currentRightIndex());
//   }
// }

// class ShowDatepicker extends StatefulWidget {
//   // const ShowDatepicker({super.key, this.pickerTitle, this.pickerKey});
//   final String pickerTitle;
//   final String pickerKey;
//   ShowDatepicker(this.pickerTitle, this.pickerKey);

//   @override
//   State<ShowDatepicker> createState() => _ShowDatepickerState();
// }

// class _ShowDatepickerState extends State<ShowDatepicker> {
//   late DateTime _datePicked;
//   late DateTime _startDate;
//   var _isInit = true;
//   var _isLoading = false;
//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       setState(() {
//         _isLoading = true;
//       });
//       _read().then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: <Widget>[
//           TextButton(
//             onPressed: () {
//               DatePicker.showDateTimePicker(context,
//                   showTitleActions: true,
//                   minTime: widget.pickerKey == 'end_date'
//                       ? _startDate.subtract(Duration(days: -1))
//                       : DateTime(2018, 1, 1),
//                   maxTime: widget.pickerKey == 'start_date'
//                       ? DateTime.now().subtract(Duration(days: 1))
//                       : DateTime.now(),
//                   theme: DatePickerTheme(
//                       headerColor: Color.fromARGB(255, 237, 235, 234),
//                       backgroundColor: Color.fromARGB(255, 242, 243, 245),
//                       itemStyle: TextStyle(
//                           color: Colors.black54,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18),
//                       doneStyle: TextStyle(
//                           color: Color.fromARGB(255, 1, 121, 63),
//                           fontSize: 16)), onChanged: (date) {
//                 // print('change $date in time zone ' +
//                 //     date.timeZoneOffset.inHours.toString());
//               }, onConfirm: (date) {
//                 // print('confirm $date');
//                 setState(() {
//                   _datePicked = date;
//                   // if (widget.pickerKey == 'start_date') {
//                   //   _startDate = date;
//                   //   print('_startDate: $_startDate');
//                   // }
//                 });
//                 _save();
//               }, currentTime: DateTime.now(), locale: LocaleType.en);
//             },
//             child: Column(
//               children: [
//                 Text(
//                   widget.pickerTitle,
//                   style: TextStyle(color: Colors.blue),
//                 ),
//                 Text(DateFormat.yMMMd().format(_datePicked)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _read() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = widget.pickerKey;
//     _startDate = DateTime.parse(
//         prefs.getString('start_date') ?? DateTime(2018, 1, 1).toString());
//     final DateTime value = DateTime.parse(prefs.getString(key) ??
//         (widget.pickerKey == 'start_date'
//                 ? DateTime.now().subtract(Duration(days: 1))
//                 : DateTime.now())
//             .toString());
//     print('read $key: $value');
//     print('_startDate: $_startDate');
//     _datePicked = value;

//     return value;
//   }

//   _save() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final key = widget.pickerKey;
//     final value = _datePicked;
//     await prefs.setString(key, value.toString());
//     widget.pickerKey == 'start_date' ? _startDate = value : null;
//     print('saved $key: $value');
//   }
// }
