
import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/cached_image.dart';
import 'package:sizer/sizer.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.url, required this.tag});
  final String url; // بدنا url
  final int tag; // بدنا url
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: tag,
            child: SizedBox(
                height: 70.h, width: 100.w, child: CachedImage(image: url,isCover: false,)),
          ),
        ),
      ),
    );
  }
}
