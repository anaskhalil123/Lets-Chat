import 'package:get/get.dart';

class ApplicationState {
  // obs is an extension to int, return XRInt Object with value variable
  // that inital value same the int that u put .obs to it.

  final _page = 0.obs;
  int get page => _page.value;
  set page(int index) => _page.value = index;
}

//Binding -> Controller -> State