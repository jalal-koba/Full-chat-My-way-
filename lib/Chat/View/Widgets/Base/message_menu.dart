import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:sizer/sizer.dart';

  List<PopupMenuEntry<String>>  getMenuItem(Message message)  {
  return [
    if (message.isError)
      PopupMenuItem(
        value: 'resend',
        child: Center(
          child: Text(
            'إعادة إرسال',
            style: TextStyle(
                fontSize: 10.sp, color: const Color.fromARGB(184, 0, 0, 0)),
          ),
        ),
      ),
    if (message.content != null)
      PopupMenuItem(
        value: 'copy',
        child: Center(
          child: Text(
            'نسخ النص',
            style: TextStyle(
                fontSize: 10.sp, color: const Color.fromARGB(184, 0, 0, 0)),
          ),
        ),
      ),
    if (!message.isLocal)
      PopupMenuItem(
        value: 'Reply',
        child: Center(
          child: Text(
            'رد',
            style: TextStyle(
                fontSize: 10.sp, color: const Color.fromARGB(184, 0, 0, 0)),
          ),
        ),
      ),
  ];
}
