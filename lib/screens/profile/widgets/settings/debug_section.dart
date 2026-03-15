import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:miutem/core/services/auth_service.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/styles/styles.dart";

class DebugSection extends StatelessWidget {

  const DebugSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Space.small,
      Text("Depuración", style: Theme.of(context).textTheme.bodyLarge),
      const ListTile(
        title: Text("Sabor de la App"),
        subtitle: Text(appFlavor == "production" ? "Versión de producción" : "Versión de desarrollo")
      ),
      ListTile(
        title: const Text("ID de usuario"),
        subtitle: const Text("Copia el ID de usuario para usar en reportes o pruebas"),
        onTap: () async {
          final userId = await _getUserId();
          await Clipboard.setData(ClipboardData(text: userId));
          if (context.mounted) showTextSnackbar(context, title: "ID copiado", message: 'El ID de usuario "$userId" se ha copiado al portapapeles');
        },
      ),
      ListTile(
        title: const Text("Reiniciar sesión"),
        subtitle: const Text("Cierra la sesión actual y vuelve a iniciar sesión"),
        onTap: () async {
          await Get.find<AuthService>().login(forceRefresh: true);
          if (context.mounted) showTextSnackbar(context, title: "Sesión reiniciada", message: "Se ha reiniciado la sesión correctamente");
        },
      ),
      ListTile(
        title: const Text("Generar error de prueba"),
        subtitle: const Text("Genera un error para probar el sistema de reportes"),
        onTap: () {
          throw Exception("Error de prueba generado por el usuario");
        },
      ),
    ],
  );

  Future<String> _getUserId() async {
    final persona = await Get.find<AuthService>().login();
    return generateUserId(persona.correoUtem);
  }
}


