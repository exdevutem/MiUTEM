enum Perfil {
  estudiante,
  funcionario,
  profesor;

  String get displayName => switch (this) {
    Perfil.estudiante => "Estudiante",
    Perfil.funcionario => "Funcionario",
    Perfil.profesor => "Profesor",
  };
}