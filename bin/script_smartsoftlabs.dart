import 'dart:io';

import 'package:script_smartsoftlabs/script_smartsoftlabs.dart'
    as script_smartsoftlabs;

void main(List<String> arguments) {
  final File file = File('lib/data/time_series_covid19_deaths_US.csv');
  final lines = file.readAsLinesSync();

  final groupOfCitiesByState =
      script_smartsoftlabs.groupLinesByStateWithoutTerritories(lines);

  final statesData = script_smartsoftlabs.getAllStates(groupOfCitiesByState);

  final stateWithMoreDeaths =
      script_smartsoftlabs.stateWithMaxDeathCasesToDate(statesData);
  print(
      'Estado con mayor acumulado de muertes a la fecha: $stateWithMoreDeaths');
  final stateWithLessDeaths =
      script_smartsoftlabs.stateWithMinDeathCasesToDate(statesData);
  print(
      'Estado con menor acumulado de muertes a la fecha: $stateWithLessDeaths');
  final deathRateVsPopulationByState =
      script_smartsoftlabs.deathRateVsPopulationByState(statesData);
  print('El porcentaje de muertes vs el total de población por estado');
  deathRateVsPopulationByState.forEach((key, value) => {
        print('Estado: $key'),
        print('Porcentaje de muertes: ${value[0]}'),
        print('Total población: ${value[1]}'),
      });

  final mostAffectedState = script_smartsoftlabs.mostAffectedState(statesData);
  print(mostAffectedState);
}
