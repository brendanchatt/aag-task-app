import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

// The reason why this wants it's own file it because this method
/// gets full of a lot of startup logic and initialization
void main() {
  // For example, Initialize firebase

  // For example, any other top level async warmup

  runApp(ProviderScope(child: AAGTaskApp()));
}
