import 'dart:async';

class TotalValueBloc {
  StreamController _totalValueController = StreamController<String>.broadcast();
  Stream get totalValueStream => _totalValueController.stream;

  dispose() {
    _totalValueController.close();
  }

  updateTotalValue(String total){
    _totalValueController.sink.add(total);
  }
}

final totalValueBloc = TotalValueBloc();