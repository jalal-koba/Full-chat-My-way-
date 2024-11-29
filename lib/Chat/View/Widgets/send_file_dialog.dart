import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:sizer/sizer.dart';

class SendFileDialog extends StatelessWidget {
  const SendFileDialog(
      {super.key,
      required this.fileName,
      required this.chatCubit,
      required this.user,
      required this.subjectId});

  final List<String?> fileName;
  final ChatCubit chatCubit;
  final User user;
  final int subjectId;

  @override
  Widget build(BuildContext context) {
    return FlipInY(
      duration: const Duration(milliseconds: 500),
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(5.w),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF2BA9A6), width: 3)),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure to send :',
                style: TextStyle(),
              ),
              SizedBox(width: 0.0, height: 2.h),
              Text('$fileName',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey)),
              SizedBox(width: 0.0, height: 3.h),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: CustomTextButton(
                        title: "إلغاء",
                        textColor: Colors.white,
                        backgroundColor: const Color(0xFF1E7876),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 4.w, height: 0.0),
                    Expanded(
                        child: CustomTextButton(
                            backgroundColor: const Color(0xFF2BA9A6),
                            textColor: Colors.white,
                            title: "إرسال",
                            onPressed: () {
                              chatCubit.sendFileSunc();
                              
                              Navigator.pop(context);
                            })),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });
  final String title;
  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.white,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(8))),
        onPressed: onPressed,
        child: Text(title, style: TextStyle(color: textColor ?? Colors.black)));
  }
}
