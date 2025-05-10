import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  Future<dynamic> push(Widget widget) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => widget));
  }

  void pop() {
    Navigator.of(this).pop();
  }
}
