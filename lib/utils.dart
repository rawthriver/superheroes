import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Utils {
  static void noop() {}

  static void unFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

mixin StateDelayedInit<T extends StatefulWidget> on State<T> {
  void registerDelayedInit(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) => callback());
  }
}
