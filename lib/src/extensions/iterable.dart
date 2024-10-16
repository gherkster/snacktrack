extension Math on Iterable<double> {
  double max() => reduce((current, next) => current > next ? current : next);
  double min() => reduce((current, next) => current < next ? current : next);
  double sum() => fold(0, (previous, current) => previous + current);
}

extension IsIn<T> on T {
  bool isIn(Iterable<T> items) {
    return items.contains(this);
  }
}
