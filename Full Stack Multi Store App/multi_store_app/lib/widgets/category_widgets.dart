import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/subcategory_products.dart';

class SliderBar extends StatelessWidget {
  final String mainCategoryName;
  const SliderBar({
    super.key,
    required this.mainCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: deviceHeight * 0.8,
      width: deviceWidth * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                mainCategoryName == 'beauty'
                    ? const Text('')
                    : const Text(' << ', style: style),
                Text(mainCategoryName.toUpperCase(), style: style),
                mainCategoryName == 'men'
                    ? const Text('')
                    : const Text(' >> ', style: style),
              ],
            ),
          ), //rotate 270 degree
        ),
      ),
    );
  }
}

const style =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.brown);

class SubCategoryModel extends StatelessWidget {
  final String mainCategoryName;
  final String subCategoryName;
  final String assetName;
  final String subCategoryLabel;
  const SubCategoryModel({
    super.key,
    required this.mainCategoryName,
    required this.subCategoryName,
    required this.assetName,
    required this.subCategoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategoryProducts(
                mainCategoryName: mainCategoryName,
                subCategoryName: subCategoryName,
              ),
            ));
      },
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Image(image: AssetImage(assetName)),
          ),
          Text(subCategoryLabel, style: const TextStyle(fontSize: 11))
        ],
      ),
    );
  }
}

class CategoryHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategoryHeaderLabel({
    super.key,
    required this.headerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        headerLabel,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
