import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user/models/app_user.dart';
import 'package:ecom_user/models/cart_model.dart';

import 'models/rating_model.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionUsers = 'Users';
  static const String collectionCart = 'Cart';
  static const String collectionRating = 'Ratings';

 static Future<void> addUser(AppUser user) {
    return _db.collection(collectionUsers)
        .doc(user.id)
        .set(user.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory)
          .orderBy('name',)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct)
          .where('available', isEqualTo: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserCartItems(String uid) =>
      _db.collection(collectionUsers)
      .doc(uid)
      .collection(collectionCart)
          .snapshots();

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db.collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toJson());
  }

  static Future<void> removeFromCart(String uid,String pid) {
    return _db.collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .delete();
  }

  static Future<void> updateCartQuantity(String uid, CartModel cartModel) {
    return _db.collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .update(cartModel.toJson());
  }

  static Future<void> addRating(RatingModel ratingModel, String pid) {
    return _db.collection(collectionProduct)
        .doc(pid)
        .collection(collectionRating)
        .doc(ratingModel.userId)
        .set(ratingModel.toJson());
  }
}