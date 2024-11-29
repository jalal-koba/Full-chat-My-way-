import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';

import 'package:sizer/sizer.dart';

class ChoseImageOrFile extends StatefulWidget {
  const ChoseImageOrFile({super.key});

  @override
  State<ChoseImageOrFile> createState() => _ChoseImageOrFileState();
}

class _ChoseImageOrFileState extends State<ChoseImageOrFile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animation;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageCubit = ChatCubit.get(context);

    return SlideTransition(
      position: animation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        color: Colors.white,
        height: 8.8.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                await messageCubit.pickImage(source: ImageSource.camera);
              },
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 17.sp,
              ),
              style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: const Color.fromARGB(255, 0, 132, 255)),
            ),
            IconButton(
              onPressed: () async {
                await messageCubit.pickImage(source: ImageSource.gallery);
              },
              icon: Icon(
                Icons.photo,
                color: Colors.white,
                size: 17.sp,
              ),
              style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: const Color.fromARGB(255, 105, 0, 222)),
            ),
            IconButton(
              onPressed: () async {
                await messageCubit.pickFile();
              },
              icon: Icon(
                Icons.upload_file_sharp,
                color: Colors.white,
                size: 17.sp,
              ),
              style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: const Color.fromARGB(255, 211, 0, 0)),
            ),
            IconButton(
              onPressed: () async {
                _controller.reverse().then(
                  (_) {
                    messageCubit.cancelChoosingFile();
                  },
                );
              },
              icon: Icon(
                Icons.close,
                color: Colors.red,
                size: 20.sp,
              ),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
