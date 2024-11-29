import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:sizer/sizer.dart';

class ViewImageBeforeSending extends StatelessWidget {
  const ViewImageBeforeSending(
      {super.key,
      required this.messageCubit,
      required this.subjectId,
      required this.user});
  final ChatCubit messageCubit;
  final int subjectId;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70.h,
                  child: Image.file(
                    File(
                      messageCubit.imageToSend!.path,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 5,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                ),
                Positioned(
                  bottom: 10,
                  width: 100.w,
                  child: Row(
                    children: [
                      const SizedBox(width: 5, height: 0.0), // add caption on image
                      // Expanded(
                      //   child: TextFormField(
                      //     controller: messageCubit.chatController,
                      //     style:
                      //         TextStyle(fontSize: 12.sp, color: Colors.black87),
                      //     decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.symmetric(
                      //           horizontal: 10, vertical: 8),
                      //       hintText: 'Add caption..',
                      //       hintStyle: TextStyle(color: Colors.grey[400]),
                      //       fillColor: Colors.white,
                      //       filled: true,
                      //       border: OutlineInputBorder(
                      //           borderSide:
                      //               const BorderSide(color: Colors.grey),
                      //           borderRadius: BorderRadius.circular(8)),
                      //       enabledBorder: OutlineInputBorder(
                      //           borderSide:
                      //               const BorderSide(color: Colors.grey),
                      //           borderRadius: BorderRadius.circular(8)),
                      //       focusedBorder: OutlineInputBorder(
                      //           borderSide:
                      //               BorderSide(color: Colors.green[100]!),
                      //           borderRadius: BorderRadius.circular(8)),
                      //     ),
                      //   ),
                      // ),
                      const Spacer( ),
                      IconButton(
                        onPressed: () {
                          messageCubit.sendImageMessage( );
                          Navigator.pop(context);
                        },
                        style: IconButton.styleFrom( 
                        fixedSize: Size(15.w, 15.w),
                            backgroundColor: Colors.green[500]),
                        icon: Icon(
                          Icons.send_rounded,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                      )
                      ,
                      SizedBox(width: 3.w, height: 0.0)
                    ],
                  ),
                )
              ],
            )));
  }
}
