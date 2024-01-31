import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_beep/flutter_beep.dart';

import '../screens/main_screen.dart';
import '../providers/earthquakes.dart';

class EventItem extends StatelessWidget {
  final String id;
  const EventItem({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Earthquakes>(context).findById(id);
    event.isAlrted ? FlutterBeep.playSysSound(41) : null;
    return Card(
      color: event.isAlrted == true ? Color.fromARGB(255, 255, 228, 226) : null,
      elevation: 1,
      child: ListTile(
        leading: Container(
          height: double.infinity,
          child: CircleAvatar(
            backgroundColor: event.color,
            child: Text(
              event.mag.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // title: Text('${event.province1}\n${event.city1}'),
        title: Text.rich(
          // maxLines: 2,
          overflow: TextOverflow.fade,
          TextSpan(
            text: '${event.province1}\n',
            children: [
              TextSpan(
                text: '${event.city1}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        subtitle:
            Text(DateFormat('dd/MM/yyyy, HH:mm:ss').format(event.dateTime)),
        // trailing: Text(magnitudeClass.toString().split('.').last),
        trailing: event.distance != null
            ? Text('${(event.distance / 1000).toStringAsFixed(0)} km')
            : Text(event.earthquakeClass.toString().split('.').last),
        onTap: () => Navigator.of(context)
            .pushNamed(MainScreen.routeName, arguments: event),
      ),
    );
  }
}
