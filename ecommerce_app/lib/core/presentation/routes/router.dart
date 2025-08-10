import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/presentation/pages/add_update_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/details_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';
// import '../../../features/auth/presentation/pages/login.dart';
// import '../../../features/auth/presentation/pages/register.dart';
import '../../../features/auth/presentation/pages/splash_screen.dart';

// import '../../../features/product/presentation/pages/pages.dart';

import 'app_routes.dart';

final router = GoRouter(
  routes: <RouteBase>[
    //
    GoRoute(
      path: Routes.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),

    //
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),

    //
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path:Routes.home,
      builder: (context,state)=> const HomePage(),
    ),
    
    GoRoute(
      path: Routes.productDetails,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailsPage(product: product);
      },
    ),
    GoRoute(
      path: Routes.addProduct,
      builder: (context, state) => const AddUpdateProductPage(),
    ),
    GoRoute(
      path: Routes.updateProduct,
      builder: (context, state) {
        final product = state.extra as Product;
        return AddUpdateProductPage(product: product);
      },
),
    // GoRoute(
    //   path: Routes.addProduct,
    //   builder: (context, state) => const AddUpdatePage(),
    // ),
    // GoRoute(
    //   path: Routes.updateProduct,
    //   builder: (context, state) {
    //     final product = state.extra as Product;
    //     return AddUpdatePage(product: product);
    //   },
    // ),

   

    //
    // GoRoute(
    //   path: Routes.home,
    //   builder: (context, state) => const HomePage(),
    // ),

    // //
    // GoRoute(
    //   path: Routes.productDetail,
    //   builder: (context, state) {
    //     final product = state.extra as Product;
    //     return ProductDetailPage(product: product);
    //   },
    // ),

    // //
    // GoRoute(
    //   path: Routes.addProduct,
    //   builder: (context, state) => const AddProductPage(),
    // ),

    // //
    // GoRoute(
    //   path: Routes.updateProduct,
    //   builder: (context, state) {
    //     final product = state.extra as Product;
    //     return UpdateProductPage(product: product);
    //   },
    // ),
  ],
);