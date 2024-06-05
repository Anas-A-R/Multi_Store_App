import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/utilities/categ_list.dart';
import 'package:customer_multi_store_app/widgets/category_widgets.dart';

class HomeGardenCategory extends StatelessWidget {
  const HomeGardenCategory({super.key});

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
                  const CategoryHeaderLabel(headerLabel: 'HomeGarden'),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: deviceHeight * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children:
                          List.generate(homeandgarden.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'homeandgarden',
                          subCategoryName: homeandgarden[index + 1],
                          assetName: 'images/homegarden/home$index.jpg',
                          subCategoryLabel: homeandgarden[index + 1],
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
              mainCategoryName: 'homegarden',
            ),
          )
        ],
      ),
    );
  }
}
