import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/cached_image.dart';
import 'package:sizer/sizer.dart';

class UserImage extends StatelessWidget {
  const UserImage({super.key, 
     required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.grey[500]!,
              blurRadius: 2,
              offset: const Offset(0, 1),
              spreadRadius: 1)
        ],
        color: Colors.grey[200],
      ),
      width: 17.w,
      height: 10.h,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(width: 17.w,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CachedImage(
              image: user.image,
            ),
          ),
          if (user.isOnline)
            CircleAvatar(
              radius: 6.sp,
              backgroundColor: Colors.green,
            )
        ],
      ),
    );
  }
}
