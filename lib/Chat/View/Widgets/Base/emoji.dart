import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';

class ChatEmoji extends StatelessWidget {
  const ChatEmoji({
    super.key,
    required this.chatCubit,
  });

  final ChatCubit chatCubit;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !chatCubit.showEmoji,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          chatCubit.onChangeChatField( );
        },
        textEditingController: chatCubit.chatController,
        config: Config(
          height: 220,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.2
                    : 1.0),
          ),
          swapCategoryAndBottomBar: false,
          skinToneConfig: const SkinToneConfig(),
          categoryViewConfig: const CategoryViewConfig(),
          bottomActionBarConfig: BottomActionBarConfig(
              enabled: false,
              backgroundColor: Colors.green[300],
              showSearchViewButton: false),
          searchViewConfig: const SearchViewConfig(),
        ),
      ),
    );
  }
}
