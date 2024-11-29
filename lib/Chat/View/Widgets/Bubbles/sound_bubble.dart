import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/base_bubble.dart';
import 'package:my_way_chat/Chat/temp/functions.dart';
import 'package:sizer/sizer.dart';
import 'package:voice_message_player/voice_message_player.dart';

import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Cubit/chat_states.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/reply_card.dart';
import 'package:my_way_chat/Chat/Voice/Cubit/voice_cubit.dart';
import 'package:my_way_chat/Chat/Voice/Cubit/voice_state.dart';

import '../time_and_tic.dart';
import 'loading_sound.dart';

class SoundBubble extends StatefulWidget {
  final bool previousMessageIsMe;
  final Message message;
  final ChatCubit chatCubit;
  final int index;
  const SoundBubble({
    super.key,
    required this.previousMessageIsMe,
    required this.message,
    required this.chatCubit,
    required this.index,
  });

  @override
  State<SoundBubble> createState() => _SoundBubbleState();
}

class _SoundBubbleState extends State<SoundBubble>
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
    // initializeController();
    initializeControllerMap();

    super.initState();
  }

  VoiceCubit voiceCubit = VoiceCubit();

  Future<void> initializeControllerMap() async {
    context.read<ChatCubit>().mapVoiceControllers[widget.message.id] =
        await voiceCubit.addVoiceController(
            widget.message.file, widget.message.id, widget.chatCubit);
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
          _controller.forward();
        }

        return AnimatedBuilder(
            animation: _colorAnimation,
            child: BlocProvider(
              create: (context) => voiceCubit,
              child: BlocBuilder<VoiceCubit, VoiceState>(
                builder: (context, state) {
                  return state is VoiceSuccessState && !widget.message.isLocal
                      ? BlocBuilder<ChatCubit, ChatStates>(
                          builder: (context, state) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  widget.message.isSentByAuthUser!
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
                                        context
                                            .read<ChatCubit>()
                                            .showMessageMenu(
                                                context,
                                                details.globalPosition,
                                                widget.message);
                                      },
                                      child: BaseBubble(
                                        isSentByAuthUser:
                                            widget.message.isSentByAuthUser!,
                                        previousMessageIsme:
                                            widget.previousMessageIsMe,

                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              if (widget.message.reply != null)
                                                SizedBox(
                                                  width: 65.w,
                                                  child: ReplyCard(
                                                    chatCubit: widget.chatCubit,
                                                    message: widget.message,
                                                  ),
                                                ),
                                              VoiceMessagePlayer(
                                                  playIcon: Icon(
                                                    Icons.play_arrow,
                                                    size: 24.sp,
                                                    color: Colors.white,
                                                  ),
                                                  size: 35.sp,
                                                  innerPadding: 0,
                                                  circlesColor:
                                                      Colors.green[400]!,
                                                  activeSliderColor:
                                                      Colors.green[400]!,
                                                  backgroundColor: widget
                                                          .message
                                                          .isSentByAuthUser!
                                                      ? Colors.green[100]!
                                                      : Colors.white,
                                                  controller: context
                                                          .read<ChatCubit>()
                                                          .mapVoiceControllers[
                                                      widget.message.id]!),
                                              TimeAndTic(
                                                  message: widget.message)
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : LoadingSound(
                          index: widget.index,
                          chatCubit: widget.chatCubit,
                          message: widget.message,
                          previousMessageIsMe: widget.previousMessageIsMe,
                          loading: false,
                        );
                },
              ),
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
