import 'package:flutter/material.dart';
import 'package:food_app/controller/home_controller.dart';
import 'package:food_app/pages/login_page.dart';
import 'package:food_app/pages/product_description_page.dart';
import 'package:food_app/widgets/dropdown_button.dart';
import 'package:food_app/widgets/multi_select_drop_down.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(), // Ensure the controller is initialized
      builder: (ctrl) {
        return RefreshIndicator(
          onRefresh: () async {
            await ctrl.fetchProducts();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'PureVeggie',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GetStorage box = GetStorage();
                    box.erase();
                    Get.offAll(LoginPage());
                  },
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Chip(
                            label: Text(
                              ctrl.productCategories[index].name ?? 'Error',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: DropDownBtn(
                        items: ['Low to High', 'High to Low'],
                        selectedItemText: 'Sort',
                        onSelected: (selected) {
                         ctrl.sortByPrice(ascending: selected=='Low to High'?true:false);
                        },
                      ),
                    ),
                    Flexible(
                      child: MultiSelectDropDown(
                        items: ['Leafy Green', 'Nightshades', 'Cruciferous','Alliums'],
                        onSelectionChanged: (selectedItems) {
                          ctrl.filterByBrand(selectedItems);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: ctrl.productShowInUi.length, // Ensure itemCount is set
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productShowInUi[index].name ?? 'No name',
                        imageUrl: ctrl.productShowInUi[index].image ?? 'No image',
                        price: ctrl.productShowInUi[index].price ?? 00,
                        offerTag: '20% off',
                        onTap: () {
                          Get.to(ProductDescriptionPage(),arguments: {'data':ctrl.productShowInUi[index]});
                        },
                      );
                    },
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
