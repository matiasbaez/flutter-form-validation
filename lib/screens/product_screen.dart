
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:products/ui/input_decorations.dart';
import 'package:products/providers/providers.dart';
import 'package:products/services/services.dart';
import 'package:products/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {

  static String routerName = 'Product';

  const ProductScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductService>(context);
    final product = productService.selectedProduct;

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(product),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductService productService;

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [

            Stack(
              children: [
                ProductImage( url: productService.selectedProduct.picture ),

                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon( Icons.arrow_back_ios_new, size: 40, color: Colors.white )
                  )
                ),

                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100
                      );

                      if ( pickedFile == null ) return;

                      productService.updateSelectedProductImage( pickedFile.path );
                    },
                    icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.white )
                  )
                ),

              ],
            ),

            const _ProductForm(),

            const SizedBox( height: 100 )

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: productService.isLoading
        ? null
        : () async {
          if ( !productFormProvider.isValidForm() ) return;

          final String? imageUrl = await productService.uploadImage();
          if ( imageUrl != null ) productFormProvider.product.picture = imageUrl;

          await productService.saveOrCreateProduct(productFormProvider.product);
        },
        child: productService.isLoading
          ? const CircularProgressIndicator( color: Colors.white )
          : const Icon( Icons.save_outlined ),
      ),

    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;

    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 10 ),
      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20 ),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox( height: 10 ),

              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length < 1) return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:'
                ),
              ),

              const SizedBox( height: 30 ),

              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) => product.price = (double.tryParse(value) == null) ? 0 : double.parse(value),
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio:'
                ),
              ),

              const SizedBox( height: 30 ),

              SwitchListTile.adaptive(
                value: product.available,
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productFormProvider.updateAvailability
              ),

              const SizedBox( height: 30 ),

            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only( bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25) ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 5),
          blurRadius: 5
        )
      ]
    );
  }
}