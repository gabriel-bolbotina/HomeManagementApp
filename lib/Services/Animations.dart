import 'package:flutter/material.dart';

class Animations<T> extends PageRouteBuilder<T> {
  final Widget page;
  final RouteAnimationType animationType;

  Animations({required this.page, required this.animationType})
      : super(
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (animationType) {
        case RouteAnimationType.fade:
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        case RouteAnimationType.slideFromRight:
          const begin = Offset(0.0, -1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutSine;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        case RouteAnimationType.slideFromBottom:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
      // Add more animation types as needed
        default:
          return child;
      }
    },
  );
}

enum RouteAnimationType {
  fade,
  slideFromRight,
  slideFromBottom,
  // Add more animation types as needed
}
