import "package:get/get.dart";
import "package:miutem/core/models/user/credencial/credencial_institucional.dart";
import "package:miutem/core/services/auth_service.dart";

class CredencialService {

  Future<CredencialInstitucional> getCredencialInstitucional() async {
    final usuario = await Get.find<AuthService>().login();

    if (usuario.perfiles.isEmpty) {
      throw Exception("El estudiante no tiene perfiles asociados.");
    }

    return CredencialInstitucional(
      persona: usuario,
      perfil: usuario.perfiles.first,
    );
  }
}