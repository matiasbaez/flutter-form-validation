
import 'package:flutter/material.dart';

import 'package:products/models/models.dart';

class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  ProductFormProvider(
    this.product
  );

  updateAvailability( bool value ) {
    product.available = value;
    notifyListeners();
  }

  bool isValidForm() => formKey.currentState?.validate() ?? false;

}
