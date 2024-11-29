import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.image,
    this.isCover = true,
  });

  final String image;
  final bool isCover;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: isCover ? BoxFit.cover : null,
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () {
            context
                .read<ChatCubit>()
                .refreshScreen(); // when this funcntion execute the image dwonload again ,since widgt is rebuilt
          },
          icon: Icon(
            Icons.refresh,
            size: 30.sp,
          ),
        ),
      ),
      imageUrl: "_private_/storage/$image",
      progressIndicatorBuilder: (context, url, progress) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        child: Container(
          color: Colors.grey,
        ),
      ),
    );
  }
}
