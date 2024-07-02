import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_models.dart';

class UserController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  var usersList = <User>[].obs; // Observable list to store users

  void saveDataToFirestore() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    User newUser = User(
      id: '', // This will be set by Firestore
      name: name,
      email: email,
      phone: phone,
      timestamp: Timestamp.now(),
    );

    FirebaseFirestore.instance.collection('users').add(newUser.toMap()).then((value) {
      nameController.clear();
      emailController.clear();
      phoneController.clear();

      Get.snackbar(
        'Success',
        'Data saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }).catchError((error) {
      Get.snackbar(
        'Error',
        'Failed to save data: $error',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    });
  }

  void fetchDataFromFirestore() async {
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      usersList.value = snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
    });
  }

  void updateUserInFirestore(String userId, String name, String email, String phone) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'name': name,
      'email': email,
      'phone': phone,
    }).then((_) {
      Get.snackbar(
        'Success',
        'User updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }).catchError((error) {
      Get.snackbar(
        'Error',
        'Failed to update user: $error',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

  void deleteUserFromFirestore(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete().then((_) {
      Get.snackbar(
        'Success',
        'User deleted successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }).catchError((error) {
      Get.snackbar(
        'Error',
        'Failed to delete user: $error',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

}
