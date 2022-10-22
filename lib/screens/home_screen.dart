
import 'package:flutter/material.dart';

import 'package:products/screens/screens.dart';
import 'package:products/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  static String routerName = 'Home';

  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: ( _, int index ) => GestureDetector(
          child: const ProductCard(),
          onTap: () => Navigator.pushNamed(context, ProductScreen.routerName),
        ),  
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon( Icons.add )
      ),
    );
  }

}
