import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:open_weather/config/api.dart';
import 'package:open_weather/models/location.dart';
import 'package:open_weather/models/weather.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _location;
  int _woeid;
  String _weather;
  int _temperature;

  Future<void> fetchSearch(String input) async {
    try {
      final response = await http.get(searchApiUrl + input);
      final jsonResponse = jsonDecode(response.body)[0];

      final locationInstance = Location.fromJson(jsonResponse);

      setState(() {
        _location = locationInstance.title;
        _woeid = locationInstance.woeid;
      });
    } catch (e) {
      print('Error to search location');
    }
  }

  Future<void> fetchLocation() async {
    final url = locationApiUrl + _woeid.toString();

    try {
      final response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      final consolidatedWeather = jsonResponse['consolidated_weather'];
      final data = consolidatedWeather[0];

      final weatherInstance = Weather.fromJson(data);

      final formattedTemp = weatherInstance.theTemp.round();

      final formattedWeather = weatherInstance.weatherStateName
          .toString()
          .replaceAll(' ', '')
          .toLowerCase();

      setState(() {
        _temperature = formattedTemp;
        _weather = formattedWeather;
      });
    } catch (e) {
      print('Error to search weather');
    }
  }

  Future<void> onTextFieldSubmitted(String input) async {
    await fetchSearch(input);
    await fetchLocation();
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
                      _temperature != null ? '$_temperature °C' : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _location ?? '',
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
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        onSubmitted: (input) async {
                          await onTextFieldSubmitted(input);
                        },
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                        decoration: const InputDecoration(
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
