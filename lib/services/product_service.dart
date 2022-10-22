
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:products/models/product.dart';

class ProductService extends ChangeNotifier {

  final String _baseUrl = 'perfect-crawler-150816-default-rtdb.firebaseio.com';
  final List<Product> _products = [];
  late Product selectedProduct;
  File? selectedFile;

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

  void updateSelectedProductImage( String path ) {
    selectedProduct.picture = path;
    selectedFile = File.fromUri( Uri(path: path ) );

    notifyListeners();
  }

  Future saveOrCreateProduct(Product product) async {
    isLoading = true;
    notifyListeners();

    if ( product.id == null ) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }


    isLoading = false;
    notifyListeners();
  }

  Future<String> createProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.post( url, body: product.toJson() );
    final decodedData = json.decode(response.body);

    product.id = decodedData['name'];
    _products.add(product);

    return product.id!;
  }

  Future<String> updateProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products/${ product.id }.json');
    final response = await http.put( url, body: product.toJson() );
    /// final decodedData = response.body;

    final index = _products.indexWhere((element) => element.id == product.id);
    if ( index != -1 ) _products[index] = product;

    return product.id!;
  }

  Future<String?> uploadImage() async {
    if ( selectedFile == null ) return null;

    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dhqwzfcbz/image/upload?upload_preset=xdfv4b0e');
    final uploadImageRequest = http.MultipartRequest( 'POST', url );
    final file = await http.MultipartFile.fromPath( 'file', selectedFile!.path );
    uploadImageRequest.files.add( file );

    final streamResponse = await uploadImageRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if ( response.statusCode != 200 && response.statusCode != 201 ) return null;

    selectedFile = null;
    final decodedData = json.decode( response.body );

    return decodedData['secure_url'];
  }

}
