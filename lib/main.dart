import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _text = new Map();
  var _emoticon = new Map();

  void fetch() async {
    final city = await http.get('http://ipinfo.io/?callback');
    final _city = jsonDecode(city.body);
    final response = await http.get('http://wttr.in/${_city['city']}?format={%20%22temp%22:%20%22%t%22%20}');
    final emoticon = await http.get('http://wttr.in/${_city['city']}?format={%20%22emotic%22:%20%22%emotic%22%20}');
    setState(() {
      _text = jsonDecode(response.body);
      _emoticon = jsonDecode(emoticon.body);
    });
  }
  @override
  void initState() {
    super.initState();
    fetch();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                '${_emoticon['emotic']}',
                style: Theme.of(context).textTheme.display1
            ),
            Text(
                '${_text['temp']}',
                style: Theme.of(context).textTheme.display1

            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetch,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
