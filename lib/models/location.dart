class Location {
  Location({this.title, this.woeid});

  Location.fromJson(dynamic json) {
    title = json['title'] as String;
    woeid = json['woeid'] as int;
  }

  String title;
  int woeid;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    json['title'] = title;
    json['woeid'] = woeid;

    return json;
  }
}
