import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Voice/Cubit/voice_state.dart';
import 'package:voice_message_player/voice_message_player.dart';

class VoiceCubit extends Cubit<VoiceState> {
  VoiceCubit() : super(VoiceInitialState());
  static VoiceCubit get(context) => BlocProvider.of(context);

  Future<VoiceController> addVoiceController(
      soundPath, int id, ChatCubit chatCubit) async {
    final controller = VoiceController(
      audioSrc: "_private_/storage/$soundPath",
      maxDuration: const Duration(hours: 2),
      isFile: false,
      onComplete: () {},
      onPause: () {},
      onPlaying: () {
        if (chatCubit.prevControllerMap != -1 &&
            chatCubit.prevControllerMap != id) {
          chatCubit.mapVoiceControllers[chatCubit.prevControllerMap]
              ?.stopPlaying();
        }
        chatCubit.prevControllerMap = id;
      },
    );
    await controller.init();

    print("${controller.maxDuration}============================");

    if (!isClosed) {
      emit(VoiceSuccessState());
    }
    return controller;
  }
}
