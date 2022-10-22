
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:products/models/product.dart';

class ProductService extends ChangeNotifier {

  final String _baseUrl = 'perfect-crawler-150816-default-rtdb.firebaseio.com';
  final List<Product> _products = [];

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

}
