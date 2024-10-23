import "package:flutter_test/flutter_test.dart";
import "package:snacktrack/src/extensions/num.dart";

void main() {
  test("Rounding to precision", () async {
    expect(10.028.roundToPrecision(2), equals(10.03));
    expect(1.9.roundToPrecision(0), equals(2));
    expect(4.8.roundToPrecision(1), equals(4.8));
  });

  test("Separating fractions", () async {
    expect(8.7.integer, equals(8));
    expect(8.7.fraction, equals(7));
  });
}
