import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supplier_multi_store_app/minor_screens/product_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade300,
          title: CupertinoSearchTextField(
            backgroundColor: Colors.white,
            autofocus: false,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new))),
      body: searchInput == ''
          ? Center(
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.search,
                    ),
                    Text('Search for anything')
                  ],
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var result = snapshot.data!.docs.where((element) =>
                    element['product_name'.toLowerCase()]
                        .contains(searchInput.toLowerCase()));

                return ListView(
                    children: result
                        .map((element) => SearchModel(
                              element: element,
                            ))
                        .toList());
              },
            ),
    );
  }
}

class SearchModel extends StatelessWidget {
  final dynamic element;
  const SearchModel({
    super.key,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productList: element),
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: const EdgeInsets.all(10),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 60,
              child: Image.network(
                element['product_images'][0],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(element['product_name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(element['product_description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.blueGrey)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
