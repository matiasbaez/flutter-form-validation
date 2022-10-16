
import 'package:flutter/material.dart';

class CardContainerWidget extends StatelessWidget {

  final Widget child;

  const CardContainerWidget({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 30 ),
      child: Container(
        padding: const EdgeInsets.all( 20 ),
        width: double.infinity,
        decoration: _createBoxShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _createBoxShape() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 15,
          offset: Offset(0, 5)
        )
      ]
    );
  }

}
