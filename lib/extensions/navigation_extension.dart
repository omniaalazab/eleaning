import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  Future<dynamic> push(Widget widget) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => widget));
  }

  Future<dynamic> pushRemoveUntil(Widget widget) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => widget),
      (route) => false,
    );
  }

  void pop() {
    Navigator.of(this).pop();
  }
}
