
/// ENUM PARA EL ESTADO DE LOS APUNTES
enum TaskState {
  APUNTE,
  RECORDATORIO,
  DONE;

  /// DESCRIPCION DE CADA ESTADO
  String get description {
    switch (this) {
      case TaskState.APUNTE:
        return 'APUNTE';
      case TaskState.RECORDATORIO:
        return 'APUNTE CON RECORDATORIO PENDIENTE';
      case TaskState.DONE:
        return 'APUNTE CON RECORDATORIO CUMPLIDO';
    }
  }

}