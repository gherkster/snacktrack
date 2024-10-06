extension MaxMin on Iterable<double> {
  double get max => reduce((current, next) => current > next ? current : next);
  double get min => reduce((current, next) => current < next ? current : next);
}

extension IsIn<T> on T {
  bool isIn(Iterable<T> items) {
    return items.contains(this);
  }
}
