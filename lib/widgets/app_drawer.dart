import 'package:flutter/material.dart';
import 'package:qzzp/providers/earthquakes.dart';
import 'package:qzzp/screens/setting_screen.dart';

import 'event_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.isLoading,
    required this.earthquakes,
    required this.totalEarthquakes,
    required this.refreshData,
    required this.settingsData,
  });
  final bool isLoading;
  final List<EarthquakeItem> earthquakes;
  final int totalEarthquakes;
  final Function refreshData;
  final settingsData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.amber[400]),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(top: 22, left: 13),
                title: Text.rich(
                  TextSpan(
                      text:
                          '${isLoading ? 'Loading' : '${earthquakes.length}/'}',
                      children: [
                        TextSpan(
                            text: '${isLoading ? '' : '${totalEarthquakes}'}',
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54)),
                        TextSpan(
                            text:
                                ' Earthquake${earthquakes.length > 1 ? 's' : ''}')
                      ]),
                ),
                // '${isLoading ? 'Loading' : '${earthquakes.length} of $totalEarthquakes'} Earthquakes!'),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: Text.rich(
                  style: TextStyle(color: Colors.white),
                  // maxLines: 2,
                  overflow: TextOverflow.fade,
                  TextSpan(
                    text:
                        '    Within ${settingsData['eventsDurationSetting']}\n',
                    children: [
                      ((settingsData['eventsMagnitudeSetting'][0] != '0.0' &&
                                  settingsData['eventsMagnitudeSetting'][0] !=
                                      '0') ||
                              (settingsData['eventsMagnitudeSetting'][1] !=
                                      '10.0' &&
                                  settingsData['eventsMagnitudeSetting'][1] !=
                                      '10'))
                          ? TextSpan(
                              text:
                                  '    Magnitude ${settingsData['eventsMagnitudeSetting']}\n',
                            )
                          // WidgetSpan(
                          //   child: TextButton(
                          //     style: TextButton.styleFrom(
                          //       padding: EdgeInsets.zero,
                          //       minimumSize: Size(double.infinity, 30),
                          //       tapTargetSize:
                          //           MaterialTapTargetSize.shrinkWrap,
                          //       alignment: Alignment.centerLeft,
                          //     ),
                          //     child: Text(
                          //       '    🗑️ Magnitude ${settingsData['eventsMagnitudeSetting']}',
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     onPressed: _resetMagnitude,
                          //   ),
                          // )
                          : TextSpan(),
                      settingsData['eventsProvinceSetting'] != 'disable'
                          ? TextSpan(
                              text:
                                  '    in ${settingsData['eventsProvinceSetting']}',
                            )
                          // WidgetSpan(
                          //   child: TextButton(
                          //     style: TextButton.styleFrom(
                          //       padding: EdgeInsets.zero,
                          //       minimumSize: Size(double.infinity, 30),
                          //       tapTargetSize:
                          //           MaterialTapTargetSize.shrinkWrap,
                          //       alignment: Alignment.centerLeft,
                          //     ),
                          //     child: Text(
                          //       '    🗑️ in ${settingsData['eventsProvinceSetting']}',
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     onPressed: _resetProvince,
                          //   ),
                          // )
                          : TextSpan(),
                    ],
                  ),
                ),
                trailing: IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(SettingScreen.routeName),
                  icon: Icon(
                    Icons.settings,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => refreshData(context),
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        EventItem(id: earthquakes[index].id),
                    itemCount: earthquakes.length,
                  ),
                ),
        ),
      ],
    );
  }
}
