import 'dart:io';

import 'package:script_smartsoftlabs/script_smartsoftlabs.dart'
    as script_smartsoftlabs;

void main(List<String> arguments) {
  final File file = File('lib/data/time_series_covid19_deaths_US.csv');
  final lines = file.readAsLinesSync();

  final groupOfCitiesByState = script_smartsoftlabs.groupLinesByState(lines);

  final statesData = script_smartsoftlabs.getAllStates(groupOfCitiesByState);
  for (final state in statesData) {
    print('State name: ${state.name}');
    print('State total deaths: ${state.totalDeaths}');
    print('State total population: ${state.totalPopulation}');
    print('State total cities: ${state.totalCities}');
    print('\n');
    print('\n');
  }

  final stateWithMoreDeaths =
      script_smartsoftlabs.stateWithMaxDeathCasesToDate(statesData);
  print(stateWithMoreDeaths);

  final stateWithLessDeaths =
      script_smartsoftlabs.stateWithMinDeathCasesToDate(statesData);
  print(stateWithLessDeaths);

  final mostAffectedState = script_smartsoftlabs.mostAffectedState(statesData);
  print(mostAffectedState);

  /*List<String> statesCol = [];
   inputStream
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .listen((String line) {
    final List<String> cols = line.split(',');
    statesCol.add(cols[6]);
  });
  List<String> statesList = script_smartsoftlabs.getAllStates(statesCol);
  print(statesList); */

  /* File csvFile = File('lib/data/time_series_covid19_deaths_US.csv');
  final inputStream = csvFile.openRead();
  final fields = await inputStream
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .toList();

  final labels = fields[0];

  print(labels); */
}
