import 'dart:async';
import 'dart:developer';

import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/services/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends BaseRepository {
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserModel> signUp(
      {required String fullName,
      required String userName,
      required String email,
      required String phoneNumber,
      required String password}) async {
    try {
      final formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), "".trim());

      final emailExists = await checkEmailExists(email);
      if (emailExists) {
        throw "An account with the same email already exists";
      }
      final phoneNumberExists = await checkPhoneExists(formattedPhoneNumber);
      if (phoneNumberExists) {
        throw "An account with the same phone already exists";
      }


      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user == null) {
        throw "Failed to create user";
      }

      //create user model and save the user in the db firestore

      final user = UserModel(
          uid: userCredential.user!.uid,
          userName: userName,
          fullName: fullName,
          email: email,
          phoneNumber: formattedPhoneNumber
      );

      await saveUserData(user);

      return user;
    } catch (e) {
      log("error signUp ==> $e");
      rethrow;
    }
  }

  Future<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user == null) {
        throw "User not found";
      }
      final userData = await getUserData(userCredential.user!.uid);

      return userData;
    } catch (e) {
      log("error signUp ==> $e");
      rethrow;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      fireStore.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      throw "Failed to save user data";
    }
  }

  Future<void> signOut()async{
      await auth.signOut();
  }

  Future<bool> checkEmailExists(String email)async{
    try{
      final method = await auth.fetchSignInMethodsForEmail(email);
      return method.isNotEmpty;
    }catch(e){
      log("Error checking email==> $e");
      return false;
    }
  }

  Future<bool> checkPhoneExists(String phoneNumber) async {
    try {
      final formattedPhoneNumber =
      phoneNumber.replaceAll(RegExp(r'\s+'), "".trim());
      final querySnapshot = await fireStore.collection("users").where("phoneNumber", isEqualTo: formattedPhoneNumber).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await fireStore.collection("users").doc(uid).get();
      if (!doc.exists) {
        throw "User data not found";
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw "Failed to save user data";
    }
  }
}
