import 'package:get/get.dart';

class ProfileSettingsController extends GetxController {
  RxBool debugMode = false.obs;

  setDebugMode(bool value) => debugMode.value = value;

}