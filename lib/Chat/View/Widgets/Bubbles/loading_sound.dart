import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Cubit/chat_states.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/reply_card.dart';
import 'package:my_way_chat/Chat/temp/functions.dart';
import 'package:sizer/sizer.dart';

import '../time_and_tic.dart';

class LoadingSound extends StatefulWidget {
  const LoadingSound({
    super.key,
    required this.message,
    required this.loading,
    required this.previousMessageIsMe,
    required this.chatCubit,
    required this.index,
  });

  final Message message;
  final ChatCubit chatCubit;
  final bool loading;
  final bool previousMessageIsMe;
  final int index;

  @override
  State<LoadingSound> createState() => _LoadingSoundState();
}

class _LoadingSoundState extends State<LoadingSound>
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
            builder: (context, child) {
              return Dismissible(
                  direction: widget.message.isLocal
                      ? DismissDirection.none
                      : DismissDirection.startToEnd,
                  dismissThresholds: const {DismissDirection.horizontal: 0.1},
                  resizeDuration: const Duration(milliseconds: 1),
                  behavior: HitTestBehavior.deferToChild,
                  confirmDismiss: (direction) async {
                    chatCubit.onReply(widget.message);

                    return false;
                  },
                  key: Key("${widget.index}"),
                  child: Container(color: _colorAnimation.value, child: child));
            },
            child: InkWell(
              onTapUp: (details) {
                widget.chatCubit.showMessageMenu(
                    context, details.globalPosition, widget.message);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: widget.message.isSentByAuthUser!
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Bubble(
                      showNip: widget.previousMessageIsMe !=
                          widget.message.isSentByAuthUser!,
                      elevation: 1.8,
                      radius: const Radius.circular(15),
                      margin: widget.message.isSentByAuthUser!
                          ? BubbleEdges.fromLTRB(15.w, 5, 0, 5)
                          : BubbleEdges.fromLTRB(0, 5, 15.w, 5),
                      padding: const BubbleEdges.symmetric(
                          horizontal: 10, vertical: 0.5),
                      color: widget.message.isSentByAuthUser!
                          ? Colors.green[100]
                          : Colors.white,
                      nip: widget.message.isSentByAuthUser!
                          ? BubbleNip.rightBottom
                          : BubbleNip.leftBottom,
                      nipHeight: 10,
                      nipWidth: 8,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.message.reply != null)
                              SizedBox(
                                  width: 65.w,
                                  child: ReplyCard(
                                    message: widget.message,
                                    chatCubit: widget.chatCubit,
                                  )),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.w, vertical: 1.h),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.message.isError
                                      ? InkWell(
                                          onTapUp: (details) {
                                            widget.chatCubit.showMessageMenu(
                                                context,
                                                details.globalPosition,
                                                widget.message);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                shape: BoxShape.circle),
                                            padding: EdgeInsets.all(4.w),
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.white,
                                              size: 15.sp,
                                            ),
                                          ),
                                        )
                                      : _PlayButton(
                                          loading: widget.loading,
                                        ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 35.w,
                                    child: const Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10.w)
                                ],
                              ),
                            ),
                            TimeAndTic(message: widget.message)
                          ]),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}

class _PlayButton extends StatefulWidget {
  _PlayButton({
    required this.loading,
  });
  bool loading;
  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(backgroundColor: Colors.green[300]),
      icon: !widget.loading
          ? Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 22.sp,
            )
          : SizedBox(
              height: 3.h,
              width: 3.h,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
      onPressed: () {
        widget.loading = true;
        setState(() {});
      },
    );
  }
}
