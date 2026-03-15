import "dart:ui";

enum Carrera {
  /* Facultad de Ciencias Jurídicas y Sociales (FCJS) */
  administracionPublica(nombre: "Administración Pública", facultad: Facultad.administracionYEconomia),
  derecho(nombre: "Derecho", facultad: Facultad.cienciasJuridicasYSociales),
  psicologia(nombre: "Psicología", facultad: Facultad.cienciasJuridicasYSociales),

  /* Facultad Administración y Economía (FAE) */
  bibliotecologiaYDocumentacion(nombre: "Bibliotecología y Documentación", facultad: Facultad.administracionYEconomia),
  contadorPublicoYAuditor(nombre: "Contador Público y Auditor", facultad: Facultad.administracionYEconomia),
  ingenieriaComercial(nombre: "Ingeniería Comercial", facultad: Facultad.administracionYEconomia),
  ingenieriaEnComercioInternacional(nombre: "Ingeniería en Comercio Internacional", facultad: Facultad.administracionYEconomia),
  ingenieriaEnGestionTuristica(nombre: "Ingeniería en Gestión Turística", facultad: Facultad.administracionYEconomia),

  /* Facultad de Ciencias de la Construcción y Ordenamiento Territorial (FCCOT) */
  arquitectura(nombre: "Arquitectura", facultad: Facultad.cienciasDeLaConstruccionYOrdenamientoTerritorial),
  ingenieriaCivilEnObrasCiviles(nombre: "Ingeniería Civil en Obras Civiles", facultad: Facultad.cienciasDeLaConstruccionYOrdenamientoTerritorial),
  ingenieriaEnConstruccion(nombre: "Ingeniería en Construcción", facultad: Facultad.cienciasDeLaConstruccionYOrdenamientoTerritorial),
  ingenieriaCivilEnPrevencionDeRiesgosYMedioAmbiente(nombre: "Ingeniería Civil en Prevención de Riesgos y Medio Ambiente", facultad: Facultad.cienciasDeLaConstruccionYOrdenamientoTerritorial),

  /* Facultad de Ciencias Naturales, Matemática y del Medio Ambiente (FCNMMA) */
  ingenieriaCivilMatematica(nombre: "Ingeniería Civil Matemática", facultad: Facultad.cienciasNaturalesMatematicaYDelMedioAmbiente),
  ingenieriaCivilQuimica(nombre: "Ingeniería Civil Química", facultad: Facultad.cienciasNaturalesMatematicaYDelMedioAmbiente),
  ingenieriaEnAlimentos(nombre: "Ingeniería en Alimentos", facultad: Facultad.cienciasNaturalesMatematicaYDelMedioAmbiente),
  ingenieriaEnBiotecnologia(nombre: "Ingeniería en Biotecnología", facultad: Facultad.cienciasNaturalesMatematicaYDelMedioAmbiente),
  quimicaIndustrial(nombre: "Química Industrial", facultad: Facultad.cienciasNaturalesMatematicaYDelMedioAmbiente),
  quimicaYFarmacia(nombre: "Química y Farmacia", facultad: Facultad.cienciasNaturalesMatematicaYDelMedioAmbiente),

  /* Facultad de Humanidades y Tecnologías de la Comunicación Social (FHTCS) */
  disenioEnComunicacionVisual(nombre: "Diseño en Comunicación Visual", facultad: Facultad.humanidadesYTecnologiasDeLaComunicacionSocial),
  disenioIndustrial(nombre: "Diseño Industrial", facultad: Facultad.humanidadesYTecnologiasDeLaComunicacionSocial),
  trabajoSocial(nombre: "Trabajo Social", facultad: Facultad.humanidadesYTecnologiasDeLaComunicacionSocial),


