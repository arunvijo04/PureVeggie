import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controller/login_controller.dart';
import 'package:food_app/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/user/user.dart';

class PurchaseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  late Razorpay _razorpay;

  @override
  void onInit() {
    super.onInit();
    orderCollection = firestore.collection('orders');
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    var options = {
      'key': 'rzp_test_OMZpO9pffydca4',
      'amount': price * 100, // Ensure amount is in paise
      'name': item,
      'description': description,
    };

    try {
      _razorpay.open(options);
      print('Razorpay instance initialized');
    } catch (e) {
      print('Error in opening Razorpay: $e');
      Get.snackbar('Error', 'Could not open payment gateway', colorText: Colors.red);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success: ${response.paymentId}');
    orderSuccess(transactionId: response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    Get.snackbar('Payment Error', 'Error: ${response.message}', colorText: Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    Get.snackbar('External Wallet', 'Wallet: ${response.walletName}', colorText: Colors.blue);
  }

  Future<void> orderSuccess({required String? transactionId}) async {
    User? loginUser = Get.find<LoginController>().loginUser;
    try {
      if (transactionId != null) {
        DocumentReference docRef = await orderCollection.add({
          'customer': loginUser?.name ?? '',
          'phone': loginUser?.number ?? '',
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionId': transactionId,
          'dateTime': DateTime.now().toString(),
        });
        print('Order created Successfully');
        Get.snackbar('Success', 'Order Created Successfully', colorText: Colors.green);
        showOrderSuccessDialog(docRef.id);
      } else {
        Get.snackbar('Error', 'Order can not be placed', colorText: Colors.red);
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to create order', colorText: Colors.red);
    }
  }

  void showOrderSuccessDialog(String orderId) {
    Get.defaultDialog(
      title: 'Order Success',
      content: Text('Your order id is $orderId'),
      confirm: ElevatedButton(
        onPressed: () {
          Get.off(const HomePage());
        },
        child: const Text('Close'),
      ),
    );
  }
}
