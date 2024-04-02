class Weather {
  double? temp;
  String? weatherMain;
  String? city;
  String? iconId;
  String? description;
  Weather({
    this.temp,
    this.weatherMain,
    this.iconId,
    this.description,
    this.city,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    var weatherJson = json['weather'][0];
    var mainJson = json['main'];

    return Weather(
      temp: mainJson['temp'],
      weatherMain: weatherJson['main'],
      iconId: weatherJson['icon'],
      description: weatherJson['description'],
    );
  }
}
