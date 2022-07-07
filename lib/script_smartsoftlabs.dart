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

/// Return a Map with the states and the cities of each state.
/// The keys are the states and the values are the list of cities of each state.
/// The list of cities is a list of lines not city objects.
Map<String, List<String>> groupLinesByState(List<String> lines) {
  lines.removeAt(0);
  final states = <String, List<String>>{};
  for (final line in lines) {
    final List<String> values = line.split(',');
    final String state = values[6];
    if (states[state] == null) {
      states[state] = <String>[];
      states[state]!.add(line);
    } else {
      states[state]!.add(line);
    }
  }
  return states;
}

/// Return a list of states with the cities of each state.
/// without US territories
Map<String, List<String>> groupLinesByStateWithoutTerritories(
    List<String> lines) {
  lines.removeAt(0);
  final states = <String, List<String>>{};
  for (final line in lines) {
    final List<String> values = line.split(',');
    final String state = values[6];
    final String territory = values[2];
    if (territory == 'USA') {
      if (states[state] == null) {
        states[state] = <String>[];
        states[state]!.add(line);
      } else {
        states[state]!.add(line);
      }
    }
  }
  return states;
}

List<State> getAllStates(Map<String, List<String>> mapOfLinesByState) {
  List<State> statesList = [];
  List<City> cities = [];

  mapOfLinesByState.forEach((key, value) {
    // key = state, value = list of lines
    cities = [];
    for (final line in value) {
      final List<String> values = line.split(',');
      final String cityName = values[5];
      final int deaths = int.parse(values.last);
      final int population = int.parse(values[13]);
      // do not add a city where population is 0.
      // which means there is an error with the data.
      if (population != 0) {
        cities.add(City(
          name: cityName,
          deaths: deaths,
          population: population,
        ));
      }
    }
    statesList.add(State(
      name: key,
      cities: cities,
    ));
  });

  return cleanStatesByPopulation(statesList);
}

List<State> cleanStatesByPopulation(List<State> states) {
  List<State> statesList = [];
  for (final state in states) {
    if (state.totalPopulation != 0) {
      statesList.add(state);
    }
  }
  return statesList;
}

List<City> getAllCities(List<String> citiesLines, List<City> citiesList) {
  for (final line in citiesLines) {
    final List<String> values = line.split(',');
    final String cityName = values[0];
    final int deaths = int.parse(values.last);
    final int population = int.parse(values[13]);
    citiesList.add(City(
      name: cityName,
      deaths: deaths,
      population: population,
    ));
  }
  return citiesList;
}

int getDeathsByState(List<int> deathsByCity) {
  int totalDeaths = 0;
  for (int death in deathsByCity) {
    totalDeaths += death;
  }
  return totalDeaths;
}

/// get all states in the list. then, removes duplicates.
///
/// removes first element, which is the header
List<String> getAllStatesWithoutDuplicates(List<String> states) {
  return states.toSet().toList();
}

/// get all states entries in the file.
///
/// removes first element, which is the header
List<String> getAllStatesEntries(List<String> lines) {
  List<String> allStates = [];
  for (var line in lines) {
    final values = line.split(',');
    final state = values[6];
    allStates.add(state);
  }
  allStates.removeAt(0);
  return allStates;
}

// Estado con mayor acumulado a la fecha

String stateWithMaxDeathCasesToDate(List<State> states) {
  int maxDeaths = 0;
  String maxState = '';
  for (State state in states) {
    if (state.totalDeaths > maxDeaths) {
      maxDeaths = state.totalDeaths;
      maxState = state.name;
    }
  }
  return maxState;
}

// Estado con menor acumulado a la fecha

String stateWithMinDeathCasesToDate(List<State> states) {
  int minDeaths = 100000000000;
  String minState = '';
  for (State state in states) {
    if (state.totalDeaths < minDeaths) {
      minDeaths = state.totalDeaths;
      minState = state.name;
    }
  }
  return minState;
}

// El porcentaje de muertes vs el total de población por estado
Map<String, List<String>> deathRateVsPopulationByState(List<State> states) {
  Map<String, List<String>> statesWithDeathRate = {};
  for (State state in states) {
    statesWithDeathRate[state.name] = [
      state.deathRateToPercent,
      state.totalPopulation.toString(),
    ];
  }
  return statesWithDeathRate;
}

// Cual fue el estado mas afectado
// el estado mas afectado es aquel que el porcentaje de muertes es alto
// con respecto a la población.
String mostAffectedState(List<State> states) {
  // we need to compare the total population
  // vs the total deaths
  for (State state in states) {
    double deathRate = state.totalDeaths / state.totalPopulation;
    if (deathRate > 0.50) {
      return state.name;
    }
  }
  return '';
}
