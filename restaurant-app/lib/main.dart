import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive — on web Hive uses IndexedDB; wrap with a timeout so a
  // browser quirk never blocks the entire app from launching.
  try {
    if (kIsWeb) {
      await Hive.initFlutter().timeout(const Duration(seconds: 5));
    } else {
      await Hive.initFlutter();
    }
  } catch (_) {
    // Hive unavailable — app still runs, offline caching will be skipped.
  }

  runApp(
    const ProviderScope(
      child: RestaurantCopilotApp(),
    ),
  );
}
