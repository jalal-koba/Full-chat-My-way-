import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Cubit/chat_states.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/try_agin.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/chat_card.dart';

class ChatsScreens extends StatelessWidget {
  ChatsScreens({super.key, this.subjectId = 57});
  final int subjectId;
  final ChatCubit chatCubit = ChatCubit();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Color(0xFF1E7876)),
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            title: Image.asset(
              "assets/icons/logo 1.png",
            )),
        body: BlocProvider(
            create: (context) => chatCubit..getChats(subjectId: subjectId),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 100.w
                          : 100.h,
                  height: 8.h,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xFF1E7876), Color(0xFF2BA9A6)])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset("assets/icons/chatlogo.png"),

                      /// replace it with SvgPicture
                      SizedBox(width: 5.w, height: 0.0),
                      Expanded(
                        child: Text(
                          // add from api
                          'Connect with Arabic language teachers',
                          style: TextStyle(
                              fontSize: 10.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: BlocBuilder<ChatCubit, ChatStates>(
                  builder: (context, state) {
                    final ChatCubit chatCubit = ChatCubit.get(context);

                    if (state is ChatErrorState) {
                      return TryAgain(
                        onPressed: () {
                          chatCubit.getChats(subjectId: subjectId);
                        },
                      );
                    }
                    if (chatCubit.loadingChats) {
                      return const ChatsShimmer();
                    }

                    if (chatCubit.users!.isEmpty) {
                      return const Center(
                        child: Text('لايوجد محادثات حتى الآن'),
                      );
                    }

                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 10,
                          indent: 5.w,
                          thickness: .8,
                          color: const Color(0XFF20807D),
                          endIndent: 5.w,
                        );
                      },
                      itemBuilder: (context, index) {
                        return ChatCard(
                          chatCubit: chatCubit,
                          subjectId: subjectId,
                          user: chatCubit.users![index],
                        );
                      },
                      itemCount: chatCubit.users!.length,
                    );
                  },
                ))
              ],
            )),
      ),
    );
  }
}

class ChatsShimmer extends StatelessWidget {
  const ChatsShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          10,
          (index) => ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              leading: AppShimmer(
                  child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                ),
                width: 17.w,
                height: 10.h,
              )),
              subtitle: Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppShimmer(
                  child: Container(
                    width: 40.w,
                    color: Colors.grey,
                    height: 1.5.h,
                  ),
                ),
              ),
              title: Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppShimmer(
                  child: Container(
                    width: 20.w,
                    color: Colors.grey,
                    height: 1.5.h,
                  ),
                ),
              ),
              trailing: AppShimmer(
                child: Container(
                  width: 15.w,
                  color: Colors.grey[200],
                  height: 1.5.h,
                ),
              )),
        ),
      ),
    );
  }
}

class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: child);
  }
}
