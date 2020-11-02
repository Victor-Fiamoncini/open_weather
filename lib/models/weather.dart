class Weather {
  Weather({
    this.weatherStateAbbr,
    this.weatherStateName,
    this.minTemp,
    this.maxTemp,
    this.theTemp,
  });

  Weather.fromJson(dynamic json) {
    weatherStateAbbr = json['weather_state_abbr'] as String;
    weatherStateName = json['weather_state_name'] as String;
    minTemp = json['min_temp'] as double;
    maxTemp = json['max_temp'] as double;
    theTemp = json['the_temp'] as double;
  }

  String weatherStateAbbr;
  String weatherStateName;
  double minTemp;
  double maxTemp;
  double theTemp;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['weather_state_abbr'] = theTemp;
    data['weather_state_name'] = weatherStateName;
    data['min_temp'] = minTemp;
    data['max_temp'] = maxTemp;
    data['the_temp'] = theTemp;

    return data;
  }
}
