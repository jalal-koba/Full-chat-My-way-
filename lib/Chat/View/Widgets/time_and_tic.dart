import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/temp/functions.dart';
import 'package:sizer/sizer.dart';

class TimeAndTic extends StatelessWidget {
  const TimeAndTic({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        !message.isSentByAuthUser!
            ? const SizedBox()
            : message.isLocal && !message.isError
                ? Icon(
                    Icons.timer_outlined,
                    color: Colors.grey,
                    size: 15.sp,
                  )
                : message.isError
                    ? Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 16.sp,
                    )
                    : message.readAt != null
                        ? Icon(
                            Icons.done_all,
                            color: Colors.green,
                            size: 15.sp,
                          )
                        : Icon(
                            Icons.done,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
        SizedBox(width: 1.w, height: 0.0),
        Text(
          dateFormattedMessage(message.createdAt),
          style: TextStyle(
            fontSize: 8.2.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
