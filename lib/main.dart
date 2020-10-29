import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:open_weather/config/api.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _location = 'Rodeio';
  String _weather = 'clear';
  int _temperature = 110;
  int _woeid = 123123;

  Future<void> fetchSearch(String input) async {
    final response = await http.get(searchApiUrl + input);
    final jsonResponse = json.decode(response.body)[0];

    setState(() {
      _location = jsonResponse['title'] as String;
      _woeid = jsonResponse['woeid'] as int;
    });
  }

  Future<void> fetchLocation() async {
    final response = await http.get(locationApiUrl + _woeid.toString());
    final jsonResponse = json.decode(response.body);
    final data = jsonResponse['consolidated_weather'][0];

    final formattedWeather = data['weather_state_name']
        .toString()
        .replaceAll(' ', '')
        .trim()
        .toLowerCase();

    setState(() {
      _temperature = data['the_temp'].round() as int;
      _weather = formattedWeather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Weather',
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/$_weather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Center(
                    child: Text(
                      '$_temperature °C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 300,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search another location',
                          alignLabelWithHint: true,
                          filled: false,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
