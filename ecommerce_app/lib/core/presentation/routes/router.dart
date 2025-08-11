import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_chat_messages.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/send_message.dart';
import 'package:ecommerce_app/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:ecommerce_app/features/chat/presentation/bloc/message/message_bloc.dart';
import 'package:ecommerce_app/features/chat/presentation/pages/chat_detail.dart';
import 'package:ecommerce_app/features/chat/presentation/pages/chats_page.dart';

import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/presentation/pages/add_update_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/details_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/home_page.dart';
import 'package:ecommerce_app/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    GoRoute(
      path: Routes.chats,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<ChatsBloc>()..add(ChatsLoadRequested()),
        child: const ChatsPage(),
      ),
    ),
    GoRoute(
      path: Routes.chatDetail,
      builder: (context, state) {
        final chat = state.extra as Chat;
        return BlocProvider(
          create: (context) => MessageBloc(
            getChatMessages: sl<GetChatMessages>(),
            sendMessage: sl<SendMessage>(),
          )..add(MessageSocketConnectionRequested(chat)),
          child: ChatPage(chat: chat),
        );
      },
    ),
    // GoRoute(
    //   path: Routes.chats,
    //   builder: (context, state) {
    //     // Assuming you pass currentUserId as extra
    //     final currentUserId = state.extra as String;
    //     return ChatListPage(currentUserId: currentUserId);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.chatDetail,
    //   builder: (context, state) {
    //     // Extract both chat and currentUserId from extra
    //     final args = state.extra as Map<String, dynamic>;
    //     return ChatPage(
    //       chat: args['chat'] as Chat,
    //       currentUserId: args['currentUserId'] as String,
    //     );
    //   },
    // ),
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