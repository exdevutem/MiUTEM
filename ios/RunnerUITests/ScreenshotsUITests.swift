import Foundation
import XCTest

/// Recorrido de las capturas de la App Store, tal como lo pide la guía de fastlane para
/// iOS: la app se maneja con los UI Tests de Apple y cada pantalla se guarda llamando a
/// `snapshot(...)`. https://docs.fastlane.tools/getting-started/ios/screenshots/
///
/// Lo ejecuta `bundle exec fastlane ios screenshots`, nunca Xcode a mano: corriendo el
/// test desde el IDE no se generan las capturas.
///
/// El lane compila la app con `--dart-define=SCREENSHOT_MODE=true`, así que responde con
/// los datos ficticios de `lib/core/mock/` y acepta cualquier usuario y clave: no hace
/// falta ninguna cuenta real.
final class ScreenshotsUITests: XCTestCase {
  /// En modo capturas la sesión vive en memoria y el par se acepta tal cual.
  private let usuario = "ecarrenos"
  private let clave = "utem2027"

  /// El simulador arranca frío y la app va en debug: cada pantalla tarda bastante más
  /// que en un teléfono real, así que las esperas son generosas.
  private let limiteDeEspera: TimeInterval = 180

  /// Las capturas 01 y 02 no salen de la app: son la composición del teléfono en diagonal
  /// que arma `scripts/compose-store-screenshots`. Por eso el recorrido parte en la 03,
  /// y los nombres llevan el número escrito: el orden del archivo es el orden en la tienda.
  @MainActor
  func testCapturaLasPantallasDeLaTienda() {
    continueAfterFailure = false

    let app = XCUIApplication()
    // `waitForAnimations: false` porque la app nunca se queda quieta —el video del login y
    // los skeletons animan siempre— y la espera previa a cada captura no terminaría nunca.
    setupSnapshot(app, waitForAnimations: false)
    app.launch()

    iniciarSesion(app)

    // 03 — el inicio, pero en oscuro: es la novedad que se está mostrando.
    cambiarTema(app, a: "Oscuro")
    irAPestana(app, "Inicio")
    snapshot("03_oscuro")
    cambiarTema(app, a: "Claro")

    // 04 — la calculadora de notas, que cuelga de los accesos rápidos de Asignaturas.
    irAPestana(app, "Asignaturas")
    abrirAccesoRapido(app, "Notas")
    snapshot("04_calculadora")
    volver(app)

    // 05 — el inicio en claro, con la primera clase del día en curso.
    irAPestana(app, "Inicio")
    snapshot("05_inicio")

    // 06 — la credencial con el código QR.
    irAPestana(app, "Credencial")
    snapshot("06_credencial")

    // 07 y 08 — horario y malla histórica, también desde los accesos rápidos.
    irAPestana(app, "Asignaturas")
    for (acceso, archivo) in [("Horario", "07_horario"), ("Malla Histórica", "08_malla")] {
      abrirAccesoRapido(app, acceso)
      snapshot(archivo)
      volver(app)
    }
  }

  // MARK: - Recorrido

  @MainActor
  private func iniciarSesion(_ app: XCUIApplication) {
    // Si el formulario no aparece, la app se compiló sin la bandera y estaría pidiendo
    // una cuenta real contra SIGA.
    let campoUsuario = esperar(
      app.textFields.firstMatch,
      "el login (¿falta --dart-define=SCREENSHOT_MODE=true?)"
    )
    campoUsuario.tap()
    campoUsuario.typeText(usuario)

    // La contraseña va oculta, así que Flutter la publica como campo seguro. Si el
    // simulador no la reporta así, es el segundo campo de texto del formulario.
    let campoClave = app.secureTextFields.firstMatch.exists
      ? app.secureTextFields.firstMatch
      : app.textFields.element(boundBy: 1)
    esperar(campoClave, "el campo de contraseña")
    campoClave.tap()
    campoClave.typeText(clave)

    tocar(app, "Ingresar", "el botón de ingresar")
    esperar(app, "Inicio", "la navegación principal")
    esperarCarga()
  }

  /// Cambia el tema pasando por Perfil → Pantalla → Tema, que es el único camino que
  /// existe desde afuera de la app: XCUITest sólo puede tocar lo que se ve en pantalla.
  @MainActor
  private func cambiarTema(_ app: XCUIApplication, a modo: String) {
    irAPestana(app, "Perfil")
    tocar(app, "Tema de la aplicación", "el ajuste de tema")
    esperarCarga(2)
    // Con el diálogo abierto Flutter deja de publicar la pantalla de atrás, así que la
    // etiqueta del modo sólo puede ser la de la opción y no la del subtítulo del ajuste.
    tocar(app, modo, "la opción de tema \(modo)")
    esperarCarga(3)
  }

