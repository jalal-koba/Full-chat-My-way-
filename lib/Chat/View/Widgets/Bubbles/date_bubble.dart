 
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DateBubble extends StatelessWidget {
  const DateBubble({
    super.key,
    required this.date,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(212, 112, 189, 188)),
        child: Text(
          date,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
      ),
    );
  }
}
