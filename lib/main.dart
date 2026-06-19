import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'core/local_store.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LocalStore.load();

  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setDefaultLocale('fr');

  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      child: const BizzApp(),
    ),
  );
}

class BizzApp extends ConsumerWidget {
  const BizzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Bizz',
      debugShowCheckedModeBanner: false,
      theme: BizzTheme.dark,
      darkTheme: BizzTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
