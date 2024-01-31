import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/magnitude_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EarthquakeItem {
  final String id;
  final DateTime dateTime;
  final String city1;
  final String province1;
  final double dist1;
  final String city2;
  final String province2;
  final double dist2;
  final String city3;
  final String province3;
  final double dist3;
  final double mag;
  final double dep;
  final double lng;
  final double lat;
  final double distance;
  final MagnitudeClass earthquakeClass;
  final Color color;
  final bool isAlrted;

  EarthquakeItem({
    required this.id,
    required this.dateTime,
    required this.city1,
    required this.province1,
    required this.dist1,
    required this.city2,
    required this.province2,
    required this.dist2,
    required this.city3,
    required this.province3,
    required this.dist3,
    required this.mag,
    required this.dep,
    required this.lng,
    required this.lat,
    required this.distance,
    required this.earthquakeClass,
    required this.color,
    required this.isAlrted,
  });
}

class Earthquakes with ChangeNotifier {
  List<EarthquakeItem> _items = [];
  late Timer _refreshTimer;

  List<EarthquakeItem> get items {
    return [..._items];
  }

  EarthquakeItem findById(String id) {
    return _items.firstWhere((event) => event.id == id);
  }

  List<EarthquakeItem> findByProvinceAndMagnitude(
      String? showProvince, List<String>? magnitudeRange) {
    // print('Magni: $magnitudeRange');
    if (showProvince == 'disable') {
      return _items
          .where((event) =>
              event.mag >= double.parse(magnitudeRange![0]) &&
              event.mag <= double.parse(magnitudeRange![1]))
          .toList();
    } else {
      return _items
          .where((event) =>
              (event.province1.trim().toLowerCase() ==
                  showProvince!.trim().toLowerCase()) &&
              event.mag > double.parse(magnitudeRange![0]) &&
              event.mag < double.parse(magnitudeRange![1]))
          .toList();
    }
  }

  Map<String, dynamic> magnitudeColorAndClass(double magnitude) {
    Color magnitudeColor = Colors.black87;
    MagnitudeClass magnitudeClass = MagnitudeClass.Greate;
    if (magnitude < 2) {
      magnitudeColor = Colors.teal.shade900;
      magnitudeClass = MagnitudeClass.Micro;
    } else if (magnitude < 4) {
      magnitudeColor = Colors.green.shade900;
      magnitudeClass = MagnitudeClass.Minor;
    } else if (magnitude < 5) {
      magnitudeColor = Colors.lime.shade900;
      magnitudeClass = MagnitudeClass.Light;
    } else if (magnitude < 6) {
      magnitudeColor = Colors.red.shade900;
      magnitudeClass = MagnitudeClass.Moderate;
    } else if (magnitude < 7) {
      magnitudeColor = Colors.pink.shade900;
      magnitudeClass = MagnitudeClass.Strong;
    } else if (magnitude < 8) {
      magnitudeColor = Colors.purple.shade900;
      magnitudeClass = MagnitudeClass.Major;
    }
    return {
      'magnitudeClass': magnitudeClass,
      'magnitudeColor': magnitudeColor,
    };
  }

