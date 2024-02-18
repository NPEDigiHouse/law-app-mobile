import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';

/// A collection of helper functions that are reusable for this app
class FunctionHelper {
  /// Generate a random text
  static String generateRandomText({
    int maxLength = 8,
    bool isLetter = true,
    bool isNumber = true,
    bool isSpecial = true,
  }) {
    const letterLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const letterUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    var chars = '';

    if (isLetter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += number;
    if (isSpecial) chars += special;

    return List<String>.generate(
      maxLength,
      (_) => chars[Random.secure().nextInt(chars.length)],
    ).join('');
  }

  static String formattedCountDownTimer([int seconds = 0]) {
    final sec = '${seconds % 60}'.padLeft(2, '0');
    final min = '${seconds ~/ 60}'.padLeft(2, '0');

    return '$min:$sec';
  }

  static Color getColorByDiscussionStatus(String status) {
    switch (status) {
      case 'open':
        return infoColor;
      case 'discuss':
        return warningColor;
      case 'solved':
        return successColor;
      default:
        return secondaryTextColor;
    }
  }

  static bool handleFabVisibilityOnScroll(
    UserScrollNotification notification,
    AnimationController fabAnimationController,
  ) {
    if (notification.depth == 0) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          if (notification.metrics.maxScrollExtent !=
              notification.metrics.minScrollExtent) {
            if (notification.metrics.pixels != 0) {
              fabAnimationController.forward();
            }
          }
          break;

        case ScrollDirection.reverse:
          if (notification.metrics.maxScrollExtent !=
              notification.metrics.minScrollExtent) {
            fabAnimationController.reverse();
          }
          break;

        case ScrollDirection.idle:
          break;
      }
    }

    return false;
  }

  static void handleSearchingOnPop(
    WidgetRef ref,
    bool didPop,
    bool isSearching,
  ) {
    if (didPop) return;

    if (isSearching) {
      ref.read(isSearchingProvider.notifier).state = false;
    } else {
      navigatorKey.currentState!.pop();
    }
  }
}
