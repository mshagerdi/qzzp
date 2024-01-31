import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './event_item.dart';
import '../screens/setting_screen.dart';
import '../providers/earthquakes.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final earthquakesData = Provider.of<Earthquakes>(context);
    final earthquakes = earthquakesData.items;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('${earthquakes.length} Earthquakes!'),
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(SettingScreen.routeName),
                icon: Icon(
                  Icons.settings,
                ),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (context, index) =>
                      EventItem(id: earthquakes[index].id),
                  itemCount: earthquakes.length,
                ),
        ],
      ),
    );
  }
}
