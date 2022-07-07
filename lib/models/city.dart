class City {
  final String name;
  final int deaths;
  final int population;

  City({
    required this.name,
    required this.deaths,
    required this.population,
  });

  double get deathsRatePerPopulation => deaths / population;
}
