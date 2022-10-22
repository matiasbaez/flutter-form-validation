
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:products/models/product.dart';

class ProductService extends ChangeNotifier {

  final String _baseUrl = 'perfect-crawler-150816-default-rtdb.firebaseio.com';
  final List<Product> _products = [];
  late Product selectedProduct;

  bool isLoading = false;

  ProductService() {
    _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.get( url );

    final Map<String, dynamic> productsMap = json.decode( response.body );

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap( value );
      tempProduct.id = key;

      _products.add( tempProduct );
    });

    isLoading = false;
    notifyListeners();

    return _products;
  }

  get products {
    return _products;
  }

  Future saveOrCreateProduct(Product product) async {
    isLoading = true;
    notifyListeners();

    if ( product.id == null ) {

    } else {
      await updateProduct(product);
    }


    isLoading = false;
    notifyListeners();
  }

  Future<String> updateProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products/${ product.id }.json');
    final response = await http.put( url, body: product.toJson() );
    /// final decodedData = response.body;

    final index = _products.indexWhere((element) => element.id == product.id);
    if ( index != -1 ) _products[index] = product;

    return product.id!;
  }

}
