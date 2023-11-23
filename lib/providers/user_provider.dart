import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user/db_helper.dart';
import 'package:ecom_user/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
 Future<void> addNewUser(User user) {
    final appUser = AppUser(
        id: user.uid,
        email: user.email!,
        userCreationTime: Timestamp.fromDate(user.metadata.creationTime!),
    );
    return DbHelper.addUser(appUser);
  }

}