import "package:miutem/core/models/asignaturas/asignatura.dart";
import "package:miutem/core/models/asignaturas/asignatura_malla.dart";
import "package:miutem/core/models/carrera.dart";
import "package:miutem/core/models/evaluacion/evaluacion.dart";
import "package:miutem/core/models/evaluacion/grades.dart";
import "package:miutem/core/models/horario.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/core/models/user/persona/persona.dart";
import "package:miutem/core/models/user/persona/rut.dart";

/// Datos ficticios usados para generar las capturas de las tiendas.
/// Ninguno corresponde a una persona, cuenta o matrícula real.

/// Foto del avatar. Es un asset, no una URL: [UserAvatar] distingue por el prefijo.
const String fotoEstudianteMock = "assets/mock/alex-suprun-unsplash.jpg";

final Estudiante estudianteMock = Estudiante(
  // El token nunca se valida en modo capturas, pero se marca para que nada intente refrescarlo.
  token: "mock.screenshot.token",
  ignoreTokenExpiration: true,
  rut: Rut(12345678),
  nombreCompleto: "Ernesto Carreño Silva",
  correoUtem: "ecarrenos@utem.cl",
  correoPersonal: "ernesto.carreno.silva@gmail.com",
  fotoUrl: fotoEstudianteMock,
  perfiles: const [Perfil.estudiante],
);

const Carrera carreraMock = Carrera(
  id: "21041",
  nombre: "Ingeniería en Informática",
  estado: "Regular",
  codigo: "21041",
);

final Asignatura computacionEnLaNube = Asignatura(
  id: "1001",
  codigo: "INFO8002",
  nombre: "Computación en la Nube",
  tipoHora: "Cátedra",
  estado: "Inscrito",
  seccion: "1",
  docente: Persona(nombreCompleto: "Camila Rojas Vergara"),
  tipoAsignatura: "Obligatoria",
  sala: "M8 - 201",
  intentos: 1,
);

final Asignatura trabajoDeTitulo = Asignatura(
  id: "1002",
  codigo: "INFB698",
  nombre: "Trabajo de Título I",
  tipoHora: "Cátedra",
  estado: "Inscrito",
  seccion: "1",
  docente: Persona(nombreCompleto: "Andrés Fuentes Lillo"),
  tipoAsignatura: "Obligatoria",
  sala: "M4 - 302",
  intentos: 1,
);

final Asignatura practicaProfesional = Asignatura(
  id: "1003",
  codigo: "INFB900",
  nombre: "Práctica Profesional",
  tipoHora: "Taller",
  estado: "Inscrito",
  seccion: "1",
  docente: Persona(nombreCompleto: "Paula Navarro Díaz"),
  tipoAsignatura: "Obligatoria",
  sala: "M8 - 103",
  intentos: 1,
);

final List<Asignatura> asignaturasMock = [
  computacionEnLaNube,
  trabajoDeTitulo,
  practicaProfesional,
];

/// Clases de la semana como (período 1..9, día 1..6, asignatura).
/// El lunes concentra las tres asignaturas para que "Clases de Hoy" no quede vacío.
final List<(int, int, Asignatura)> _clasesMock = [
  (1, 1, computacionEnLaNube),
  (3, 1, trabajoDeTitulo),
  (5, 1, practicaProfesional),
  (2, 2, computacionEnLaNube),
  (6, 2, trabajoDeTitulo),
  (1, 3, practicaProfesional),
  (4, 3, computacionEnLaNube),
  (3, 4, trabajoDeTitulo),
  (5, 4, practicaProfesional),
  (2, 5, computacionEnLaNube),
  (4, 5, practicaProfesional),
];

/// Horario de 18 medios bloques x 6 días, igual a la matriz que arma [HorarioService].
/// Cada clase ocupa los dos medios bloques de su período, como en SIGA.
Horario horarioMock() {
  final horario = List.generate(18, (_) => List.generate(6, (_) => BloqueHorario()));

  for (final (periodo, dia, asignatura) in _clasesMock) {
    for (final fila in [(periodo - 1) * 2, (periodo - 1) * 2 + 1]) {
      horario[fila][dia - 1] = BloqueHorario(
        asignatura: asignatura,
        sala: asignatura.sala,
        codigo: "${asignatura.codigo}/${asignatura.seccion}",
      );
    }
  }

  return Horario(horario: horario, asignaturas: asignaturasMock);
}

Grades notasMock(Asignatura asignatura) => switch (asignatura.codigo) {
  "INFO8002" => Grades(
    notasParciales: [
      REvaluacion(descripcion: "Prueba 1", porcentaje: 30, nota: 6.2),
      REvaluacion(descripcion: "Prueba 2", porcentaje: 30, nota: 5.8),
      REvaluacion(descripcion: "Laboratorios", porcentaje: 40, nota: 6.5),
    ],
    notaPresentacion: 6.2,
    notaFinal: 6.2,
  ),
  "INFB698" => Grades(
    notasParciales: [
      REvaluacion(descripcion: "Avance 1", porcentaje: 40, nota: 6.8),
      REvaluacion(descripcion: "Avance 2", porcentaje: 60, nota: 6.4),
    ],
    notaPresentacion: 6.6,
    notaFinal: 6.6,
  ),
  _ => Grades(
    notasParciales: [
      REvaluacion(descripcion: "Informe de Práctica", porcentaje: 60, nota: 6.9),
      REvaluacion(descripcion: "Evaluación de la Empresa", porcentaje: 40, nota: 7.0),
    ],
    notaPresentacion: 6.9,
    notaFinal: 6.9,
  ),
};

