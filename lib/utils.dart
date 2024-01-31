import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef JsonMap = Map<String, dynamic>;

mixin StateDelayedInit<T extends StatefulWidget> on State<T> {
  void registerDelayedInit(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) => callback());
  }
}

final class Fx {
  static void unFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
