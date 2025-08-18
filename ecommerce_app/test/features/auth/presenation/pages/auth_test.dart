import 'package:ecommerce_app/core/presentation/routes/routes.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}
class MockGoRouter extends Mock implements GoRouter {}
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() async {
    mockAuthBloc = MockAuthBloc();
    mockGoRouter = MockGoRouter();
    when(() => mockGoRouter.go(any())).thenAnswer((_) async {});
    // Increase viewport size to accommodate tall forms
    // await tester.binding.setSurfaceSize(const Size(800, 1200));
  });

  Widget createWidgetUnderTest(Widget widget) {
    return InheritedGoRouter(
      goRouter: mockGoRouter,
      child: MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: widget,
        ),
        navigatorKey: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(body: Container()),
        ),
      ),
    );
  }

  group('SplashScreen', () {
    testWidgets('displays splash screen UI elements', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SplashScreen()));
      await tester.pump(const Duration(seconds: 12));
      await tester.pump();

      expect(find.text('ECOM'), findsOneWidget);
      expect(find.text('ECOMMERCE APP'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('navigates to home on AuthLoadSuccess', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthLoadSuccess(AuthenticatedUser(
            id: '1',
            name: 'Test',
            email: 'test@example.com',
            accessToken: 'mock_token',
          )),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SplashScreen()));
      await tester.pump(const Duration(seconds: 12));
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.go(Routes.home)).called(1);
    });

    testWidgets('navigates to login on AuthLoadFailure', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthLoadFailure('Failed to load'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SplashScreen()));
      await tester.pump(const Duration(seconds: 12));
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.go(Routes.login)).called(1);
    });
  });

  group('LoginPage', () {
    // testWidgets('displays login page UI elements', (WidgetTester tester) async {
    //   when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
    //   when(() => mockAuthBloc.stream).thenAnswer(
    //     (_) => Stream.value(const AuthInitial()),
    //   );

    //   await tester.pumpWidget(createWidgetUnderTest(const LoginPage()));
    //   await tester.pump();
    //   debugDumpApp(); // Debug widget tree

    //   expect(find.text('Sign into your account'), findsOneWidget);
    //   expect(find.text('Email'), findsOneWidget);
    //   expect(find.text('Password'), findsOneWidget);
    //   expect(find.text('SIGN IN'), findsOneWidget);
    //   expect(
    //     find.byWidgetPredicate(
    //       (widget) => widget is RichText && widget.text.toPlainText().contains('Sign Up'),
    //       description: 'RichText containing "Sign Up"',
    //     ),
    //     findsOneWidget,
    //   );
    // });

    testWidgets('triggers login when form is valid and button pressed', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(const LoginPage()));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      final signInFinder = find.text('SIGN IN');
      expect(signInFinder, findsOneWidget, reason: 'SIGN IN button not found');
      await tester.ensureVisible(signInFinder);
      await tester.pumpAndSettle();
      await tester.tap(signInFinder);
      await tester.pump();

      verify(() => mockAuthBloc.add(
            const AuthLoginRequested('test@example.com', 'password123'),
          )).called(1);
    });

    testWidgets('shows error snackbar on AuthLoginFailure', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthLoginFailure('Invalid credentials'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest(const LoginPage()));
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('navigates to home on AuthLoginSuccess', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthLoginSuccess(AuthenticatedUser(
            id: '1',
            name: 'Test',
            email: 'test@example.com',
            accessToken: 'mock_token',
          )),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest(const LoginPage()));
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.go(Routes.home)).called(1);
      expect(find.text('Logged in successfully'), findsOneWidget);
    });

    testWidgets('navigates to signup page when signup button pressed', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(const LoginPage()));
      await tester.pump();
      final signUpFinder = find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('Sign Up'),
        description: 'RichText containing "Sign Up"',
      );
      expect(signUpFinder, findsOneWidget, reason: 'Sign Up RichText not found');
      await tester.ensureVisible(signUpFinder);
      await tester.pumpAndSettle();
      await tester.tap(signUpFinder);
      await tester.pump();

      verify(() => mockGoRouter.go(Routes.register)).called(1);
    });
  });

  group('SignUpPage', () {
    // testWidgets('displays signup page UI elements', (WidgetTester tester) async {
    //   when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
    //   when(() => mockAuthBloc.stream).thenAnswer(
    //     (_) => Stream.value(const AuthInitial()),
    //   );

    //   await tester.pumpWidget(createWidgetUnderTest(const SignUpPage()));
    //   await tester.pump();
    //   debugDumpApp(); // Debug widget tree

    //   expect(find.text('Create your account'), findsOneWidget);
    //   expect(find.text('Name'), findsOneWidget);
    //   expect(find.text('Email'), findsOneWidget);
    //   expect(find.text('Password'), findsOneWidget);
    //   expect(find.text('Confirm password'), findsOneWidget);
    //   expect(find.text('SIGN UP'), findsOneWidget);
    //   expect(
    //     find.byWidgetPredicate(
    //       (widget) => widget is RichText && widget.text.toPlainText().contains('Sign In'),
    //       description: 'RichText containing "Sign In"',
    //     ),
    //     findsOneWidget,
    //   );
    //   expect(find.byType(Checkbox), findsOneWidget);
    // });

    testWidgets('triggers signup when form is valid and terms accepted', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SignUpPage()));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget, reason: 'Checkbox not found');
      await tester.ensureVisible(checkboxFinder);
      await tester.pumpAndSettle();
      await tester.tap(checkboxFinder);
      final signUpFinder = find.text('SIGN UP');
      expect(signUpFinder, findsOneWidget, reason: 'SIGN UP button not found');
      await tester.ensureVisible(signUpFinder);
      await tester.pumpAndSettle();
      await tester.tap(signUpFinder);
      await tester.pump();

      verify(() => mockAuthBloc.add(
            const AuthRegisterRequested('Test User', 'test@example.com', 'password123'),
          )).called(1);
    });

    testWidgets('shows error when terms not accepted', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SignUpPage()));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      final signUpFinder = find.text('SIGN UP');
      expect(signUpFinder, findsOneWidget, reason: 'SIGN UP button not found');
      await tester.ensureVisible(signUpFinder);
      await tester.pumpAndSettle();
      await tester.tap(signUpFinder);
      await tester.pump();

      expect(find.text('Please accept the terms & policy'), findsOneWidget);
    });

    testWidgets('shows error snackbar on AuthRegisterFailure', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthRegisterFailure('Registration failed'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SignUpPage()));
      await tester.pumpAndSettle();

      expect(find.text('Registration failed'), findsOneWidget);
    });

    testWidgets('navigates to login on AuthRegisterSuccess', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthRegisterSuccess(AuthenticatedUser(
            id: '1',
            name: 'Test',
            email: 'test@example.com',
            accessToken: 'mock_token',
          )),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SignUpPage()));
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.go(Routes.login)).called(1);
      expect(find.text('Registered successfully'), findsOneWidget);
    });

    testWidgets('navigates to login when back button or sign in pressed', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(const SignUpPage()));
      await tester.pump();

      // Test back button
      final backButtonFinder = find.byIcon(Icons.arrow_back_ios);
      expect(backButtonFinder, findsOneWidget, reason: 'Back button not found');
      await tester.tap(backButtonFinder);
      await tester.pump();
      verify(() => mockGoRouter.go(Routes.login)).called(1);

      // Test sign in button
      final signInFinder = find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('Sign In'),
        description: 'RichText containing "Sign In"',
      );
      expect(signInFinder, findsOneWidget, reason: 'Sign In RichText not found');
      await tester.ensureVisible(signInFinder);
      await tester.pumpAndSettle();
      await tester.tap(signInFinder);
      await tester.pump();
      verify(() => mockGoRouter.go(Routes.login)).called(1);
    });
  });
}