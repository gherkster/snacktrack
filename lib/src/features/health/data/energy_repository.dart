import "package:snacktrack/objectbox.g.dart";
import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/features/health/data/models/energy_intake_measurement_dto.dart";
import "package:snacktrack/src/features/health/domain/energy_intake_measurement.dart";

class EnergyRepository {
  final Store store;
  final Box<EnergyIntakeMeasurementDto> _box;

  EnergyRepository(this.store) : _box = store.box<EnergyIntakeMeasurementDto>();

  void addKj(double amount, DateTime time) =>
      _box.put(EnergyIntakeMeasurementDto(kilojoules: amount.roundToPrecision(2), time: time));

  List<EnergyIntakeMeasurement> getSince(DateTime time) {
    var query = _box.query(EnergyIntakeMeasurementDto_.time.greaterOrEqualDate(time)).build();

    var results = query.find();
    query.close();

    return results.map((r) => r.mapToDomain()).toList();
  }

  Future<void> deleteAll() async => await _box.removeAllAsync();
}

extension Mapping on EnergyIntakeMeasurementDto {
  EnergyIntakeMeasurement mapToDomain() {
    return EnergyIntakeMeasurement(id: id, kilojoules: kilojoules, time: time);
  }
}
