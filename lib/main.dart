import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:open_weather/config/api.dart';
import 'package:open_weather/models/location.dart' as location_dto;
import 'package:open_weather/models/weather.dart';
import 'package:open_weather/widgets/forecast_item.dart';

Future<void> main() async {
  await DotEnv().load();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _location = 'San Fransisco';
  int _woeid = 2487956;
  String _weather = 'clear';
  int _temperature = 20;
  String _abbrevation = 'h';
  String _error = '';
  Position _currentPosition;
  final List<int> _minTemperatureForecast = List(7);
  final List<int> _maxTemperatureForecast = List(7);
  final List<String> _abbrevationForecast = List(7);

  @override
  void initState() {
    super.initState();

    _getCurrentGeoLocation();
  }

  Future<void> _fetchSearch(String input) async {
    try {
      final response = await http.get(searchApiUrl + input);
      final jsonResponse = jsonDecode(response.body)[0];

      final locationJson = location_dto.Location.fromJson(jsonResponse);

      setState(() {
        _location = locationJson.title;
        _woeid = locationJson.woeid;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = "Sorry, we don't have data about this city. Try another one.";
      });
    }
  }

  Future<void> _fetchLocation() async {
    final url = locationApiUrl + _woeid.toString();

    try {
      final response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['consolidated_weather'][0];

      final weatherJson = Weather.fromJson(data);

      final formattedTemp = weatherJson.theTemp.round();

      final formattedWeather = weatherJson.weatherStateName
          .toString()
          .replaceAll(' ', '')
          .toLowerCase();

      setState(() {
        _temperature = formattedTemp;
        _weather = formattedWeather;
        _abbrevation = weatherJson.weatherStateAbbr;
      });
    } catch (e) {
      print('Error to search weather');
    }
  }

  Future<void> _fetchWeekWeathersFromToday() async {
    final today = DateTime.now();

    for (var i = 0; i < 6; i++) {
      final formattedToday = today.add(Duration(days: i + 1)).toString();
      final formattedDate = DateFormat('y/M/d', formattedToday);

      final url = '$locationApiUrl$_woeid/$formattedDate';
      final response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);

      final weatherJson = Weather.fromJson(jsonResponse[0]);

      setState(() {
        _minTemperatureForecast[i] = weatherJson.minTemp.round();
        _maxTemperatureForecast[i] = weatherJson.maxTemp.round();
        _abbrevationForecast[i] = weatherJson.weatherStateAbbr;
      });
    }

    print(_minTemperatureForecast);
  }

  Future<void> _onTextFieldSubmitted(String input) async {
    await _fetchSearch(input);
    await _fetchLocation();
    await _fetchWeekWeathersFromToday();
  }

  Future<void> _getCurrentGeoLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();

      setState(() {
        _currentPosition = position;
      });

      await _getAddressFromLatLng();
    } catch (e) {
      print('Error to get current location $e');
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );

      final place = placemarks[0].locality;

      await _fetchSearch(place);
      await _fetchLocation();
    } catch (e) {
      print('Error to get address from lat/lng');
    }
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
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.dstATop,
            ),
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
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () async {
                          await _getCurrentGeoLocation();
                        },
                        child: const Icon(
                          Icons.location_city,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
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
                              fontSize: 52,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            _location ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0; i < 6; i++)
                            ForecastItem(
                              daysFromNow: i + 1,
                              abbrevation: _abbrevationForecast[i],
                              minTemperature: _minTemperatureForecast[i],
                              maxTemperature: _maxTemperatureForecast[i],
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              onSubmitted: (input) async {
                                await _onTextFieldSubmitted(input);
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _error,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
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
