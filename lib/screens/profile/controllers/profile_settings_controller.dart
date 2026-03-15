import "package:get/get.dart";

class ProfileSettingsController extends GetxController {
  RxBool debugMode = false.obs;

  bool setDebugMode(bool value) => debugMode.value = value;

}