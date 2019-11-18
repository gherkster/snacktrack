import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver{
    LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

    final AsyncCallback resumeCallBack;
    final AsyncCallback suspendingCallBack;

    @override
    Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
      switch (state) {
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.suspending:
          await suspendingCallBack();
          break;
        case AppLifecycleState.resumed:
          await resumeCallBack();
          break;
      }
    }
}