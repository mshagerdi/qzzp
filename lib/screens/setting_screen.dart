import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/earthquakes.dart';

import '../widgets/date_input_widget.dart';
import '../widgets/show_chechbox.dart';
import '../widgets/show_range_datepicker.dart';
import '../widgets/show_range_slider.dart';
import '../widgets/show_datepicker.dart';
import '../widgets/show_dropdown_button.dart';
import '../widgets/show_dropdown_with_search_button.dart';
import '../widgets/show_single_slider.dart';

class SettingScreen extends StatelessWidget {
  // const SettingScreen({super.key});
  static const routeName = '/setting-screen';

  static const List<String> _durationEventsIn = <String>[
    'a day',
    'a week',
    '10 days',
    'a month',
    '3 months',
    // 'Custom',
  ];

  // static const List<String>
  static const List<String> _provinceList = <String>[
    'disable',
    'Alborz',
    'Ardebil',
    'Bushehr',
    'Chaharmahal va Bahtiari',
    'East Azarbaijan',
    'Fars',
    'Gilan',
    'Golestan',
    'Hamedan',
    'Hormozgan',
    'Ilam',
    'isfahan',
    'kerman',
    'Kermanshah',
    'Khorasan Razavi',
    'Khuzestan',
    'Kordestan',
    'Kohkiluye va Boyerahmad',
    'Lorestan',
    'Markazi',
    'Mazandaran',
    'North Khorasan',
    'Qazvin',
    'Qom',
    'Semnan',
    'Sistan va Baluchestan',
    'South Khorasan',
    'Tehran',
    'West Azarbaijan',
    'Yazd',
    'Zanjan',
  ];
  var _provincesEventsIn = <String>[];

  late double gottenMinRange;
  late double gottenMaxRange;
  void sliderRangeValues(double minRange, double maxRange) {
    gottenMinRange = minRange;
    gottenMaxRange = maxRange;
  }

  final List<double> _distanceRangeValues = [0, 1000, 10];
  final List<double> _magnitudeRangeValues = [0, 10, 10];
  var _eventsMagnitudeRangeValues = <double>[];

  static const Color activeColor = Color.fromARGB(255, 176, 25, 28);
  static const Color inactiveColor = Color.fromARGB(255, 207, 225, 255);
  static const Color disableColor = Color.fromARGB(255, 141, 144, 144);

  @override
  Widget build(BuildContext context) {
    final earthquakesData = Provider.of<Earthquakes>(context);
    final earthquakes = earthquakesData.items;
    //filter only in events occured
    _provincesEventsIn += earthquakes.map((e) => e.province1).toList();
    _provincesEventsIn.sort();
    _provincesEventsIn.insert(0, 'disable');
    _eventsMagnitudeRangeValues +=
        earthquakes.map((e) => e.mag.floor().toDouble()).toList();
    _eventsMagnitudeRangeValues +=
        earthquakes.map((e) => e.mag.ceil().toDouble()).toList();
    _eventsMagnitudeRangeValues.sort();
    print('Events Mags: ${_eventsMagnitudeRangeValues.toSet().toList()}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Duration: (${earthquakes.length} items)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Display earthquakes within '),
                  ShowDropdownButton(
                      _durationEventsIn, 'display_events_duration'),
                ],
              ),
              // DateInputWidget(),
              // ShowRangeDatepicker(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ShowDatepicker('Start date:', 'start_date'),
              //     ShowDatepicker('End date:', 'end_date'),
              //   ],
              // ),
              Divider(thickness: 2),
              Text(
                'Display: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 11,
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('Display earthquakes far from '),
              //     Container(
              //       child: ShowSingleSlider(
              //         _distanceRangeValues,
              //         'display_distance',
              //         activeColor,
              //         inactiveColor,
              //         disableColor,
              //       ),
              //     ),
              //   ],
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('    Display earthquakes magnitude '),
                  Container(
                    child: ShowRangeSlider(
                      // sliderRangeValues,
                      _eventsMagnitudeRangeValues.toSet().toList(),
                      // _magnitudeRangeValues,
                      'display_magnitude',
                      activeColor,
                      inactiveColor,
                      disableColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Display earthuakes occured in '),
                  ShowDropdownButton(
                      _provincesEventsIn.toSet().toList(), 'display_province'),
                ],
              ),
              Divider(thickness: 4),
              Text(
                'Alert: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 11,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('    Alert earthuakes far from '),
                  ShowSingleSlider(
                    _distanceRangeValues,
                    'alert_distance',
                    activeColor,
                    inactiveColor,
                    disableColor,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('    Alert earthuakes larger than '),
                  Container(
                    child: ShowSingleSlider(
                      _magnitudeRangeValues,
                      'alert_magnitude',
                      inactiveColor,
                      activeColor,
                      disableColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('    Alert earthuakes occured in '),
                  ShowDropdownButton(_provinceList, 'alert_province'),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Play beep sound on alerts '),
              //     ShowCheckbox('alert_beep'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
