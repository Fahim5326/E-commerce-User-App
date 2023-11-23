import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user/models/product_model.dart';
import 'package:ecom_user/providers/product_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return InkWell(
      child: Card(
        color: Colors.amber,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CachedNetworkImage(
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
                  if(product.discount > 0) Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Colors.black45,
                    child: Text('${product.discount}% off',
                      style: const TextStyle(fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(product.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18),),
            ),
            if(product.discount > 0) RichText(
                text: TextSpan(
                  text: '$currencySymbol${product.price}  ',
                  style: TextStyle(color: Colors.grey, fontSize: 20,decoration: TextDecoration.lineThrough),
                  children: [
                    TextSpan(
                      text: '$currencySymbol${provider.priceAfterDiscount(product.price, product.discount)}',
                      style: const TextStyle(fontSize: 25, color: Colors.black, decoration: TextDecoration.none)
                    )
                  ]
                ),
            ),
            if(product.discount == 0) Text(
              '$currencySymbol${product.price}',
              style: const TextStyle(fontSize: 25, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${product.avgRating}'),
                RatingBar.builder(
                    onRatingUpdate: (value) {

                     },
                     ignoreGestures: true,
                     itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber,),
                     itemCount: 5,
                     allowHalfRating: true,
                     initialRating: product.avgRating,
                     itemSize: 25,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
