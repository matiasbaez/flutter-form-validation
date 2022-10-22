
import 'package:flutter/material.dart';
import 'package:products/models/models.dart';

import 'package:products/services/services.dart';
import 'package:products/screens/screens.dart';
import 'package:products/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  static String routerName = 'Home';

  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductService>(context);
    final products = productService.products;

    if (productService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: ( _, int index ) => GestureDetector(
          child: ProductCard( product: products[index] ),
          onTap: () {
            productService.selectedProduct = products[index].copy();
            Navigator.pushNamed(context, ProductScreen.routerName);
          },
        ),  
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productService.selectedProduct = Product(available: false, name: '', price: 0);
            Navigator.pushNamed(context, ProductScreen.routerName);
        },
        child: const Icon( Icons.add )
      ),
    );
  }

}
