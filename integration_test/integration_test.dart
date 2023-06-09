import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.signOut();
  });

  testWidgets("Create Account Flow", (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TikTokApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Already have an account?"), findsOneWidget);
    expect(find.text("Use email & password"), findsOneWidget);
    final login = find.text("Log in sir");

    await tester.tap(login);
    await tester.pumpAndSettle();

    final signUp = find.text("Sign up");
    expect(signUp, findsOneWidget);

    await tester.tap(signUp);
    await tester.pumpAndSettle();

    expect(login, findsOneWidget);

    final emailBtn = find.text("Use email & password");
    expect(emailBtn, findsOneWidget);

    await tester.tap(emailBtn);
    await tester.pumpAndSettle();

    final usernameInput = find.byType(TextField).first;
    await tester.enterText(usernameInput, "test");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 3));

    final emailInput = find.byType(TextField).first;
    await tester.enterText(emailInput, "testidforsignuptest@testing.com");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 3));

    final passwordInput = find.byType(TextField).first;
    await tester.enterText(passwordInput, "12345678");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 3));

    expect(find.text("When's your birthday?"), findsOneWidget);

    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(Duration(seconds: 10));

    expect(find.text("Choose your interests"), findsWidgets);
    await tester.pumpAndSettle(Duration(seconds: 5));
  });

  tearDown(() async {
    await FirebaseAuth.instance.currentUser!.delete();
  });
}
