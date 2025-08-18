import 'package:ecommerce_app/core/presentation/routes/routes.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/pages/details_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockProductBloc extends Mock implements ProductBlocBloc {}
class MockGoRouter extends Mock implements GoRouter {}
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockProductBloc mockProductBloc;
  late MockGoRouter mockGoRouter;
  late Product testProduct;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
    registerFallbackValue(const Product(id: '', name: '', description: '', price: 0, imageURL: ''));
  });

  setUp(() async {
    mockProductBloc = MockProductBloc();
    mockGoRouter = MockGoRouter();
    testProduct = const Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 10.0,
      imageURL: 'http://example.com/image.jpg',
    );
    when(() => mockGoRouter.push(any(), extra: any(named: 'extra'))).thenAnswer((_) async {});
    when(() => mockGoRouter.pop()).thenAnswer((_) => {});
    when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
    when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));
  
  });

  Widget createWidgetUnderTest() {
    return InheritedGoRouter(
      goRouter: mockGoRouter,
      child: MaterialApp(
        home: BlocProvider<ProductBlocBloc>.value(
          value: mockProductBloc,
          child: ProductDetailsPage(product: testProduct),
        ),
      ),
    );
  }

  group('ProductDetailsPage', () {
    testWidgets('displays UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Product Details'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Delete Product'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('navigates to update product when edit button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      verify(() => mockGoRouter.push(Routes.updateProduct, extra: testProduct)).called(1);
    });

    testWidgets('triggers DeleteProductEvent when delete button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text('Delete Product'));
      await tester.pump();

      verify(() => mockProductBloc.add( DeleteProductEvent('1'))).called(1);
    });

    testWidgets('shows error snackbar on ErrorState', (WidgetTester tester) async {
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const ProductBlocInitial(),
          const ErrorState(message: 'Failed to delete product'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Failed to delete product'), findsOneWidget);
    });

    testWidgets('navigates back on SuccessState', (WidgetTester tester) async {
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const ProductBlocInitial(),
          const SuccessState(message: 'Product deleted successfully'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.pop()).called(1);
    });
  });
}