AsignaturaMalla _aprobada(int nivel, String nombre, String nota, {String tipo = "Obligatoria"}) =>
    AsignaturaMalla(nivel: nivel, nombre: nombre, tipo: tipo, intentos: 1, estado: "Aprobado", nota: nota);

AsignaturaMalla _inscrita(int nivel, String nombre, {String tipo = "Obligatoria"}) =>
    AsignaturaMalla(nivel: nivel, nombre: nombre, tipo: tipo, intentos: 1, estado: "Inscrito", nota: "-");

AsignaturaMalla _noCursada(int nivel, String nombre, {String tipo = "Obligatoria"}) =>
    AsignaturaMalla(nivel: nivel, nombre: nombre, tipo: tipo, intentos: 0, estado: "No Cursado", nota: "-");

/// Malla de Ingeniería en Informática, con las tres asignaturas en curso inscritas
/// y Trabajo de Título II todavía sin cursar.
final List<AsignaturaMalla> mallaMock = [
  // Nivel 1
  _aprobada(1, "Habilidades de Razonamiento Lógico", "6,2", tipo: "Nivelación"),
  _aprobada(1, "Taller de Ciencia y Tecnología", "4,5"),
  _aprobada(1, "Introducción a la Ingeniería en Informática", "6,0"),
  _aprobada(1, "Algoritmos y Programación", "6,4"),
  _aprobada(1, "Taller de Matemática", "4,0"),
  _aprobada(1, "Design Thinking", "5,0"),
  // Nivel 2
  _aprobada(2, "Electivo de Formación General I", "6,0", tipo: "Electivo"),
  _aprobada(2, "Habilidades de Trabajo Académico", "5,4", tipo: "Nivelación"),
  _aprobada(2, "Cálculo Diferencial", "4,0"),
  _aprobada(2, "Estructuras de Datos", "5,1"),
  _aprobada(2, "Mecánica Clásica", "4,2"),
  _aprobada(2, "Álgebra Clásica", "4,4"),
  // Nivel 3
  _aprobada(3, "Electromagnetismo", "4,1"),
  _aprobada(3, "Bases de Datos", "5,4"),
  _aprobada(3, "Lenguajes de Programación", "4,2"),
  _aprobada(3, "Cálculo Integral", "4,4"),
  _aprobada(3, "Álgebra Superior", "4,3"),
  // Nivel 4
  _aprobada(4, "Arquitectura de Computadores", "5,1"),
  _aprobada(4, "Ingeniería Ambiental", "6,9"),
  _aprobada(4, "Grafos y Lenguajes Formales", "4,0"),
  _aprobada(4, "Sistemas de Información", "6,3"),
  _aprobada(4, "Estadística y Probabilidad", "4,0"),
  _aprobada(4, "Taller de Principios de Sustentabilidad", "6,6"),
  // Nivel 5
  _aprobada(5, "Sistemas Operativos", "4,2"),
  _aprobada(5, "Circuitos Eléctricos", "4,4"),
  _aprobada(5, "Principios de Economía", "4,8"),
  _aprobada(5, "Desarrollo Ágil", "5,6"),
  _aprobada(5, "Análisis de Algoritmos", "4,2"),
  _aprobada(5, "Inglés I", "4,2"),
  // Nivel 6
  _aprobada(6, "Redes y Comunicación de Datos", "7,0"),
  _aprobada(6, "Ciberseguridad", "6,2"),
  _aprobada(6, "Inglés II", "5,1"),
  _aprobada(6, "Fundamentos de Data Science", "6,1"),
  _aprobada(6, "Evaluación de Proyectos Informáticos", "4,0"),
  _aprobada(6, "Ingeniería de Software", "5,1"),
  // Nivel 7
  _aprobada(7, "Electivo de Formación Especializada I", "6,8", tipo: "Electivo"),
  _aprobada(7, "Electivo de Formación Especializada II", "6,3", tipo: "Electivo"),
  _inscrita(7, "Trabajo de Título I"),
  _aprobada(7, "Gestión de Proyectos Informáticos", "5,1"),
  _inscrita(7, "Computación en la Nube"),
  _aprobada(7, "Computación Web y Móvil", "4,5"),
  // Nivel 8
  _noCursada(8, "Trabajo de Título II"),
  _inscrita(8, "Práctica Profesional"),
  _aprobada(8, "Taller de Innovación y Emprendimiento", "6,4"),
];