  @MainActor
  private func irAPestana(_ app: XCUIApplication, _ etiqueta: String) {
    tocar(app, etiqueta, "la pestaña \(etiqueta)")
    esperarCarga()
  }

  /// Abre una pantalla desde las tarjetas de acceso rápido.
  ///
  /// No hace falta acotar la búsqueda a Asignaturas aunque el inicio tenga accesos
  /// homónimos: la navegación mantiene montadas las dos pestañas, pero Flutter publica en
  /// el árbol de accesibilidad sólo la que se está mostrando.
  @MainActor
  private func abrirAccesoRapido(_ app: XCUIApplication, _ etiqueta: String) {
    tocar(app, etiqueta, "el acceso rápido \(etiqueta)")
    esperarCarga()
  }

  /// Vuelve de una pantalla abierta desde los accesos rápidos.
  ///
  /// El botón de volver de la AppBar llega con la etiqueta que le pone Flutter según el
  /// idioma del sistema, así que se prueban las tres posibles y, si no está ninguna, se
  /// arrastra desde el borde izquierdo, que en iOS hace exactamente lo mismo.
  @MainActor
  private func volver(_ app: XCUIApplication) {
    for etiqueta in ["Atrás", "Back", "Volver"] {
      let boton = app.buttons.matching(predicado(etiqueta)).firstMatch
      if boton.exists && boton.isHittable {
        boton.tap()
        esperarCarga(3)
        return
      }
    }

    let borde = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
    let centro = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
    borde.press(forDuration: 0.05, thenDragTo: centro)
    esperarCarga(3)
  }

  // MARK: - Utilidades

  /// Predicado de búsqueda por etiqueta de accesibilidad.
  ///
  /// Se compara por contenido y no por igualdad porque Flutter junta en una sola etiqueta
  /// el título y el subtítulo de un mismo control ("Tema de la aplicación" llega con el
  /// tema actual pegado detrás).
  private func predicado(_ etiqueta: String) -> NSPredicate {
    NSPredicate(format: "label CONTAINS %@ OR identifier == %@", etiqueta, etiqueta)
  }

  /// Espera a que aparezca un nodo con esa etiqueta y devuelve el que se puede tocar: el
  /// mismo texto suele estar además como texto suelto dentro del control.
  @discardableResult
  @MainActor
  private func esperar(_ app: XCUIApplication, _ etiqueta: String, _ descripcion: String) -> XCUIElement {
    let cualquiera = app.descendants(matching: .any).matching(predicado(etiqueta)).firstMatch
    XCTAssertTrue(
      cualquiera.waitForExistence(timeout: limiteDeEspera),
      "No apareció \(descripcion) después de \(Int(limiteDeEspera))s."
    )

    let boton = app.buttons.matching(predicado(etiqueta)).firstMatch
    return boton.exists ? boton : cualquiera
  }

  @discardableResult
  @MainActor
  private func esperar(_ elemento: XCUIElement, _ descripcion: String) -> XCUIElement {
    XCTAssertTrue(
      elemento.waitForExistence(timeout: limiteDeEspera),
      "No apareció \(descripcion) después de \(Int(limiteDeEspera))s."
    )
    return elemento
  }

  /// Toca un elemento, desplazando la pantalla si quedó fuera de vista: Perfil publica
  /// todos sus ajustes en el árbol, pero XCUITest sólo puede tocar los que se ven.
  @MainActor
  private func tocar(_ app: XCUIApplication, _ etiqueta: String, _ descripcion: String) {
    let elemento = esperar(app, etiqueta, descripcion)

    var intentos = 0
    while !elemento.isHittable && intentos < 6 {
      app.swipeUp()
      intentos += 1
    }

    XCTAssertTrue(elemento.isHittable, "\(descripcion) nunca quedó a la vista para tocarlo.")
    elemento.tap()
  }

  /// Las pantallas cargan sus datos al abrirse —aunque sean los ficticios— y el cambio de
  /// pestaña se anima, así que se les da tiempo antes de capturar.
  private func esperarCarga(_ segundos: UInt32 = 8) {
    sleep(segundos)
  }
}
