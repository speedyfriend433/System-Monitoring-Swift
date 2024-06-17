import UIKit

func toggleDarkMode() {
    let currentMode = UIScreen.main.traitCollection.userInterfaceStyle
    let newMode: UIUserInterfaceStyle = currentMode == .dark ? .light : .dark
    if let window = UIApplication.shared.windows.first {
        window.overrideUserInterfaceStyle = newMode
    }
}