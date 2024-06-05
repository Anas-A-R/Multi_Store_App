import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/search.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) => const SearchScreen(),));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Colors.yellow)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child:  Icon(Icons.search),
                ),
                Text(
                  'What you are looking for?',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
            Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8),
                
              ),
              child:   const Center(
                child: Text(
                    'Search',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}