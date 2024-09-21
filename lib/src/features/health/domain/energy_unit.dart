enum EnergyUnit {
  kilojoules(0, "kJ", "Kilojoules"),
  calories(1, "Cal", "Calories");

  const EnergyUnit(this.value, this.shortName, this.longName);
  final int value;
  final String shortName;
  final String longName;

  static EnergyUnit? fromValue(int value) {
    return EnergyUnit.values.where((e) => e.value == value).firstOrNull;
  }
}