  /* Facultad de Ingeniería (FING) */
  bachilleratoEnCienciasDeLaIngenieria(nombre: "Bachillerato en Ciencias de la Ingeniería", facultad: Facultad.ingenieria),
  dibujanteProyectista(nombre: "Dibujante Proyectista", facultad: Facultad.ingenieria),
  ingenieriaCivilBiomedica(nombre: "Ingeniería Civil Biomédica", facultad: Facultad.ingenieria),
  ingenieriaCivilElectronica(nombre: "Ingeniería Civil Electrónica", facultad: Facultad.ingenieria),
  ingenieriaCivilEnCienciaDeDatos(nombre: "Ingeniería Civil en Ciencia de Datos", facultad: Facultad.ingenieria),
  ingenieriaCivilEnComputacionMencionInformatica(nombre: "Ingeniería Civil en Computación mención Informática", facultad: Facultad.ingenieria),
  ingenieriaCivilEnMecanica(nombre: "Ingeniería Civil en Mecánica", facultad: Facultad.ingenieria),
  ingenieriaEnGeomensura(nombre: "Ingeniería en Geomensura", facultad: Facultad.ingenieria),
  ingenieriaEnInformatica(nombre: "Ingeniería en Informática", facultad: Facultad.ingenieria),
  ingenieriaCivilIndustrial(nombre: "Ingeniería Civil Industrial", facultad: Facultad.ingenieria),
  ingenieriaIndustrial(nombre: "Ingeniería Industrial", facultad: Facultad.ingenieria),

  ;

  final String nombre;
  final Facultad facultad;

  const Carrera({
    required this.nombre,
    required this.facultad,
  });

  static List<Carrera> carrerasDeFacultad(Facultad facultad) {
    return Carrera.values.where((carrera) => carrera.facultad == facultad).toList();
  }

  static Carrera fromNombre(String nombre) {
    return Carrera.values.firstWhere((carrera) => carrera.nombre.toLowerCase() == nombre.toLowerCase(), orElse: () => throw Exception("Carrera no encontrada: $nombre"));
  }
}

enum Facultad {
  ingenieria(nombre: "Ingeniería", apodo: "FING", url: "https://fing.utem.cl/", direccion: "Av. Jose Pedro Alessandri 142, Ñuñoa", color: Color(0xFF006699)),
  administracionYEconomia(nombre: "Administración y Economía", apodo: "FAE", url: "https://fae.utem.cl/", direccion: "Dieciocho 161, Santiago", color: Color(0xFFFF6600)),
  cienciasDeLaConstruccionYOrdenamientoTerritorial(nombre: "Ciencias de la Construcción y Ordenamiento Territorial", apodo: "FCCOT", url: "https://fccot.utem.cl/", direccion: "Dieciocho 161, Santiago", color: Color(0xFF660000)),
  cienciasNaturalesMatematicaYDelMedioAmbiente(nombre: "Ciencias Naturales, Matemática y del Medio Ambiente", apodo: "FCNMMA", url: "https://fcnnma.utem.cl/", direccion: "Av. José Pedro Alessandri 142, Ñuñoa", color: Color(0xFF599A25)),
  humanidadesYTecnologiasDeLaComunicacionSocial(nombre: "Humanidades y Tecnologías de la Comunicación Social", apodo: "FHTCS", url: "https://fhtcs.utem.cl/", direccion: "Dieciocho 161, Santiago", color: Color(0xFF650876)),
  cienciasJuridicasYSociales(nombre: "Ciencias Jurídicas y Sociales", apodo: "FCJS", url: "https://noticias.utem.cl/2025/03/07/con-nueva-facultad-comienzan-las-clases-2025-en-utem/", direccion: "Dieciocho 161, Santiago", color: Color(0xFF660066))
  ;


  final String nombre;
  final String apodo;
  final String url;
  final String direccion;
  final Color color;

  const Facultad({
    required this.nombre,
    required this.apodo,
    required this.url,
    required this.direccion,
    required this.color,
  });

  List<Carrera> get carreras => Carrera.carrerasDeFacultad(this);


}