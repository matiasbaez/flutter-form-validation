
import 'package:flutter/material.dart';

import 'package:products/models/models.dart';

class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ProductFormProvider(
    this.product
  );

  updateAvailability( bool value ) {
    product.available = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() => formKey.currentState?.validate() ?? false;

}
