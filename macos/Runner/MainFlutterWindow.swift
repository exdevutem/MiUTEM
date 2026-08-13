import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Tamaño exacto del área de Flutter, en puntos. Lo define el lane `mac screenshots`
    // (MIUTEM_WINDOW_SIZE=1440x900) porque la Mac App Store sólo acepta capturas de
    // 1280x800, 1440x900, 2560x1600 o 2880x1800: la ventana tiene que salir con esa forma.
    let tamano = ProcessInfo.processInfo.environment["MIUTEM_WINDOW_SIZE"]?
      .split(separator: "x").compactMap { Double($0) } ?? []
    if tamano.count == 2 {
      self.setContentSize(NSSize(width: tamano[0], height: tamano[1]))
      self.center()
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
