import 'city.dart';

class State {
  final String name;
  final List<City> cities;

  State({
    required this.name,
    required this.cities,
  });

  double get deathsRatePerPopulation => (totalDeaths / totalPopulation);

  int get totalDeaths => cities.fold(0, (sum, city) => sum + city.deaths);

  String get deathRateToPercent =>
      '${(deathsRatePerPopulation * 100).toStringAsFixed(3)}%';

  int get totalPopulation =>
      cities.fold(0, (sum, city) => sum + city.population);

  int get totalCities => cities.length;
}
