package cl.inndev.miutem

import android.content.Intent
import android.os.SystemClock
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.uiautomator.By
import androidx.test.uiautomator.UiDevice
import androidx.test.uiautomator.UiObject2
import androidx.test.uiautomator.Until
import java.util.regex.Pattern
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.JUnit4
import tools.fastlane.screengrab.Screengrab
import tools.fastlane.screengrab.locale.LocaleTestRule

/**
 * Recorrido de las capturas de Google Play, tal como lo pide la guía de fastlane para
 * Android: un test instrumentado con JUnit4, la regla de idiomas de screengrab y una
 * llamada a `Screengrab.screenshot(...)` en cada pantalla.
 * https://docs.fastlane.tools/getting-started/android/screenshots/
 *
 * Lo ejecuta `bundle exec fastlane android screenshots`.
 *
 * Las pantallas son de Flutter, así que no hay ids de vistas contra los que apuntar con
 * Espresso: la app se recorre por el árbol de accesibilidad con UI Automator, que es el
 * mismo que usa screengrab para tomar la captura.
 *
 * El lane compila la app con `--dart-define=SCREENSHOT_MODE=true`, así que responde con
 * los datos ficticios de `lib/core/mock/` y acepta cualquier usuario y clave.
 */
@RunWith(JUnit4::class)
class ScreenshotsTest {

    @Rule
    @JvmField
    val localeTestRule = LocaleTestRule()

