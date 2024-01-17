import 'package:flutter/material.dart';

extension Capitalize on String {
  String toCapitalize() {
    return split(' ').map((e) {
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1, e.length)}';
    }).join(' ');
  }
}

extension FilledButtonFullWidth on FilledButton {
  SizedBox fullWidth() {
    return SizedBox(
      width: double.infinity,
      child: this,
    );
  }
}

extension OutlinedButtonFullWidth on OutlinedButton {
  SizedBox fullWidth() {
    return SizedBox(
      width: double.infinity,
      child: this,
    );
  }
}
