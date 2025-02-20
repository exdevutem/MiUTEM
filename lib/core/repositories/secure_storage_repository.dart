import 'dart:convert';

import 'package:miutem/core/models/user/credential.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/utils/constants.dart';

const String credentialsKey = "auth_credentials";
const String estudianteKey = "estudiante";
const String miutemCookiesKey = "miutem_cookies";

class SecureStorageRepository {

  /* Mi.UTEM Cookie */
  Future<String?> getMiUTEMCookies() async {
    return await secureStorage.read(key: miutemCookiesKey);
  }

  Future<bool> hasMiUTEMCookies() async => await secureStorage.containsKey(key: miutemCookiesKey);

  Future<void> setMiUTEMCookies(String? cookies) async => cookies == null ? await secureStorage.delete(key: miutemCookiesKey) : await secureStorage.write(key: miutemCookiesKey, value: cookies);

  /* Estudiante */
  Future<Estudiante?> getEstudiante() async {
    if(!await hasEstudiante()) {
      return null;
    }

    final data = await secureStorage.read(key: estudianteKey);
    if(data == null) {
      return null;
    }

    return Estudiante.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<bool> hasEstudiante() async => await secureStorage.containsKey(key: estudianteKey);

  Future<void> setEstudiante(Estudiante? estudiante) async => estudiante == null ? await secureStorage.delete(key: estudianteKey) : await secureStorage.write(key: estudianteKey, value: estudiante.toString());

  /* Credentials */
  Future<Credentials?> getCredentials() async  {
    if(!await hasCredentials()) {
      return null;
    }

    final data = await secureStorage.read(key: credentialsKey);
    if(data == null) {
      return null;
    }

    return Credentials.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<bool> hasCredentials() async => await secureStorage.containsKey(key: credentialsKey);

  Future<void> setCredentials(Credentials? credential) async => credential == null ? await secureStorage.delete(key: credentialsKey) : await secureStorage.write(key: credentialsKey, value: credential.toString());
}