extension MaxMin on Iterable<double> {
  double get max => reduce((current, next) => current > next ? current : next);
  double get min => reduce((current, next) => current < next ? current : next);
}
