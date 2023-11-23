import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user/models/cart_model.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemView extends StatelessWidget {
  final CartModel cartModel;

  const CartItemView({super.key, required this.cartModel});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CachedNetworkImage(
              width: 50,
              height: 50,
              fadeInDuration: const Duration(seconds: 2),
              fadeInCurve: Curves.bounceInOut,
              imageUrl: cartModel.imageUrl,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Center(
                child: const Icon(Icons.error),
              ),
            ),
            title: Text(cartModel.productName),
            trailing: Text('$currencySymbol${cartModel.price}', style: const TextStyle(fontSize: 15.0),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        cartProvider.decreaseQuantity(cartModel);
                      },
                      icon: const Icon(Icons.remove_circle, size: 30,),
                  ),
                  Text(cartModel.quantity.toString(),
                  style: const TextStyle(fontSize: 18.0),),
                  IconButton(
                    onPressed: () {
                      cartProvider.increaseQuantity(cartModel);
                    },
                    icon: const Icon(Icons.add_circle, size: 30,),
                  ),
                ],
              ),
              //const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: Text('$currencySymbol${cartProvider.priceWithQuantity(cartModel.price, cartModel.quantity)}',
                    style: const TextStyle(fontSize: 18.0),
                ),
              ),
              IconButton(
                  onPressed: () {
                    cartProvider.removeFromCart(cartModel.productId);
                  },
                  icon: const Icon(Icons.delete),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
