import "package:snacktrack/objectbox.g.dart";
import "package:snacktrack/src/extensions/num.dart";
import "package:snacktrack/src/features/health/data/models/weight_measurement_dto.dart";
import "package:snacktrack/src/features/health/domain/weight_measurement.dart";

class WeightRepository {
  final Box<WeightMeasurementDto> _box;

  WeightRepository(this._box);

  void addKg(double amount, DateTime time) =>
      _box.put(WeightMeasurementDto(kilograms: amount.roundToPrecision(2), time: time));

  WeightMeasurement? getLatest() =>
      _box.query().order(WeightMeasurementDto_.time, flags: Order.descending).build().findFirst()?.mapToDomain();

  List<WeightMeasurement> getSince(DateTime time) {
    var query = _box.query(WeightMeasurementDto_.time.greaterOrEqualDate(time)).build();

    var results = query.find();
    query.close();

    return results.map((r) => r.mapToDomain()).toList();
  }

  Future<void> deleteAll() async => await _box.removeAllAsync();
}

extension Mapping on WeightMeasurementDto {
  WeightMeasurement mapToDomain() {
    return WeightMeasurement(id: id, kilograms: kilograms, time: time);
  }
}
