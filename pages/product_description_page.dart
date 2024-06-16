import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controller/purchase_controller.dart';
import 'package:get/get.dart';

import '../models/product/product.dart';

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve product data from arguments passed via Get.arguments
    final product = Get.arguments['data'] as Product? ?? Product(); // Use a default or handle null case appropriately

    return GetBuilder<PurchaseController>(
      init: PurchaseController(), // Initialize your controller if needed
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Product Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 200),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.name ?? '',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.description ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Rs ${product.price ?? 0}',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: ctrl.addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Enter your billing address',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      ctrl.showOrderSuccessDialog('4736437'); // Pass the correct data type
                      ctrl.submitOrder(
                        price: product.price ?? 0,
                        item: product.name ?? '',
                        description: product.description ?? '',
                      );
                    },
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
