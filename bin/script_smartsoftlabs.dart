import 'dart:io';

import 'package:script_smartsoftlabs/script_smartsoftlabs.dart'
    as script_smartsoftlabs;

void main(List<String> arguments) {
  try {
    final File file = File('lib/data/time_series_covid19_deaths_US.csv');
    final lines = file.readAsLinesSync();

    // group cities by state.
    // removing US territories and states where population is 0.
    final groupOfCitiesByState = script_smartsoftlabs.groupLinesByState(lines);

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

    final mostAffectedState =
        script_smartsoftlabs.mostAffectedState(statesData);
    print('El Estado mas afectado es: ${mostAffectedState.name}');
    print(
        '${mostAffectedState.name} es el estado mas afectado por tener ${mostAffectedState.totalDeaths} muertes en una pobacion de ${mostAffectedState.totalPopulation} habitantes');
    print(
        'Que equivale a un porcentaje de muertes de ${mostAffectedState.deathRateToPercent}');
  } catch (e) {
    print('Could not open the file: $e');
  }
}
