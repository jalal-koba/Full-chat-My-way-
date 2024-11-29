 import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:my_way_chat/Chat/View/Widgets/user_image.dart';
import 'package:sizer/sizer.dart';
 

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    super.key,
    required this.user,
    required this.lastSeen,
  });
  final User user;
  final String lastSeen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 8.h,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF1E7876), Color(0xFF2BA9A6)])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          SizedBox(width: 1.w, height: 0.0),
          SizedBox(
            width: 14.w,
            child: UserImage(
              user: user,
            ),
          ),
          SizedBox(width: 5.w, height: 0.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(),
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  user.name,
                  style: TextStyle(
                      fontSize: 10.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  lastSeen,
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w, height: 0.0)
        ],
      ),
    );
  }
}