  Future<String> eventsDuration() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsDurationKey = 'display_events_duration';
    final String eventsDuration = prefs.getString(eventsDurationKey) ?? 'a day';
    return eventsDuration;
  }

  Future<Map<String, dynamic>> SettingsData() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsDurationKey = 'display_events_duration';
    final String eventsDuration = prefs.getString(eventsDurationKey) ?? 'a day';
    final eventsMagnitudeKey = 'display_magnitude';
    final List<String> eventsMagnitude =
        prefs.getStringList(eventsMagnitudeKey) ?? ['0.0', '10.0'];
    final eventsProvinceKey = 'display_province';
    final String eventsProvince =
        prefs.getString(eventsProvinceKey) ?? 'disable';
    return {
      'eventsDurationSetting': eventsDuration,
      'eventsMagnitudeSetting': eventsMagnitude,
      'eventsProvinceSetting': eventsProvince,
    };
  }

  Future<void> fetchAndSetEvents() async {
    final prefs = await SharedPreferences.getInstance();
    late int _days;
    final eventsDurationKey = 'display_events_duration';
    final String eventsDuration = prefs.getString(eventsDurationKey) ?? 'a day';
    final String eventsMagKey = 'display_magnitude';
    final List<String>? eventsMagRange = prefs.getStringList(eventsMagKey);
    final String eventsProvKey = 'display_province';
    final String? eventsProv = prefs.getString(eventsProvKey);

    final String AlertMagKey = 'alert_magnitude';
    final double? alertMag = prefs.getDouble(AlertMagKey);
    final String AlertDistKey = 'alert_distance';
    final double? alertDist = prefs.getDouble(AlertDistKey);
    final String AlertProvKey = 'alert_province';
    final String? alertProv = prefs.getString(AlertProvKey);
    final String AlertBeepvKey = 'alert_beep';
    final bool? alertBeep = prefs.getBool(AlertBeepvKey);

    // print('read $key: $value');
    switch (eventsDuration) {
      case 'a day':
        _days = 1;
        break;
      case 'a week':
        _days = 7;
        break;
      case '10 days':
        _days = 10;
        break;
      case 'a month':
        _days = 30;
        break;
      case '3 months':
        _days = 90;
        break;
      default:
        _days = 1;
    }
    print('Number of days: $_days');
    LocationPermission permission = await Geolocator.requestPermission();

    final currentPosition = await Geolocator.getCurrentPosition();
    print('Current Position: $currentPosition');
    String address =
        'http://api.qzzp.ir/?startdate=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().subtract(Duration(days: _days)).toUtc())}';
    // eventsMagRange != null
    //     ? address += '&minmag=${eventsMagRange[0]}&maxmag=${eventsMagRange[1]}'
    //     : null;
    // (eventsProv != null && eventsProv != 'disable')
    //     ? address += '&prov=$eventsProv'
    //     : null;
    print('address: $address');

    Uri url = Uri.parse(address);
    final response = await http.get(url);
    final List<EarthquakeItem> loadedEvents = [];

    // print(json.decode(response.body)['info']);
    final extractedData =
        json.decode(response.body)['info']! as Map<String, dynamic>;
    // print(extractedData);
    if (extractedData == null) {
      print('Extracted data is null');
      return;
    }

    extractedData.forEach((earthquakeId, earthquakeData) {
      final utcDate = DateTime.parse(earthquakeData['date'] + 'Z');
      final magnitude = double.parse(earthquakeData['magnitude']);
      final _latitude = double.parse(
          earthquakeData['coordinates']['latitude'].replaceAll('N', ''));
      final _longitude = double.parse(
          earthquakeData['coordinates']['longitude'].replaceAll('E', ''));
      final distance = Geolocator.distanceBetween(
        _latitude,
        _longitude,
        currentPosition.latitude,
        currentPosition.longitude,
      );
      final province = earthquakeData['location']['region1']['province'];
      loadedEvents.add(
        EarthquakeItem(
          id: earthquakeId,
          dateTime: utcDate.toLocal(),
          mag: magnitude,
          dep: double.parse(earthquakeData['depth']),
          city1: earthquakeData['location']['region1']['city'],
          province1: province,
          dist1:
              double.parse(earthquakeData['location']['region1']['distance']),
          city2: earthquakeData['location']['region2']['city'],
          province2: earthquakeData['location']['region2']['province'],
          dist2:
              double.parse(earthquakeData['location']['region2']['distance']),
          city3: earthquakeData['location']['region3']['city'],
          province3: earthquakeData['location']['region3']['province'],
          dist3:
              double.parse(earthquakeData['location']['region3']['distance']),
          lat: _latitude,
          lng: _longitude,
          distance: distance,
          earthquakeClass: magnitudeColorAndClass(magnitude)['magnitudeClass'],
          color: magnitudeColorAndClass(magnitude)['magnitudeColor'],
          isAlrted: (alertMag != null && magnitude > alertMag) ||
                  (alertDist != null && ((distance / 1000) < alertDist)) ||
                  (alertProv != null &&
                      province.trim().toLowerCase() ==
                          alertProv.trim().toLowerCase())
              ? true
              : false,
        ),
      );
    });
    final DateTime latestEventDateTime = loadedEvents.first.dateTime;
    print('latest event datetime: ${latestEventDateTime}');
    // _autoFetchAndSetEvents(latestEventDateTime);
    print(url);
    _items = loadedEvents.reversed.toList();
    Timer(
      Duration(
        // seconds: 30,
        minutes: 1,
      ),
      fetchAndSetEvents,
    );
    notifyListeners();
  }

//does not work
  void _autoFetchAndSetEvents(DateTime latestEventDateTime) {
    if (_refreshTimer != null) {
      _refreshTimer.cancel();
    }
    final currentDateTime = DateTime.now();
    final latestDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        latestEventDateTime.hour,
        latestEventDateTime.minute,
        latestEventDateTime.second);
    final timeToExpiry = latestDateTime.difference(DateTime.now());
    print('will refresh in $timeToExpiry seconds');
    _refreshTimer =
        Timer(Duration(seconds: timeToExpiry as int), fetchAndSetEvents);
  }
}
