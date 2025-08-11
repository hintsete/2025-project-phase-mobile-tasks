import 'package:ecommerce_app/core/presentation/routes/app_routes.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/header_section.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBlocBloc>().add(LoadAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"), //added the logout button
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              context.push(Routes.chats); // navigate to chat list page
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.addProduct);
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthLogoutSuccess || current is AuthLogoutFailure,
        listener: (context, state) {
          if (state is AuthLogoutSuccess) {
            context.go(Routes.login);
          } else if (state is AuthLogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              TitleBar(
                onSearchTap: () {
                  context.read<ProductBlocBloc>().add(LoadAllProductsEvent());
                  context.push(Routes.search);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<ProductBlocBloc, ProductBlocState>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ErrorState) {
                      return Center(child: Text(state.message));
                    } else if (state is LoadedAllProductsState) {
                      final products = state.products;
                      if (products.isEmpty) {
                        return const Center(
                          child: Text("No products added yet"),
                        );
                      }
                      return ListView.builder(
                        itemCount: products.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, idx) {
                          final product = products[idx];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                Routes.productDetails,
                                extra: product,
                              );
                            },
                            child: ProductCard(product: product),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}