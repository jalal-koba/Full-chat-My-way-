import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart'; 
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:sizer/sizer.dart';

class BoxRecording extends StatefulWidget {
  const BoxRecording({super.key, required this.user, required this.subjectId});
  final User user;
  final int subjectId;
  @override
  State<BoxRecording> createState() => _BoxRecordingState();
}

class _BoxRecordingState extends State<BoxRecording> {
  @override
  Widget build(BuildContext context) {
    final messageCubit = ChatCubit.get(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      height: 8.8.h,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              onPressed: () {
                messageCubit.stopRecording();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
          const RecordTime(),
          IconButton(
            onPressed: () {
              messageCubit.sendAudioSunc(
                  );
            },
            icon: Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
            style: IconButton.styleFrom(backgroundColor: Colors.green),
          )
        ],
      ),
    );
  }
}

class RecordTime extends StatefulWidget {
  const RecordTime({super.key});

  @override
  RecordTimeState createState() => RecordTimeState();
}

class RecordTimeState extends State<RecordTime> {
  int seconds = 0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        seconds++;
        if (mounted) {
          setState(() {});
        }
      },
    );
    super.initState();
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(seconds),
      style: TextStyle(fontSize: 12.sp, color: Colors.red),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
