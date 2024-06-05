import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/utilities/categ_list.dart';
import 'package:customer_multi_store_app/widgets/category_widgets.dart';

class ElectronicsCategory extends StatelessWidget {
  const ElectronicsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: deviceHeight * 0.8,
              width: deviceWidth * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategoryHeaderLabel(headerLabel: 'Electronics'),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: deviceHeight * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children: List.generate(electronics.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'electronics',
                          subCategoryName: electronics[index + 1],
                          assetName: 'images/electronics/electronics$index.jpg',
                          subCategoryLabel: electronics[index + 1],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              mainCategoryName: 'electronics',
            ),
          )
        ],
      ),
    );
  }
}
