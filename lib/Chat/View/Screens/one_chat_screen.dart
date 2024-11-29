import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:my_way_chat/Chat/View/Screens/view_image_before_sending.dart';
import 'package:my_way_chat/Chat/View/Widgets/Base/bubbles_builder.dart';
import 'package:my_way_chat/Chat/View/Widgets/Bubbles/date_bubble.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/app_looding.dart';
import 'package:my_way_chat/Chat/View/Widgets/one_chat_shimmer.dart';
import 'package:my_way_chat/Chat/View/Widgets/send_file_dialog.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/try_agin.dart';
import 'package:my_way_chat/Chat/temp/functions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sizer/sizer.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Cubit/chat_states.dart';
import 'package:my_way_chat/Chat/View/Widgets/Base/box_recording.dart';
import 'package:my_way_chat/Chat/View/Widgets/chose_image_or_file.dart';
import 'package:my_way_chat/Chat/View/Widgets/Base/emoji.dart';

import '../Widgets/chat_app_bar.dart';
import '../Widgets/Base/chat_input_field.dart';

class OneChatScreen extends StatefulWidget {
  const OneChatScreen({
    super.key,
    required this.chatCubit,
    this.subjectId = 57,
    required this.user,
  });
  final ChatCubit chatCubit;
  final int subjectId;
  final User user;

  @override
  State<OneChatScreen> createState() => _OneChatScreenState();
}

class _OneChatScreenState extends State<OneChatScreen> {
  late Timer timer;
  @override
  void initState() {
    widget.chatCubit
      ..subjectId = widget.subjectId
      ..userId = widget.user.id
      ..getMessages()
      ..refreshController = RefreshController()
      ..startAutoRefresh();

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: Size(100.w, 8.h),
          child: SafeArea(
            child: ChatAppBar(
              user: widget.user,
              lastSeen: dateFormatted(widget.user.lastActiveAt),
            ),
          ),
        ),
        body: BlocProvider.value(
          value: widget.chatCubit,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/icons/back.png",
                  ),
                  fit: BoxFit.fill),
            ),
            child: BlocConsumer<ChatCubit, ChatStates>(
              listener: (context, state) {
                final ChatCubit chatCubit = ChatCubit.get(context);

                if (state is SendingTextState) {
                  chatCubit.sendText(
                      messageToSend: chatCubit.textMessagesQueue.first,
                      subjectId: widget.subjectId,
                      userId: widget.user.id);
                } else if (state is SendingAudioState) {
                  chatCubit.sendAudio(
                      messageToSend: chatCubit.audioMessagesQueue.first,
                      subjectId: widget.subjectId,
                      userId: widget.user.id);
                } else if (state is SendingFileState) {
                  if (chatCubit.fileMessagesQueue.isEmpty) {
                    errorDialog(context, "الصيغة المدعومة حصراً pdf ");
                  } else {
                    chatCubit.sendFile(
                        messageToSend: chatCubit.fileMessagesQueue.first,
                        subjectId: widget.subjectId,
                        userId: widget.user.id);
                  }
                } else if (state is SendingImageState) {
                  chatCubit.sendImage(
                      messageToSend: chatCubit.imageMessageQueue.first,
                      subjectId: widget.subjectId,
                      userId: widget.user.id);
                } else if (state is ScrollToReplyLoadingState) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF1E7876),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "...يرجى الانتظار",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ScrollToReplySucsesState) {
                  Navigator.pop(context);
                } else if (state is AuthRefreshErrorState) {
                  errorDialog(context, 'خطأ في الشبكة');
                } else if (state is NotCompatibleState) {
                  errorDialog(context, state.message);
                } else if (state is ImagePicked) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewImageBeforeSending(
                      messageCubit: widget.chatCubit,
                      subjectId: widget.subjectId,
                      user: widget.user,
                    ),
                  ));
                } else if (state is FilePicked) {
                  showDialog(
                    context: context,
                    builder: (context) => SendFileDialog(
                      subjectId: widget.subjectId,
                      user: widget.user,
                      fileName: [widget.chatCubit.pdfName],
                      chatCubit: widget.chatCubit,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final ChatCubit chatCubit = ChatCubit.get(context);

                if (state is ChatSuccessState) {
                  chatCubit.listObserverController ??= ListObserverController(
                      controller: chatCubit.scrollController);
                }

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (chatCubit.oneChatError) {
                            return TryAgain(
                              onPressed: () {
                                widget.chatCubit.getMessages();
                              },
                            );
                          }
                          if (chatCubit.loadingOneChat) {
                            return const OneChatShimmer();
                          }
                          return ListViewObserver(
                            controller: chatCubit.listObserverController,
                            child: SmartRefresher(
                              footer: CustomFooter(
                                builder: (context, mode) => const AppLoading(),
                              ),
                              controller: chatCubit.refreshController,
                              enablePullUp: true,
                              enablePullDown: false,
                              onLoading: () {
                                chatCubit.getMessages(
                                  params: {
                                    "fmid": chatCubit
                                        .messages![
                                            chatCubit.messages!.length - 1]
                                        .id
                                  },
                                );
                              },
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  if (index < chatCubit.messages!.length - 1) {
                                    if (comparTowDates(
                                        chatCubit.messages![index].createdAt,
                                        chatCubit
                                            .messages![index + 1].createdAt)) {
                                      return DateBubble(
                                        date: dateBubbleFormat(chatCubit
                                            .messages![index].createdAt),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return DateBubble(
                                        date: dateBubbleFormat(chatCubit
                                            .messages![index].createdAt));
                                  }
                                },
                                controller: chatCubit.scrollController,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  final bool previousMessageIsme;

                                  if (index != 0) {
                                    previousMessageIsme = chatCubit
                                        .messages![index - 1].isSentByAuthUser!;
                                  } else if (index <
                                      chatCubit.messages!.length) {
                                    previousMessageIsme = !chatCubit
                                        .messages![index].isSentByAuthUser!;
                                  } else {
                                    previousMessageIsme = true; //willnot use
                                  }

                                  if (index == chatCubit.messages!.length) {
                                    return const SizedBox();
                                  } else {
                                    return BubblesBuilder(
                                        chatCubit: chatCubit,
                                        index: index,
                                        previousMessageIsme:
                                            previousMessageIsme,
                                        message: chatCubit.messages![index]);
                                  }
                                },
                                itemCount: chatCubit.messages!.length + 1,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    PopScope(
                      canPop: !chatCubit.showEmoji,
                      onPopInvoked: (didPop) {
                        if (chatCubit.showEmoji) {
                          chatCubit.cancelShowingEmojis();
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ChatInputField(
                                user: widget.user,
                                subjectId: widget.subjectId,
                              ),
                              if (chatCubit.isRecording)
                                BoxRecording(
                                  user: widget.user,
                                  subjectId: widget.subjectId,
                                ),
                              if (chatCubit.isChoseingFile)
                                const ChoseImageOrFile()
                            ],
                          ),
                          ChatEmoji(chatCubit: chatCubit),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorDialog(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 50.w,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red.shade200,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Center(
            child: Text(
          message,
          textAlign: TextAlign.center,
        ))));
  }
}
