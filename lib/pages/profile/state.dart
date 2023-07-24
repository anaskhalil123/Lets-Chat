import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:get/get.dart';

class ProfileState {
  RxString name = ''.obs;
  RxString uid = ''.obs;
  RxString userAvatar = ''.obs;
}

//Binding -> Controller -> State