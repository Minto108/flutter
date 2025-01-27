// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:parkit_clone/main.dart';


void main() {
  testWidgets('ParkIt app displays title, description, and menu', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(ParkItApp());

    // Verify that the title and description are displayed.
    expect(find.text('ParkIt'), findsOneWidget);
    expect(find.text('Welcome to ParkIt...'), findsOneWidget);

    // Verify that the menu icon is present.
    expect(find.byIcon(Icons.more_vert), findsOneWidget);

    // Simulate opening the menu and verify options are shown.
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pump(); // Rebuild the widget tree.

    expect(find.text('Option 1'), findsOneWidget);
    expect(find.text('Option 2'), findsOneWidget);
    expect(find.text('Option 3'), findsOneWidget);
  });
}

