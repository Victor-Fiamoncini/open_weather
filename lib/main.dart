import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  String _location = 'San Fransisco';
  int _woeid = 2487956;
  String _weather = 'clear';
  int _temperature;
  String _abbrevation = 'h';

  @override
  void initState() {
    super.initState();

    fetchLocation();
  }

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
      final data = jsonResponse['consolidated_weather'][0];

      final weatherInstance = Weather.fromJson(data);

      final formattedTemp = weatherInstance.theTemp.round();

      final formattedWeather = weatherInstance.weatherStateName
          .toString()
          .replaceAll(' ', '')
          .toLowerCase();

      setState(() {
        _temperature = formattedTemp;
        _weather = formattedWeather;
        _abbrevation = weatherInstance.weatherStateAbbr;
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
            image: AssetImage('lib/assets/images/backgrounds/$_weather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _temperature == null
            ? const Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 100,
                ),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Image.network(
                              '$weatherIconUrl$_abbrevation.png',
                              width: 100,
                            ),
                          ),
                        ),
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
                              textCapitalization: TextCapitalization.words,
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
