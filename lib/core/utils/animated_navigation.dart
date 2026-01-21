import 'package:flutter/material.dart';

/// Custom PageRoute dengan Slide Transition
class SlidePageRoute extends PageRoute {
  final WidgetBuilder builder;
  final String? title;
  final Duration _transitionDuration;

  SlidePageRoute({
    required this.builder,
    this.title,
    Duration transitionDuration = const Duration(milliseconds: 400),
  }) : _transitionDuration = transitionDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: child,
    );
  }
}

/// Custom PageRoute dengan Fade Transition
class FadePageRoute extends PageRoute {
  final WidgetBuilder builder;
  final String? title;
  final Duration _transitionDuration;

  FadePageRoute({
    required this.builder,
    this.title,
    Duration transitionDuration = const Duration(milliseconds: 400),
  }) : _transitionDuration = transitionDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

/// Custom PageRoute dengan Scale + Fade Transition
class ScalePageRoute extends PageRoute {
  final WidgetBuilder builder;
  final String? title;
  final Duration _transitionDuration;

  ScalePageRoute({
    required this.builder,
    this.title,
    Duration transitionDuration = const Duration(milliseconds: 500),
  }) : _transitionDuration = transitionDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.elasticOut),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Helper function untuk navigate dengan custom animation
class AnimatedNavigation {
  static void slideNavigate(BuildContext context, Widget page) {
    Navigator.push(context, SlidePageRoute(builder: (_) => page));
  }

  static void fadeNavigate(BuildContext context, Widget page) {
    Navigator.push(context, FadePageRoute(builder: (_) => page));
  }

  static void scaleNavigate(BuildContext context, Widget page) {
    Navigator.push(context, ScalePageRoute(builder: (_) => page));
  }

  static void namedNavigate(BuildContext context, String routeName) {
    Navigator.push(context, SlidePageRoute(builder: (_) => Container()));
    Navigator.pushNamed(context, routeName);
  }
}
