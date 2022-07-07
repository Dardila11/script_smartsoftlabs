import 'models/city.dart';
import 'models/state.dart';

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

/// Same as [groupLinesByState]
/// but without US territories.
/// All entries with territory equal to 'USA' only
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

/// return a list of states with the cities of each state.
/// add all cities except those with population 0 and death are 0.
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
      // do not add a city where population is 0 and deaths are 0
      // which means there is an error with the data.
      if (population != 0 && deaths != 0) {
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

// remove states with population 0.
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

/// State with the most accumulated deaths to date.
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

/// State with the least accumulated deaths to date.
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

// percent of deaths vs total population by state
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

/// returns the state with the highest death rate.
State mostAffectedState(List<State> states) {
  double maxDeathRate = 0;
  late State aState;
  for (State state in states) {
    var deathRate = state.deathsRatePerPopulation;
    if (deathRate > maxDeathRate) {
      maxDeathRate = deathRate;
      aState = state;
    }
  }
  return aState;
}
