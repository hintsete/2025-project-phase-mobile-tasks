import 'dart:io';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/pages/add_update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockProductBloc extends Mock implements ProductBlocBloc {}
class MockImagePicker extends Mock implements ImagePicker {}
class MockFile extends Mock implements File {}

void main() {
  late MockProductBloc mockProductBloc;
  late MockImagePicker mockImagePicker;
  late MockFile mockFile;

  setUp(() async {
    mockProductBloc = MockProductBloc();
    mockImagePicker = MockImagePicker();
    mockFile = MockFile();
    when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
    when(() => mockProductBloc.stream).thenAnswer((_) => Stream.value(const ProductBlocInitial()));
 
  });

  setUpAll(() {
    // Register fallback for File to ensure mocktail can handle it
    registerFallbackValue(MockFile());
  });

  Widget createWidgetUnderTest({Product? product}) {
    return MaterialApp(
      home: RepositoryProvider<ImagePicker>.value(
        value: mockImagePicker,
        child: BlocProvider<ProductBlocBloc>.value(
          value: mockProductBloc,
          child: AddUpdateProductPage(product: product),
        ),
      ),
    );
  }

  group('AddUpdateProductPage', () {
    testWidgets('displays UI elements for add product', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Add Product'), findsNWidgets(2)); // AppBar and button
      expect(find.text('Product Name'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Tap to add image'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays UI elements for edit product', (WidgetTester tester) async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        imageURL: 'http://example.com/image.jpg',
      );
      await tester.pumpWidget(createWidgetUnderTest(product: product));
      await tester.pump();

      expect(find.text('Edit Product'), findsOneWidget);
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('10.0'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // Image.network
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Update Product'), findsOneWidget);
    });

    

  

    testWidgets('triggers CreateProductWithImageEvent for new product with image', (WidgetTester tester) async {
      when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('test.jpg'));
      when(() => mockFile.path).thenReturn('test.jpg');

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text('Tap to add image'));
      await tester.pump();
      verify(() => mockImagePicker.pickImage(source: ImageSource.gallery)).called(1);

      await tester.enterText(find.byType(TextFormField).at(0), 'Test Product');
      await tester.enterText(find.byType(TextFormField).at(1), '10.0');
      await tester.enterText(find.byType(TextFormField).at(2), 'Test Description');
      final buttonFinder = find.byType(ElevatedButton);
      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle();
      await tester.tap(buttonFinder);
      await tester.pump();

      verify(() => mockProductBloc.add(
            CreateProductWithImageEvent(
              name: 'Test Product',
              description: 'Test Description',
              price: 10.0,
              imageFile: any(named: 'imageFile'),
            ),
          )).called(1);
    });

    testWidgets('triggers UpdateProductEvent for existing product', (WidgetTester tester) async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        imageURL: 'http://example.com/image.jpg',
      );
      await tester.pumpWidget(createWidgetUnderTest(product: product));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Updated Product');
      await tester.enterText(find.byType(TextFormField).at(1), '20.0');
      await tester.enterText(find.byType(TextFormField).at(2), 'Updated Description');
      final buttonFinder = find.byType(ElevatedButton);
      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle();
      await tester.tap(buttonFinder);
      await tester.pump();

      verify(() => mockProductBloc.add(
            UpdateProductEvent(
              Product(
                id: '1',
                name: 'Updated Product',
                description: 'Updated Description',
                price: 20.0,
                imageURL: 'http://example.com/image.jpg',
              ),
            ),
          )).called(1);
    });

    testWidgets('shows error snackbar on ErrorState', (WidgetTester tester) async {
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const ProductBlocInitial(),
          const ErrorState(message: 'Failed to save product'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Failed to save product'), findsOneWidget);
    });

    testWidgets('navigates back on SuccessState', (WidgetTester tester) async {
      when(() => mockProductBloc.state).thenReturn(const ProductBlocInitial());
      when(() => mockProductBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const ProductBlocInitial(),
          const SuccessState(message: 'Product saved successfully'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(AddUpdateProductPage), findsNothing);
    });
  });
}