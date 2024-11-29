 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Cubit/chat_states.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/base_bubble.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/reply_card.dart';
import 'package:my_way_chat/Chat/temp/functions.dart';
import 'package:sizer/sizer.dart';

import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';

import '../time_and_tic.dart';

class TextBubble extends StatefulWidget {
  final bool previousMessageIsme;
  final Message message;
  final ChatCubit chatCubit;
  final int index;
  const TextBubble({
    super.key,
    required this.previousMessageIsme,
    required this.message,
    required this.chatCubit,
    required this.index,
  });

  @override
  State<TextBubble> createState() => _TextBubbleState();
}

class _TextBubbleState extends State<TextBubble>
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                                        message: widget.message,
                                        isTextMessage: true,
                                      ),
                                    const SizedBox(width: 0.0, height: 2.0),
                                    Text(
                                      "${widget.message.content}  ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color:
                                            const Color.fromARGB(181, 0, 0, 0),
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    TimeAndTic(message: widget.message)
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
                  movementDuration: const Duration(milliseconds: 10),
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
