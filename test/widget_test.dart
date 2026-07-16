import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder/main.dart';

void main() {
  testWidgets('selector page renders both destinations', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const ProviderScope(child: BuilderApp()));
    expect(find.text('Form Studio Selector'), findsOneWidget);
    expect(find.text('Open Existing Builder'), findsOneWidget);
    expect(find.text('Open New Design Page'), findsOneWidget);
  });

  testWidgets('existing builder remains reachable from selector', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const ProviderScope(child: BuilderApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Existing Builder'));
    await tester.pumpAndSettle();

    expect(find.text('A.D.I.Y.O.G.I Builder'), findsOneWidget);
    expect(find.text('Component Library'), findsOneWidget);
    expect(find.text('Canvas'), findsOneWidget);
    expect(find.text('Properties Inspector'), findsOneWidget);
  });

  testWidgets('new design page opens as an isolated showcase', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const ProviderScope(child: BuilderApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open New Design Page'));
    await tester.pumpAndSettle();

    expect(find.text('Form Design Controls'), findsOneWidget);
    expect(find.text('Live Preview'), findsOneWidget);
    expect(find.text('A.D.I.Y.O.G.I Builder'), findsNothing);
  });
}
