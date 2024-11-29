abstract class ChatStates {}

class InitialState extends ChatStates {}

// sending
class SendingTextState extends ChatStates {}

class SendingAudioState extends ChatStates {}

class SendingImageState extends ChatStates {}

class SendingFileState extends ChatStates {}

class SendSuccessState extends ChatStates {}

class FailedSending extends ChatStates {}

class NotCompatibleState extends ChatStates {
  NotCompatibleState({required this.message});
  final String message;
}

class IsTyping extends ChatStates {}

class InitialRecording extends ChatStates {}

class IsRecording extends ChatStates {}

class ImagePicked extends ChatStates {}

class FilePicked extends ChatStates {}

class IsChoseingFile extends ChatStates {}

class ChatLoadingState extends ChatStates {}

class ChatSuccessState extends ChatStates {}

class ChatErrorState extends ChatStates {}

class AuthRefreshErrorState extends ChatStates {}

class ScrollToReplyState extends ChatStates {}

class ScrollToReplyLoadingState extends ChatStates {}

class ScrollToReplySucsesState extends ChatStates {}