    private val device: UiDevice
        get() = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation())

    /**
     * Abre la app como lo haría el lanzador del sistema.
     *
     * No se usa ActivityScenarioRule, que es lo que muestra el ejemplo de la guía: vive en
     * androidx.test.ext:junit y arrastra un androidx.test:core más nuevo que el runner
     * 1.3.0 que trae screengrab. Como AGP alinea las dependencias de los tests con las de
     * la app, runner no se puede subir, y con las versiones mezcladas ActivityScenario
     * revienta con "AbstractMethodError: ActivityInvoker.getIntentForActivity".
     */
    @Before
    fun abrirLaApp() {
        val contexto = InstrumentationRegistry.getInstrumentation().targetContext
        val intent = requireNotNull(contexto.packageManager.getLaunchIntentForPackage(contexto.packageName)) {
            "El paquete ${contexto.packageName} no tiene actividad de lanzamiento."
        }
        // Sin la tarea anterior: cada corrida parte de cero, igual que abriendo la app a mano.
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        contexto.startActivity(intent)

        if (device.wait(Until.hasObject(By.pkg(contexto.packageName).depth(0)), LIMITE) != true) {
            throw AssertionError("La app no llegó a mostrarse después de ${LIMITE / 1000}s.")
        }
    }

    /**
     * Las capturas 01 y 02 no salen de la app: son la composición del teléfono en diagonal
     * que arma `scripts/compose-store-screenshots`. Por eso el recorrido parte en la 03, y
     * los nombres llevan el número escrito: el orden del archivo es el orden en la ficha.
     */
    @Test
    fun capturaLasPantallasDeLaTienda() {
        iniciarSesion()

        // 03 — el inicio, pero en oscuro: es la novedad que se está mostrando.
        cambiarTema("Oscuro")
        irAPestana("Inicio")
        Screengrab.screenshot("03_oscuro")
        cambiarTema("Claro")

        // 04 — la calculadora de notas, que cuelga de los accesos rápidos de Asignaturas.
        irAPestana("Asignaturas")
        abrirAccesoRapido("Notas")
        Screengrab.screenshot("04_calculadora")
        volver()

        // 05 — el inicio en claro, con la primera clase del día en curso.
        irAPestana("Inicio")
        Screengrab.screenshot("05_inicio")

        // 06 — la credencial con el código QR.
        irAPestana("Credencial")
        Screengrab.screenshot("06_credencial")

        // 07 y 08 — horario y malla histórica, también desde los accesos rápidos.
        irAPestana("Asignaturas")
        for ((acceso, archivo) in listOf("Horario" to "07_horario", "Malla Histórica" to "08_malla")) {
            abrirAccesoRapido(acceso)
            Screengrab.screenshot(archivo)
            volver()
        }
    }

    // ---- Recorrido ----

    private fun iniciarSesion() {
        // `or` y no `||`: el segundo campo se escribe siempre, no sólo si el primero
        // necesitó el teclado.
        val conTeclado = escribir(0, USUARIO) or escribir(1, CLAVE)
        if (conTeclado) {
            // El teclado tapa el botón de ingresar. Acá `pressBack` lo cierra en vez de
            // navegar, que es lo que haría con el teclado abajo.
            device.pressBack()
            esperarCarga(1)
        }

        tocar("el botón de ingresar", "Ingresar")
        esperar("la navegación principal", "Inicio")
        esperarCarga()
    }

    /**
     * Escribe en el campo de texto que ocupa esa posición y devuelve si hubo que teclear.
     *
     * Primero por accesibilidad, que es lo que menos molesta: no abre el teclado y por lo
     * tanto no tapa el botón de ingresar. Flutter no siempre atiende esa acción, así que si
     * el campo queda vacío se escribe como lo haría una persona —enfocándolo y mandando las
     * teclas—, y ahí sí queda el teclado arriba.
     *
     * El campo se vuelve a buscar en cada llamada porque escribir en el anterior rehace el
     * árbol de accesibilidad y deja al otro apuntando a un nodo que ya no existe.
     */
    private fun escribir(indice: Int, valor: String): Boolean {
        // En un envoltorio porque UI Automator no se limita a devolver que la acción no se
        // atendió: cuando el nodo la rechaza, revienta.
        val quedoEscrito = runCatching {
            esperarCampos()[indice].text = valor
            SystemClock.sleep(PASO)
            !esperarCampos()[indice].text.isNullOrBlank()
        }.getOrDefault(false)
        if (quedoEscrito) {
            return false
        }

        esperarCampos()[indice].click()
        SystemClock.sleep(PASO)
        InstrumentationRegistry.getInstrumentation().sendStringSync(valor)
        SystemClock.sleep(PASO)
        return true
    }

    /**
     * Cambia el tema pasando por Perfil → Pantalla → Tema, que es el único camino que hay
     * desde afuera de la app: el test sólo puede tocar lo que se ve en pantalla.
     */
    private fun cambiarTema(modo: String) {
        irAPestana("Perfil")
        tocar("el ajuste de tema", "Tema de la aplicación")
        esperarCarga(2)
        // Con el diálogo abierto Flutter deja de publicar la pantalla de atrás, así que la
        // etiqueta del modo sólo puede ser la de la opción y no la del subtítulo del ajuste.
        tocar("la opción de tema $modo", modo)
        esperarCarga(3)
    }

    private fun irAPestana(etiqueta: String) {
        tocar("la pestaña $etiqueta", etiqueta)
        esperarCarga()
    }

    /**
     * Abre una pantalla desde las tarjetas de acceso rápido.
     *
     * No hace falta acotar la búsqueda a Asignaturas aunque el inicio tenga accesos
     * homónimos: la navegación mantiene montadas las dos pestañas, pero Flutter publica en
     * el árbol de accesibilidad sólo la que se está mostrando.
     */
    private fun abrirAccesoRapido(etiqueta: String) {
        tocar("el acceso rápido $etiqueta", etiqueta)
        esperarCarga()
    }

    private fun volver() {
        device.pressBack()
        esperarCarga(3)
    }

    // ---- Utilidades ----

    /**
     * Los campos del login, en el orden en que están en pantalla: usuario y contraseña.
     *
     * Flutter publica sus campos de texto con la clase de un EditText, y se buscan por ahí
     * y no por su etiqueta porque en un campo de texto la etiqueta viaja pegada al valor y
     * al hint, todo en el mismo texto del nodo.
     */
    private fun esperarCampos(): List<UiObject2> {
        val fin = SystemClock.uptimeMillis() + LIMITE
        while (SystemClock.uptimeMillis() < fin) {
            val campos = device.findObjects(By.clazz("android.widget.EditText"))
            if (campos.size >= 2) {
                return campos
            }
            SystemClock.sleep(PASO)
        }

        throw AssertionError(
            "No apareció el login (¿falta --dart-define=SCREENSHOT_MODE=true?) después de ${LIMITE / 1000}s. ${loQueSeVe()}"
        )
    }

    /**
     * Lo que hay en pantalla en el momento del fallo.
     *
     * Va pegado al mensaje del error y no a un log aparte porque el recorrido corre en el
     * emulador de CI: lo único que llega de vuelta es el texto de la excepción, y sin esto
     * un fallo sólo dice "no apareció X" sin distinguir si la app se quedó en el login, si
     * mostró un error o si la etiqueta que se busca cambió de nombre.
     */
    private fun loQueSeVe(): String {
        // `By.text`/`By.desc` con patrón y no con texto: así traen todo lo que tenga algo
        // escrito. DOTALL porque una etiqueta con salto de línea si no queda fuera.
        val algo = Pattern.compile(".+", Pattern.DOTALL)
        val textos = device.findObjects(By.text(algo)).mapNotNull { it.text }
        val etiquetas = device.findObjects(By.desc(algo)).mapNotNull { it.contentDescription }
        val visible = (textos + etiquetas).map { it.trim() }.filter { it.isNotEmpty() }.distinct()

        return if (visible.isEmpty()) {
            "No hay ningún texto ni etiqueta en pantalla."
        } else {
            "En pantalla: ${visible.joinToString(" ┊ ").take(3000)}"
        }
    }

    /**
     * Busca un nodo por su etiqueta de accesibilidad.
     *
     * Se compara por contenido y no por igualdad porque Flutter junta en una sola etiqueta
     * el título y el subtítulo de un mismo control, y se prefiere el nodo tocable: el
     * mismo texto suele estar además como texto suelto dentro del control.
     */
    private fun buscar(texto: String): UiObject2? =
        device.findObject(By.clickable(true).descContains(texto))
            ?: device.findObject(By.clickable(true).textContains(texto))
            ?: device.findObject(By.descContains(texto))
            ?: device.findObject(By.textContains(texto))

    private fun esperar(descripcion: String, texto: String): UiObject2 {
        val fin = SystemClock.uptimeMillis() + LIMITE
        while (SystemClock.uptimeMillis() < fin) {
            buscar(texto)?.let { return it }
            SystemClock.sleep(PASO)
        }

        throw AssertionError("No apareció $descripcion después de ${LIMITE / 1000}s. ${loQueSeVe()}")
    }

    /**
     * Toca un nodo, desplazando la pantalla si quedó fuera de vista: Perfil publica todos
     * sus ajustes en el árbol de accesibilidad, pero sólo se puede tocar lo que se ve.
     */
    private fun tocar(descripcion: String, texto: String) {
        var objeto = esperar(descripcion, texto)

        var intentos = 0
        while (objeto.visibleBounds.isEmpty && intentos < 6) {
            device.swipe(device.displayWidth / 2, device.displayHeight * 3 / 4, device.displayWidth / 2, device.displayHeight / 4, 20)
            SystemClock.sleep(PASO)
            objeto = esperar(descripcion, texto)
            intentos++
        }

        if (objeto.visibleBounds.isEmpty) {
            throw AssertionError("$descripcion nunca quedó a la vista para tocarlo. ${loQueSeVe()}")
        }

        objeto.click()
    }

    /**
     * Las pantallas cargan sus datos al abrirse —aunque sean los ficticios— y el cambio de
     * pestaña se anima, así que se les da tiempo antes de capturar.
     */
    private fun esperarCarga(segundos: Long = 8) = SystemClock.sleep(segundos * 1000)

    private companion object {
        /** En modo capturas la sesión vive en memoria y el par se acepta tal cual. */
        const val USUARIO = "ecarrenos"
        const val CLAVE = "utem2027"

        /** El emulador arranca frío y la app va en debug: las esperas son generosas. */
        const val LIMITE = 180_000L
        const val PASO = 500L
    }
}
