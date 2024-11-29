import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class OneChatShimmer extends StatelessWidget {
  const OneChatShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
            6,
            (index) => Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.2),
                highlightColor: Colors.white54,
                child: Bubble(
                  margin: index.isEven
                      ? BubbleEdges.fromLTRB(15.w, 1.h, 1.w, 5)
                      : BubbleEdges.fromLTRB(1.w, 1.h, 15.w, 5),
                  showNip: true,
                  elevation: 1.8,
                  radius: const Radius.circular(12),
                  padding:
                      const BubbleEdges.symmetric(horizontal: 12, vertical: 5),
                  color: Colors.green[100],
                  nip: index.isEven
                      ? BubbleNip.rightBottom
                      : BubbleNip.leftBottom,
                  nipHeight: 10,
                  nipWidth: 8,
                  child: Row(
                    mainAxisAlignment: index.isEven
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: SizedBox(
                        width: 300,
                        height: index * 2.h + 10.h,
                      )),
                    ],
                  ),
                ))),
      ),
    );
  }
}
