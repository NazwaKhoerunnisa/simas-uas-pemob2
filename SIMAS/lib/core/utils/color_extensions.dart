import 'package:flutter/material.dart';

/// Extension untuk handle Color opacity dengan modern Flutter API
extension ColorOpacity on Color {
  /// Return color dengan opacity tertentu (replacement untuk withOpacity)
  Color withOpacity(double opacity) {
    return withValues(alpha: opacity);
  }
}
