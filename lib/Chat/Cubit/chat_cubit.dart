import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:my_way_chat/Chat/Cubit/chat_states.dart';
import 'package:my_way_chat/Chat/Models/chats_response.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/Models/message_to_send.dart';
import 'package:my_way_chat/Chat/Models/one_chat_response.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:my_way_chat/Chat/View/Widgets/Base/message_menu.dart';
import 'package:my_way_chat/Chat/View/Widgets/sending_percentage.dart';
import 'package:my_way_chat/Chat/temp/network.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sizer/sizer.dart';
import 'package:voice_message_player/voice_message_player.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(InitialState());

  static ChatCubit get(context) => BlocProvider.of(context);
  final FocusNode inputFocusNode = FocusNode();
  final TextEditingController chatController = TextEditingController();
  late String _audioPath;

  late String _pdfPath;
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  XFile? imageToSend;

  int prevControllerMap = -1;
  Map<int, VoiceController> mapVoiceControllers = {};
  bool _oneChatError = false;
  bool get oneChatError => _oneChatError;
  bool recordButton = true;
  bool isRecording = false;
  bool _reply = false;
  bool get reply => _reply;
  bool isChoseingFile = false;
  int? messageToReplyIndex;
  bool showEmoji = false;
  bool _loadingOneChat = false;
  bool get loadingOneChat => _loadingOneChat;
  bool _loadingChats = false;
  bool get loadingChats => _loadingChats;
  // bool lo
  int? messageToReplyId;
  late int? subjectId;
  late int? userId;
  final GlobalKey<SendingPercentageState> sendingFilePercentageKey =
      GlobalKey<SendingPercentageState>();

  final GlobalKey<SendingPercentageState> sendingImagePercentageKey =
      GlobalKey<SendingPercentageState>();

  final ScrollController scrollController = ScrollController();
  ListObserverController? listObserverController;

  void scrollToMessage({required int id}) async {
    int? index;
    for (int i = 0; i < messages!.length; i++) {
      if (messages![i].id == id) {
        index = i;

        messageToReplyIndex = index;

        listObserverController!.animateTo(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 300),
            index: index);
        emit(ScrollToReplyState());

        break;
      }
    }

    if (index == null) {
      await getMessages(params: {"lmid": id});

      scrollToMessage(id: id);
    }
  }

  String? messageToReply;

  String? messageToReplyType;

  String? pdfName;

  void showMessageMenu(
    BuildContext context,
    Offset offset,
    Message message,
  ) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
            constraints: BoxConstraints(
              maxWidth: 25.w,
              minWidth: 20,
            ),
            color: Colors.grey[200],
            surfaceTintColor: Colors.transparent,
            context: context,
            position: RelativeRect.fromLTRB(
              offset.dx,
              offset.dy,
              overlay.size.width,
              overlay.size.height,
            ),
            items: getMenuItem(message))
        .then((value) {
      inputFocusNode.unfocus();

      if (value == "resend") {
        if (message.type == 'text') {
          message.isError = false;
          emit(SendingTextState());
        } else if (message.type == 'audio') {
          message.isError = false;
          emit(SendingAudioState());
        } else if (message.type == 'image') {
          message.isError = false;
          emit(SendingImageState());
        } else if (message.type == 'file') {
          if (fileMessagesQueue.isNotEmpty) {
            message.isError = false;
          }
          emit(SendingFileState());
        }
      } else if (value == 'copy') {
        Clipboard.setData(ClipboardData(text: message.content!));
      } else if (value == 'Reply') {
        onReply(message);
      }
    });
  }

  void onReply(Message message) {
    showEmoji = false;
    _reply = true;

    if (message.type == "text") {
      messageToReply = message.content;
    } else {
      messageToReply = message.file;
    }

    messageToReplyType = message.type;

    messageToReplyId = message.id;
    onChangeChatField();

    Future.delayed(const Duration(milliseconds: 200), () {
      inputFocusNode.requestFocus();
    });
  }

  void showEmojies() {
    inputFocusNode.unfocus();
    showEmoji = true;
    onChangeChatField();
  }

  void refreshScreen() {
    emit(InitialState());
  }

  void cancelShowingEmojis() {
    showEmoji = false;
    onChangeChatField();
  }

  void choseFileOrImage() {
    isChoseingFile = true;
    emit(IsChoseingFile());
  }

  void cancelChoosingFile() {
    isChoseingFile = false;

    onChangeChatField();
  }

  void cancelReplaying() {
    _reply = false;
    onChangeChatField();
  }

  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      await Permission.microphone.request();
    }
    await recorder.openRecorder();
  }

  int _recordingTime = 0;

  Future<void> startRecording(BuildContext context) async {
    await _initializeRecorder();
    _recordingTime = DateTime.now().millisecondsSinceEpoch;

    isRecording = true;
    emit(IsRecording());

    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    _audioPath =
        '${appDocDirectory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await recorder.startRecorder(
      toFile: _audioPath,
      codec: Codec.aacADTS,
    );
  }

  Future<void> stopRecording() async {
    _recordingTime = DateTime.now().millisecondsSinceEpoch - _recordingTime;

    isRecording = false;
    await recorder.stopRecorder();

    if (chatController.text.isEmpty) {
      recordButton = true;
    } else {
      recordButton = false;
    }

    emit(InitialRecording());
  }

  Future<void> pickImage({required ImageSource source}) async {
    ImagePicker picker = ImagePicker();
    imageToSend = await picker.pickImage(source: source);
    if (imageToSend != null) {
      emit(ImagePicked());
    }
    cancelChoosingFile();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      pdfName = result.names.toString();
      _pdfPath = result.files.single.path!;

      emit(FilePicked());
    }
    cancelChoosingFile();
  }

  Timer? _debounce;

  void onChangeChatField() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      String text = chatController.text;

      if (text.isEmpty) {
        recordButton = true;
        emit(InitialRecording());
      } else {
        isRecording = false;
        recordButton = false;
        emit(IsTyping());
      }
    });
  }

  Message? getMessageToreply() {
    return _reply
        ? Message(
            id: messageToReplyId!,
            subjectId: 0,
            messageId: 0,
            content: messageToReplyType == 'text' ? messageToReply : null,
            file: messageToReplyType == 'image' ? messageToReply : null,
            type: messageToReplyType!,
            createdAt: DateTime.now(),
          )
        : null;
  }

  bool sendTextLoading = false;
  bool sendAudioLoading = false;
  bool sendFileLoading = false;
  bool sendImageLoading = false;

  Queue<MessageToSend> textMessagesQueue = Queue();

  sendTextSunc({required int subjectId, required int userId}) async {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);

    final date = DateTime.now();

    final int uniqueId = date.microsecondsSinceEpoch;

    messages!.insert(
        0,
        Message(
          id: uniqueId,
          subjectId: 0,
          reply: getMessageToreply(),
          messageId: messageToReplyId,
          content: chatController.text,
          type: "text",
          createdAt: date,
          isSentByAuthUser: true,
          isLocal: true,
        ));

    textMessagesQueue.add(MessageToSend(
        type: "text",
        uniqueId: uniqueId,
        content: chatController.text,
        messageToReplyId: messageToReplyId));

    _reply = false;
    messageToReplyId = null;
    chatController.text = "";
    recordButton = true;
    emit(SendingTextState());
  }

  Future<void> sendText(
      {required MessageToSend messageToSend,
      required int subjectId,
      required int userId}) async {
    if (sendTextLoading) {
      return;
    }
    FormData formData = FormData.fromMap({
      "content": messageToSend.content,
      "type": messageToSend.type,
      if (messageToSend.messageToReplyId != null)
        "message_id": messageToSend.messageToReplyId
    });
    try {
      sendTextLoading = true;

      Response response = await Network.postData(
          url:
              "_private_$subjectId/participants/$userId/messages",
          data: formData);

      Message message = Message.fromJson(response.data['data']);

      message.isSentByAuthUser = true;

      messages = messages!.map(
        (e) {
          if (messageToSend.uniqueId == e.id) {
            e.id = message.id;
            e.isLocal = false;
            e.isError = false;
          }
          return e;
        },
      ).toList();

      sendTextLoading = false;

      textMessagesQueue.removeFirst();
      emit(SendSuccessState());
      if (textMessagesQueue.isNotEmpty) {
        sendText(
            messageToSend: textMessagesQueue.first,
            subjectId: subjectId,
            userId: userId);
      }
    } on DioException catch (_) {
      sendTextLoading = false;

      textMessagesQueue.first.isError = true;

      messages = messages!.map(
        (e) {
          if (messageToSend.uniqueId == e.id) {
            e.isError = true;
          }
          return e;
        },
      ).toList();

      for (var element in textMessagesQueue) {
        messages = messages!.map(
          (e) {
            if (element.uniqueId == e.id) {
              e.isError = true;
            }
            return e;
          },
        ).toList();
      }
      emit(FailedSending());
    }
  }

  Queue<MessageToSend> audioMessagesQueue = Queue();

  Future sendAudioSunc() async {
    await stopRecording();
    if (_recordingTime < 1400) {
      return;
    }

    final date = DateTime.now();

    int uniqueId = date.microsecondsSinceEpoch;
    messages!.insert(
        0,
        Message(
          id: uniqueId,
          subjectId: -2,
          messageId: 0,
          reply: getMessageToreply(),
          file: _audioPath,
          type: "audio",
          createdAt: date,
          isSentByAuthUser: true,
          isLocal: true,
        ));

    audioMessagesQueue.add(MessageToSend(
      type: "audio",
      uniqueId: uniqueId,
      file: _audioPath,
      messageToReplyId: messageToReplyId,
    ));

    _reply = false;

    messageToReplyId = null;
    emit(SendingAudioState());
  }

  Future<void> sendAudio(
      {required MessageToSend messageToSend,
      required int subjectId,
      required int userId}) async {
    if (sendAudioLoading) {
      return;
    }

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        messageToSend.file!,
      ),
      "type": messageToSend.type,
      if (messageToSend.messageToReplyId != null)
        "message_id": messageToSend.messageToReplyId
    });

    try {
      sendAudioLoading = true;
      Response response = await Network.postData(
          url:
              "_private_$subjectId/participants/$userId/messages",
          data: formData);

      Message message = Message.fromJson(response.data['data']);

      messages = messages!.map(
        (e) {
          if (e.id == messageToSend.uniqueId) {
            e.isLocal = false;
            e.isError = false;
            e.id = message.id;
            e.file = message.file;
          }
          return e;
        },
      ).toList();

      sendAudioLoading = false;

      audioMessagesQueue.removeFirst();
      emit(SendSuccessState());
      if (audioMessagesQueue.isNotEmpty) {
        sendAudio(
            messageToSend: audioMessagesQueue.first,
            subjectId: subjectId,
            userId: userId);
      }
    } on DioException catch (_) {
      sendAudioLoading = false;

      for (var element in audioMessagesQueue) {
        messages = messages!.map(
          (e) {
            if (element.uniqueId == e.id) {
              e.isError = true;
            }
            return e;
          },
        ).toList();
      }

      emit(FailedSending());
    }
  }

  Queue<MessageToSend> fileMessagesQueue = Queue();

  Future sendFileSunc() async {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
    final date = DateTime.now();
    int uniqueId = date.microsecondsSinceEpoch;

    messages!.insert(
        0,
        Message(
          id: uniqueId,
          subjectId: -2,
          messageId: 0,
          reply: getMessageToreply(),
          file: _pdfPath,
          type: "file",
          createdAt: date,
          isSentByAuthUser: true,
          isLocal: true,
        ));

    fileMessagesQueue.add(MessageToSend(
      type: "file",
      uniqueId: uniqueId,
      file: _pdfPath,
      messageToReplyId: messageToReplyId,
    ));

    _reply = false;

    messageToReplyId = null;
    emit(SendingFileState());
  }

  Future<void> sendFile(
      {required int subjectId,
      required int userId,
      required MessageToSend messageToSend}) async {
    if (sendFileLoading) {
      return;
    }

    try {
      sendFileLoading = true;
      FormData formData = FormData.fromMap({
        "type": messageToSend.type,
        "file":
            await MultipartFile.fromFile(messageToSend.file!, filename: "file"),
        if (_reply) "message_id": messageToSend.messageToReplyId
      });

      Response response = await Network.postData(
          onSendProgress: (count, total) {
            int percentage = (count / total * 100).toInt();
            sendingFilePercentageKey.currentState?.sending(percentage);
          },
          url:
              "_private_$subjectId/participants/$userId/messages",
          data: formData);

      Message message = Message.fromJson(response.data['data']);
      messages = messages!.map(
        (e) {
          if (e.id == messageToSend.uniqueId) {
            e.id = message.id;
            e.file = message.file;
            e.isLocal = false;
            e.isError = false;
          }
          return e;
        },
      ).toList();
      sendFileLoading = false;

      fileMessagesQueue.removeFirst();
      emit(SendSuccessState());

      if (fileMessagesQueue.isNotEmpty) {
        sendFile(
            messageToSend: fileMessagesQueue.first,
            subjectId: subjectId,
            userId: userId);
      }
    } on DioException catch (error) {
      sendFileLoading = false;

      for (var element in fileMessagesQueue) {
        messages = messages!.map(
          (e) {
            if (element.uniqueId == e.id) {
              e.isError = true;
            }
            return e;
          },
        ).toList();
      }

      if (error.type == DioExceptionType.badResponse) {
        emit(NotCompatibleState(message: "الصيغة المدعومة حصراً pdf"));
        fileMessagesQueue.removeFirst();
      } else {
        emit(FailedSending());
      }
    }
  }

  Queue<MessageToSend> imageMessageQueue = Queue();
  Future sendImageMessage() async {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
    final date = DateTime.now();

    int uniqueId = DateTime.now().microsecondsSinceEpoch;

    messages!.insert(
        0,
        Message(
          id: uniqueId,
          subjectId: -2,
          file: imageToSend!.path,
          reply: getMessageToreply(),
          type: "image",
          createdAt: date,
          isSentByAuthUser: true,
          isLocal: true,
        ));

    imageMessageQueue.add(MessageToSend(
      type: "image",
      uniqueId: uniqueId,
      messageToReplyId: messageToReplyId,
      file: File(imageToSend!.path).path,
    ));

    chatController.text = "";
    messageToReplyId = null;
    _reply = false;
    recordButton = true;

    emit(SendingImageState());
  }

  sendImage(
      {required int subjectId,
      required int userId,
      required MessageToSend messageToSend}) async {
    FormData formData = FormData.fromMap({
      "type": "image",
      "file": await MultipartFile.fromFile(messageToSend.file!),
      if (_reply) "message_id": messageToSend.messageToReplyId
    });

    if (sendImageLoading) {
      return;
    }

    try {
      sendImageLoading = true;
      Response response = await Network.postData(
          onSendProgress: (count, total) {
            int percentage = (count / total * 100).toInt();
            sendingImagePercentageKey.currentState?.sending(percentage);
          },
          url:""
             // "_private_$subjectId/participants/$userId/messages",
          , data: formData);

      Message message = Message.fromJson(response.data['data']);
      messages = messages!.map(
        (e) {
          if (e.id == messageToSend.uniqueId) {
            message.isSentByAuthUser = true;
            e.id = message.id;
            e.isLocal = false;
            e.isError = false;
            e.file = message.file;
          }
          return e;
        },
      ).toList();
      sendImageLoading = false;
      imageMessageQueue.removeFirst();
      emit(SendSuccessState());

      if (imageMessageQueue.isNotEmpty) {
        sendImage(
            subjectId: subjectId,
            userId: userId,
            messageToSend: imageMessageQueue.first);
      }
    } on DioException catch (_) {
      sendImageLoading = false;
      for (var element in imageMessageQueue) {
        messages = messages!.map(
          (e) {
            if (element.uniqueId == e.id) {
              e.isError = true;
            }
            return e;
          },
        ).toList();
      }

      emit(FailedSending());
    }
  }

  ChatsResponse? chatsResponse;
  List<User>? users;
  Future<void> getChats({required int subjectId}) async {
    _loadingChats = true;
    emit(ChatLoadingState());
    try {
      Response response = await Network.getData(
          url:
              "_private_$subjectId/participants");

      chatsResponse = ChatsResponse.fromJson(response.data);
      users = chatsResponse!.data.data;
      _loadingChats = false;

      emit(ChatSuccessState());
    } on DioException catch (_) {
      _loadingChats = false;

      emit(ChatErrorState());
    }
  }

  OneChatResponse? oneChatsResponse;
  List<Message>? messages;
  RefreshController refreshController = RefreshController();

  Future<void> getMessages({Map? params}) async {
    _oneChatError = false;
    String stringParams = "";

    if (params?['fmid'] == null && params?['lmid'] == null) {
      _loadingOneChat = true;
      emit(ChatLoadingState());
    }

    if (params?['lmid'] != null) {
      emit(ScrollToReplyLoadingState());
    }

    if (params != null) {
      params.forEach((key, value) {
        stringParams = "$stringParams&$key=$value";
      });
    }
    try {
      Response response = await Network.getData(
          url: stringParams == ""
              ? "_private_$subjectId/participants/$userId/messages"
              : "_private_$subjectId/participants/$userId/messages?$stringParams");

      oneChatsResponse = OneChatResponse.fromJson(response.data);

      if (params?['fmid'] == null && params?['lmid'] == null) {
        messages = oneChatsResponse!.data.data;
        _loadingOneChat = false;

        emit(ChatSuccessState());
      } else if (params?['lmid'] != null) {
        List<Message> receivedMessages = oneChatsResponse!.data.data;
        mergeMessages(
            receivedMessages: receivedMessages, mergeAfterGoToReply: true);
        emit(ScrollToReplySucsesState());
      } else {
        if (oneChatsResponse!.data.data.isEmpty) {
          refreshController.loadNoData();
        } else {
          messages!.addAll(oneChatsResponse!.data.data);
          refreshController.loadComplete();
        }
        emit(ChatSuccessState());
      }
    } on DioException catch (_) {
      _loadingOneChat = false;
      refreshController.loadComplete();
      if (!params!.containsKey('fmid')) {
        _oneChatError = true;
      }
      emit(AuthRefreshErrorState());
    }
  }

  void startAutoRefresh() {
    Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        autoRefresh();
      },
    );
  }

  Future<void> autoRefresh() async {
    int? lmid;

    for (int i = messages!.length - 1; i > -1; i--) {
      if (messages![i].readAt == null && !messages![i].isLocal) {
        lmid = messages![i].id;
        break;
      }
    }

    try {
      Response response = await Network.getData(
          url:
              "_private_$subjectId/participants/$userId/messages?lmid=${lmid ?? -1}");

      oneChatsResponse = OneChatResponse.fromJson(response.data);

      List<Message> receivedMessages = oneChatsResponse!.data.data;
      mergeMessages(receivedMessages: receivedMessages);

      emit(ChatSuccessState());
    } on DioException catch (_) {
      _loadingOneChat = false;

      emit(AuthRefreshErrorState());
    }
  }

  void mergeMessages(
      {required List receivedMessages, bool mergeAfterGoToReply = false}) {
    List<Message> temp = List.from(messages!);

    List<Message> newMessages = [];

    Set<int> existingMessageIds = temp.map((msg) => msg.id).toSet();

    for (Message receivedMessage in receivedMessages) {
      if (existingMessageIds.contains(receivedMessage.id)) {
        int index = temp.indexWhere((msg) => msg.id == receivedMessage.id);
        temp[index] = receivedMessage;
      } else {
        newMessages.add(receivedMessage);
      }
    }

    if (mergeAfterGoToReply) {
      temp.addAll(newMessages);
    } else {
      temp.insertAll(0, newMessages);
    }

    temp.sort((a, b) => b.id.compareTo(a.id));

    messages = temp;
  }
}
