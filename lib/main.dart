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
  String _weather = 'clear';
  int _temperature = 0;
  int _woeid;

  Future<void> fetchSearch(String input) async {
    try {
      final response = await http.get(searchApiUrl + input);
      final jsonResponse = jsonDecode(response.body)[0];

      final _locationInstance = Location.fromJson(jsonResponse);

      setState(() {
        _location = _locationInstance.title;
        _woeid = _locationInstance.woeid;
      });
    } catch (e) {
      print('Error to search location');
    }
  }

  Future<void> fetchLocation() async {
    // final url = locationApiUrl + _woeid;

    print(_woeid);

    // try {
    // final response = await http.get(url);
    // final jsonResponse = jsonDecode(response.body);
    // final consolidatedWeather = jsonResponse['consolidated_weather'];

    // print('CONSOOOO $consolidatedWeather');

    // final data = consolidatedWeather[0];

    // print('DATA $data');

    // final _weatherInstance = Weather.fromJson(data);

    // print('AAAAAAAAA');
    // print('Weather $_weatherInstance');

    // setState(() {
    //   _temperature = _weatherInstance.theTemp.round();
    //   _weather = _weatherInstance.weatherStateName
    //       .toString()
    //       .replaceAll(' ', '')
    //       .toLowerCase();
    // });
    // } catch (e) {
    //   print('ERRO 2 $e');
    // }
  }

  void onTextFieldSubmitted(String input) {
    fetchSearch(input);
    fetchLocation();
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
                        onSubmitted: (input) {
                          onTextFieldSubmitted('London');
                          // onTextFieldSubmitted(input);
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
