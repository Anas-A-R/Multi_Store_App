import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imageList;
  const FullScreenView({super.key, required this.imageList});

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppbarBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
                child: Text(
              '${index + 1} / ${widget.imageList.length.toString()}',
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  controller: _controller,
                  children: images()),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: imageView(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> images() {
    return List.generate(
        widget.imageList.length,
        (index) => InteractiveViewer(
            transformationController: TransformationController(),
            child: Image(
                image: NetworkImage(widget.imageList[index].toString()))));
  }

  Widget imageView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imageList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _controller.jumpToPage(index);
          },
          child: Container(
              width: 120,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.yellow, width: 7)),
              child: Image.network(
                widget.imageList[index],
                fit: BoxFit.cover,
              )),
        );
      },
    );
  }
}
