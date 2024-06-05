import 'package:flutter/material.dart';
import 'package:supplier_multi_store_app/widgets/appbar_widgets.dart';

class MyStore extends StatelessWidget {
  const MyStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const AppbarTitle(title: 'My Store'),
    ));
  }
}
