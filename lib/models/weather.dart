class Weather {
  Weather({this.weatherStateName, this.theTemp, this.weatherStateAbbr});

  Weather.fromJson(dynamic json) {
    weatherStateName = json['weather_state_name'] as String;
    theTemp = json['the_temp'] as double;
    weatherStateAbbr = json['weather_state_abbr'] as String;
  }

  String weatherStateName;
  double theTemp;
  String weatherStateAbbr;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['weather_state_name'] = weatherStateName;
    data['the_temp'] = theTemp;
    data['weather_state_abbr'] = theTemp;

    return data;
  }
}
