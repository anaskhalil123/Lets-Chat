import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:get/get.dart';

class MessageState {
  RxList chattingUsers = <Msg>[].obs;
}

//Binding -> Controller -> State