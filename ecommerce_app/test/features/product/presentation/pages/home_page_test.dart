import 'package:ecommerce_app/core/presentation/routes/routes.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/pages/home_page.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}
class MockProductBloc extends Mock implements ProductBlocBloc {}
class MockGoRouter extends Mock implements GoRouter {}
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockProductBloc mockProductBloc;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
    registerFallbackValue(const Product(id: '', name: '', description: '', price: 0, imageURL: ''));
  });

  setUp(() async {
    mockAuthBloc = MockAuthBloc();
    mockProductBloc = MockProductBloc();
    mockGoRouter = MockGoRouter();
    when(() => mockGoRouter.go(any())).thenAnswer((_) async {});
    when(() => mockGoRouter.push(any(), extra: any(named: 'extra'))).thenAnswer((_) async {});
    // Increase viewport size for tall content
    // await tester.binding.setSurfaceSize(const Size(800, 1200));
  });

  Widget createWidgetUnderTest() {
    return InheritedGoRouter(
      goRouter: mockGoRouter,
      child: MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            BlocProvider<ProductBlocBloc>.value(value: mockProductBloc),
          ],
          child: const HomePage(),
        ),
        navigatorKey: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(body: Container()),
        ),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('displays UI elements', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('July 21, 2025'), findsOneWidget);
      expect(find.textContaining('Hello, Yohannes'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      expect(find.text('Available Products'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays loading state', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(const LoadingState());
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const LoadingState()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error state', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(const ErrorState(message: 'Failed to load products'));
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ErrorState(message: 'Failed to load products')));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Failed to load products'), findsOneWidget);
    });

    testWidgets('displays empty product list', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(const LoadedAllProductsState([]));
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const LoadedAllProductsState([])));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('No products added yet'), findsOneWidget);
    });

    testWidgets('displays product list', (WidgetTester tester) async {
      final products = [
        const Product(id: '1', name: 'Product 1', description: 'Desc 1', price: 10.0, imageURL: 'http://example.com/1.jpg'),
        const Product(id: '2', name: 'Product 2', description: 'Desc 2', price: 20.0, imageURL: 'http://example.com/2.jpg'),
      ];
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(LoadedAllProductsState(products));
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(LoadedAllProductsState(products)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Desc 1'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('Desc 2'), findsOneWidget);
      expect(find.text('\$20.00'), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(2));
    });

    testWidgets('navigates to chats when chat button is tapped', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.chat_bubble_outline));
      await tester.pump();

      verify(() => mockGoRouter.push(Routes.chats)).called(1);
    });

    testWidgets('triggers logout when logout button is tapped', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout_rounded));
      await tester.pump();

      verify(() => mockAuthBloc.add( AuthLogoutRequested())).called(1);
    });

    testWidgets('navigates to login on AuthLogoutSuccess', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthLogoutSuccess(),
        ]),
      );
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.go(Routes.login)).called(1);
    });

    testWidgets('shows error snackbar on AuthLogoutFailure', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthLogoutFailure('Logout failed'),
        ]),
      );
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Logout failed'), findsOneWidget);
    });

    testWidgets('navigates to add product when FAB is tapped', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      verify(() => mockGoRouter.push(Routes.addProduct)).called(1);
    });


    testWidgets('navigates to product details when product card is tapped', (WidgetTester tester) async {
      final products = [
        const Product(id: '1', name: 'Product 1', description: 'Desc 1', price: 10.0, imageURL: 'http://example.com/1.jpg'),
      ];
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
      when(() => mockProductBloc.state).thenReturn(LoadedAllProductsState(products));
      when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(LoadedAllProductsState(products)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byType(ProductCard).first);
      await tester.pump();

      verify(() => mockGoRouter.push(Routes.productDetails, extra: products[0])).called(1);
    });
  });
}