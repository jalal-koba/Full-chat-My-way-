import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class BaseBubble extends StatelessWidget {
  const BaseBubble({
    super.key,
    required this.isSentByAuthUser,
    required this.previousMessageIsme,
    this.isImage = false,
    required this.child,
  });
  final Widget child;
  final bool isSentByAuthUser;
  final bool previousMessageIsme;
  final bool isImage;
  @override
  Widget build(BuildContext context) {
    return Bubble(
      showNip: previousMessageIsme != isSentByAuthUser,
      elevation: 1.8,
      radius: const Radius.circular(12),
      padding: isImage
          ? const BubbleEdges.symmetric(horizontal: 1, vertical: 1)
          : const BubbleEdges.symmetric(horizontal: 12, vertical: 5),
      color: isSentByAuthUser ? Colors.green[100] : Colors.white,
      nip: isSentByAuthUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
      nipHeight: 10,
      nipWidth: 8,
      child: Row(
        mainAxisAlignment:
            isSentByAuthUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: child),
        ],
      ),
    );
  }
}
