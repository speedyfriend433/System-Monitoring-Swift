import UIKit

func clearDiskUsage() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    guard let cachePath = paths.first else {
        return "Failed to get cache directory."
    }

    do {
        let filePaths = try FileManager.default.contentsOfDirectory(atPath: cachePath)
        for filePath in filePaths {
            try FileManager.default.removeItem(atPath: cachePath + "/" + filePath)
        }
        return "Disk usage cleared successfully."
    } catch {
        return "Failed to clear disk usage: \(error.localizedDescription)"
    }
}