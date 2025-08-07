import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/header_section.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ProductBlocBloc>().add(LoadAllProductsEvent());
  }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: (){
                    Navigator.pushNamed(context, '/add_update');
                },
                backgroundColor: Colors.blue,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color:Colors.white,size: 28,),
            ),
            body: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const HeaderSection(),
                        TitleBar(
                            onSearchTap:(){
                                context.read<ProductBlocBloc>().add(LoadAllProductsEvent());  // refresh products before search
                                Navigator.pushNamed(context, 'search');
                            },
                        ),
                        const SizedBox(height: 16,),
                        Expanded(child: BlocBuilder<ProductBlocBloc,ProductBlocState>(builder: (context,state){
                            if (state is LoadingState){
                                return const Center(child: CircularProgressIndicator(),);
                            } else if ( state is ErrorState){
                                return Center(child: Text(state.message),);
                            } else if ( state is LoadedAllProductsState){
                                final products=state.products;
                                if (products.isEmpty){
                                    return const Center(child: Text("No products added yet"),);
                                }
                                return ListView.builder(
                                    itemCount: products.length,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemBuilder: (context,idx){
                                        final product=products[idx];
                                        return GestureDetector(
                                            onTap: (){
                                                Navigator.pushNamed(context, 'product_detail', arguments: product);
                                            },
                                            child: ProductCard(product:product),
                                        );
                                    });
                            }
                            return const SizedBox.shrink();
                        }))
                    ],
                )),
                
                
        );
    }
}