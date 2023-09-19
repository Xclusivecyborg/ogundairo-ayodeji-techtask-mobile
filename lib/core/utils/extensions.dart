import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(this);
  }
}

extension StringExtension on String {
  DateTime get toDateTime {
    return DateTime.parse(this);
  }
}

extension WidgetExtension on Widget {
  Widget get blurImage {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: this,
    );
  }

  Route<T> slideRoute<T>() {
    return PageRouteBuilder<T>(
      barrierDismissible: true,
      reverseTransitionDuration: Duration(milliseconds: 300),
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}
