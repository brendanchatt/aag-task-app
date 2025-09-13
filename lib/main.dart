import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

// The reason why this wants it's own file it because this method
/// gets full of a lot of startup logic and initialization
void main() {
  // For example, Initialize firebase

  // For example, any other top level async warmup

  // Needed for orientation statement
  WidgetsFlutterBinding.ensureInitialized();

  // Locks orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(ProviderScope(child: AAGTaskApp()));
  });
}
