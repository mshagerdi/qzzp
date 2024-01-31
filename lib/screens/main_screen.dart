import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qzzp/widgets/app_drawer.dart';

import '../screens/setting_screen.dart';
import '../providers/earthquakes.dart';
import '../widgets/event_item.dart';
import '../widgets/map_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = '/map-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _clickedItemId = '0';

  @override
  void didChangeDependencies() {
    final _clickedItem = ModalRoute.of(context)!.settings.arguments;
    if (_clickedItem is EarthquakeItem) {
      _clickedItemId = _clickedItem.id;
      print('${_clickedItem.id} is clicked');
      return;
    } else {
      print('Not any item clicked yet! {$_clickedItemId}');
      if (_isInit) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<Earthquakes>(context).fetchAndSetEvents().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Earthquakes>(context, listen: false).fetchAndSetEvents();
  }

  @override
  Widget build(BuildContext context) {
    final earthquakesData = Provider.of<Earthquakes>(context, listen: true);
    final earthquakes = earthquakesData.items;

    return FutureBuilder<Map<String, dynamic>>(
      builder: (_, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text('qzzp'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
        drawer: Drawer(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : snapshot.data == null
                  ? Center(child: CircularProgressIndicator())
                  : AppDrawer(
                      isLoading: _isLoading,
                      earthquakes: earthquakesData.findByProvinceAndMagnitude(
                          snapshot.data!['eventsProvinceSetting'],
                          snapshot.data!['eventsMagnitudeSetting']),
                      totalEarthquakes: earthquakes.length,
                      refreshData: _refreshData,
                      settingsData: snapshot.data,
                    ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : snapshot.data == null
                ? Center(child: CircularProgressIndicator())
                : MapWidget(
                    clickedItemId: _clickedItemId,
                    earthquakes: earthquakesData.findByProvinceAndMagnitude(
                        snapshot.data!['eventsProvinceSetting'],
                        snapshot.data!['eventsMagnitudeSetting']),
                  ),
      ),
      future: earthquakesData.SettingsData(),
    );
  }
}
