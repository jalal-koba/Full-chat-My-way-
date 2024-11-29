import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/custom_loading.dart';
import 'package:sizer/sizer.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CustomLoadingFlicker(
      leftDotColor: const Color(0xFF2BA9A6),
      size: 40.sp,
      rightDotColor: const Color(0xFF1E7876),
    ));
  }
}
