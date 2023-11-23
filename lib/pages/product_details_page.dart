import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/providers/product_provider.dart';
import 'package:ecom_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/details';


  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final product = productProvider.getProductById(id);
    double rating = 1.0;
    return  Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 300,
            fadeInDuration: const Duration(seconds: 2),
            fadeInCurve: Curves.bounceInOut,
            imageUrl: product.imageUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Center(
              child: const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Consumer<CartProvider>(
              builder: (context, provider, child) {
                final isInCart = provider.isInCart(product.id!);
                return ElevatedButton.icon(
                  onPressed: () async{
                    EasyLoading.show(status: 'Please wait');
                  if(isInCart) {
                    await provider.removeFromCart(product.id!);
                  } else {
                   await provider.addtoCart(product, productProvider.priceAfterDiscount(
                        product.price, product.discount));
                   showMsg(context, 'Added to Cart');
                  }
                  EasyLoading.dismiss();
                  },
                  icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.shopping_cart),
                  label: Text(isInCart ? 'REMOVE FROM CART' : 'ADD TO CART'),
                );
              },
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    onRatingUpdate: (value) {
                     rating = value;
                    },
                    ignoreGestures: false,
                    itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber,),
                    itemCount: 5,
                    allowHalfRating: true,
                    initialRating: 1.0,
                    itemSize: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show(status: 'Please Wait');
                     await productProvider.addRating(id, rating) ;
                     EasyLoading.dismiss();
                     showMsg(context, 'Thanks for your rating');
                      },
                      child: const Text('SUBMIT'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
