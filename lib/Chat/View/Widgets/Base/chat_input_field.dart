import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/cached_image.dart';
import 'package:sizer/sizer.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    super.key,
    required this.user,
    required this.subjectId,
  });
  final User user;
  final int subjectId;
  @override
  Widget build(BuildContext context) {
    final ChatCubit messageCubit = ChatCubit.get(context);

    return Container(
      padding: EdgeInsets.only(
        left: 1.w,
        right: 1.w,
        top: 2,
        bottom: 2.h,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 224, 224, 224),
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          if (messageCubit.reply)
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10),
                  child: Icon(
                    Icons.reply,
                    color: const Color(0xFF2BA9A6),
                    size: 25.sp,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      messageCubit.messageToReplyType == "text"
                          ? Text(
                              "${messageCubit.messageToReply}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 10.sp),
                            )
                          : messageCubit.messageToReplyType == "image"
                              ? Container(
                                  margin: EdgeInsets.all(2.w),
                                  clipBehavior: Clip.hardEdge,
                                  width: 30.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: CachedImage(
                                      image: messageCubit.messageToReply!),
                                )
                              : messageCubit.messageToReplyType == "audio"
                                  ? Row(
                                      children: [
                                        SizedBox(width: 2.w, height: 0.0),
                                        const Icon(
                                          Icons.voice_chat,
                                          color: Color(0xFF2BA9A6),
                                        ),
                                        SizedBox(width: 4.w, height: 0.0),
                                        const Text('رسالة صوتية'),
                                        SizedBox(width: 2.w, height: 0.0),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        SizedBox(width: 2.w, height: 0.0),
                                        const Icon(
                                          Icons.file_present_rounded,
                                          color: Color(0xFF2BA9A6),
                                        ),
                                        SizedBox(width: 4.w, height: 0.0),
                                        const Text('ملف'),
                                        SizedBox(width: 2.w, height: 0.0),
                                      ],
                                    ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      messageCubit.cancelReplaying();
                    },
                    icon: const Icon(Icons.clear))
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.attach_file,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  messageCubit.choseFileOrImage();
                },
              ),
              Expanded(
                child: TextFormField(
                  focusNode: messageCubit.inputFocusNode,
                  controller: messageCubit.chatController,
                  onChanged: (value) {
                    messageCubit.onChangeChatField( );
                  },
                  minLines: 1,
                  maxLines: messageCubit.isRecording ? 1 : 5,
                  onTap: () {
                    if (messageCubit.showEmoji) {
                      messageCubit.cancelShowingEmojis();
                    }
                  },
                  style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          messageCubit.showEmoji
                              ? Icons.keyboard_alt_outlined
                              : Icons.sentiment_satisfied_alt,
                          color: Colors.green[500]
                      
                          ),
                      onPressed: () {
                        if (!context.read<ChatCubit>().showEmoji) {
                          messageCubit.showEmojies();
                        } else {
                          messageCubit.cancelShowingEmojis();

                          messageCubit.inputFocusNode.requestFocus();
                        }
                      },
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[100]!),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              messageCubit.recordButton
                  ? InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        messageCubit.startRecording(context);
                      },
                      onLongPress: () {
                        messageCubit.startRecording(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.green[500], shape: BoxShape.circle),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.green[500]),
                      icon: Icon(
                        Icons.send_rounded,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await messageCubit.sendTextSunc(
                            subjectId: subjectId, userId: user.id);
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
