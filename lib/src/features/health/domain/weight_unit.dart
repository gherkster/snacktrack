enum WeightUnit {
  kilograms(0, "kg", "Kilograms"),
  pounds(1, "lb", "Pounds");

  const WeightUnit(this.value, this.shortName, this.longName);
  final int value;
  final String shortName;
  final String longName;

  static WeightUnit? fromValue(int value) {
    return WeightUnit.values.where((e) => e.value == value).firstOrNull;
  }
}
