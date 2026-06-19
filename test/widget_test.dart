import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_before/core/local_store.dart';
import 'package:app_before/main.dart';
import 'package:app_before/providers/auth_provider.dart';

void main() {
  testWidgets('Splash screen shows the Bizz brand', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.load();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: const BizzApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Bizz'), findsOneWidget);
  });
}
