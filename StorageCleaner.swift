import UIKit

func clearTemporaryFiles() -> String {
    let tmpDirURL = FileManager.default.temporaryDirectory
    do {
        let tmpFiles = try FileManager.default.contentsOfDirectory(at: tmpDirURL, includingPropertiesForKeys: nil, options: [])
        for url in tmpFiles {
            try FileManager.default.removeItem(at: url)
        }
        return "Temporary files cleared successfully."
    } catch {
        return "Failed to clear temporary files: \(error.localizedDescription)"
    }
}