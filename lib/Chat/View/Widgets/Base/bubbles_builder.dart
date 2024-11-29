import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/file_bubble.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/image_bubble.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/loading_sound.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/sound_bubble.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/text_bubble.dart';

class BubblesBuilder extends StatelessWidget {
  const BubblesBuilder(
      {super.key,
      required this.message,
      required this.chatCubit,
      required this.previousMessageIsme,
      required this.index});
  final Message message;
  final ChatCubit chatCubit;
  final int index;
  final bool previousMessageIsme;

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case 'text':
        return TextBubble(
          index: index,
          chatCubit: chatCubit,
          message: message,
          previousMessageIsme: previousMessageIsme,
        );

      case 'image':
        return ImageBubble(
          index: index,
          chatCubit: chatCubit,
          previousMessageIsme: previousMessageIsme,
          message: message,
        );

      case "audio":
        if (message.isLocal) {
          return LoadingSound(
              index: index,
              chatCubit: chatCubit,
              message: message,
              loading: true,
              previousMessageIsMe: previousMessageIsme);
        } else {
          return SoundBubble(
              chatCubit: chatCubit,
              index: index,
              message: message,
              previousMessageIsMe: previousMessageIsme);
        }

      case 'file':
        return FileBubble(
            index: index,
            chatCubit: chatCubit,
            previousMessageIsme: previousMessageIsme,
            message: message);

      default:
        return Text(message.type);
    }
  }
}
