import 'dart:io';

import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/models/rating_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) =>
          CategoryModel.fromJson(snapshot.docs[index].data()
          ));
      notifyListeners();
    });
  }


  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromJson(snapshot.docs[index].data()
          ));
      notifyListeners();
    });
  }

  ProductModel getProductById(String id) {
    return productList.firstWhere((element) => element.id == id);
  }

  Future<void> updateProductField(String id, String field, dynamic value) async {

  }

  Future<void> addRating(String pid, double value) {
    final rating = RatingModel(userId: AuthService.currentUser!.uid,
        rating: value);
    return DbHelper.addRating(rating, pid);
  }

  num priceAfterDiscount(num price,int discount) {
    return price - (price * discount ~/ 100);

  }


  Future<String> uploadImage(String path) async {
    final imageName = 'Image_${DateTime.now().millisecondsSinceEpoch}';
    final photoRef = FirebaseStorage.instance.ref()
    .child('Picture/$imageName');
    final uploadTask = photoRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}