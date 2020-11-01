class Weather {
  Weather({this.weatherStateName, this.theTemp});

  Weather.fromJson(dynamic json) {
    weatherStateName = json['weather_state_name'] as String;
    theTemp = json['the_temp'] as double;
  }

  String weatherStateName;
  double theTemp;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['weather_state_name'] = weatherStateName;
    data['the_temp'] = theTemp;

    return data;
  }
}
