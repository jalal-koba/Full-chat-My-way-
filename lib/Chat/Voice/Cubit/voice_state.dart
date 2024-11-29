abstract class VoiceState {}

final class VoiceInitialState extends VoiceState {}

final class VoiceInitialLoading extends VoiceState {}

final class VoiceSuccessState extends VoiceState {}

final class VoiceErrorState extends VoiceState {
  VoiceErrorState({required this.message, this.code = 0});
  String message;
  int code;
}
