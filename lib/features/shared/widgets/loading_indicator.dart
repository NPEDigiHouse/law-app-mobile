// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final bool withScaffold;

  const LoadingIndicator({
    super.key,
    this.size = 32.0,
    this.withScaffold = false,
  });

  @override
  Widget build(BuildContext context) {
    return withScaffold ? Scaffold(body: buildLoadingIndicator()) : buildLoadingIndicator();
  }

  Center buildLoadingIndicator() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: scaffoldBackgroundColor,
        ),
        child: SpinKitThreeBounce(
          size: size,
          color: primaryColor,
          duration: const Duration(milliseconds: 1500),
        ),
      ),
    );
  }
}
