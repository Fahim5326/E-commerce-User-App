import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/cart_item_view.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CartList'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) =>
        provider.totalItemsInCart == 0? const Center(child: Text('No item in cart'),) :
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: provider.cartList.length,
                  itemBuilder: (context, index) {
                    final cartModel = provider.cartList[index];
                    return CartItemView(cartModel: cartModel);
                  }),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                  children: [
                    Text('Sub Total : $currencySymbol${provider.getCartSubTotal()}',
                      style: const TextStyle(fontSize: 20.0,),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('CHECKOUT'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
