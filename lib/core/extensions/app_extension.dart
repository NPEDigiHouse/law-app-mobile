import 'package:flutter/material.dart';

extension Capitalize on String {
  String toCapitalize() {
    return split(' ').map((e) {
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1, e.length)}';
    }).join(' ');
  }
}

extension Navigation on BuildContext {
  void push(Widget page, {Object? data}) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );
  }

  void pushReplacement(Widget page, {Object? data}) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );
  }

  void pushAndRemoveUntil(Widget page, {Object? data}) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
      (route) => false,
    );
  }

  void pop([Object? result]) {
    Navigator.pop(this, result);
  }
}
