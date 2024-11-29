import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Cubit/chat_states.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/View/Screens/view_image.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/base_bubble.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/cached_image.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/reply_card.dart';
import 'package:my_way_chat/Chat/View/Widgets/sending_percentage.dart';
import 'package:my_way_chat/Chat/temp/functions.dart';
import 'package:sizer/sizer.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import '../time_and_tic.dart';

class ImageBubble extends StatefulWidget {
  final bool previousMessageIsme;
  final int index;
  final Message message;
  final ChatCubit chatCubit;

  const ImageBubble({
    super.key,
    required this.previousMessageIsme,
    required this.message,
    required this.chatCubit,
    required this.index,
  });

  @override
  State<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _colorAnimation = bubbleTween(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatStates>(
      buildWhen: (previous, current) =>
          current is ScrollToReplyState &&
          widget.index == widget.chatCubit.messageToReplyIndex,
      builder: (context, state) {
        final ChatCubit chatCubit = ChatCubit.get(context);
        if (widget.index == chatCubit.messageToReplyIndex) {
          chatCubit.messageToReplyIndex = null;
          _controller.forward().then((_) {});
        }

        return AnimatedBuilder(
            animation: _colorAnimation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.message.isSentByAuthUser!
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    margin: widget.message.isSentByAuthUser!
                        ? EdgeInsets.fromLTRB(15.w, 5, 0, 5)
                        : EdgeInsets.fromLTRB(0, 5, 15.w, 5),
                    child: InkWell(
                      onTapUp: (details) {
                        context.read<ChatCubit>().showMessageMenu(
                              context,
                              details.globalPosition,
                              widget.message,
                            );
                      },
                      child: BaseBubble(
                        isSentByAuthUser: widget.message.isSentByAuthUser!,
                        previousMessageIsme: widget.previousMessageIsme,
                        isImage: true,
                        child: Row(
                          mainAxisAlignment: widget.message.isSentByAuthUser!
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (widget.message.reply != null)
                                      ReplyCard(
                                          chatCubit: widget.chatCubit,
                                          message: widget.message),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => ViewImage(
                                              url: widget.message.file!,
                                              tag: widget.message.id),
                                        ));
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                  bottomLeft:
                                                      Radius.circular(4),
                                                  bottomRight:
                                                      Radius.circular(4),
                                                ),
                                                color: Colors.black87,
                                              ),
                                              width: double.infinity,
                                              height: 30.h,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Hero(
                                                tag: widget.message.id,
                                                child: widget.message.isLocal
                                                    ? Image.file(
                                                        File(widget
                                                            .message.file!),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedImage(
                                                        image: widget
                                                            .message.file!,
                                                      ),
                                              )),
                                          if (widget.message.isLocal &&
                                              !widget.message.isError)
                                            Container(
                                                alignment: Alignment.center,
                                                width: 15.w,
                                                height: 15.w,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black54),
                                                child: SendingPercentage(
                                                  key: widget.chatCubit
                                                      .sendingImagePercentageKey,
                                                )),
                                          if (widget.message.isError)
                                            InkWell(
                                              onTapUp: (details) {
                                                widget.chatCubit
                                                    .showMessageMenu(
                                                        context,
                                                        details.globalPosition,
                                                        widget.message);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(3.w),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black38,
                                                ),
                                                child: Icon(
                                                  Icons.error,
                                                  size: 25.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 0.0, height: 2.0),
                                    if (widget.message.content != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          "${widget.message.content}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                181, 0, 0, 0),
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 2.0),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        child:
                                            TimeAndTic(message: widget.message))
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            builder: (context, child) {
              return Dismissible(
                  dismissThresholds: const {DismissDirection.horizontal: 0.1},
                  resizeDuration: const Duration(milliseconds: 1),
                  behavior: HitTestBehavior.deferToChild,
                  confirmDismiss: (direction) async {
                    chatCubit.onReply(widget.message);

                    return false;
                  },
                  key: Key("${widget.index}"),
                  direction: widget.message.isLocal
                      ? DismissDirection.none
                      : DismissDirection.startToEnd,
                  child: Container(color: _colorAnimation.value, child: child));
            });
      },
    );
  }
}
