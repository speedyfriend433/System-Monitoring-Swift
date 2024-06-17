import Foundation

var appStartTime: Date?

func markAppStartTime() {
    appStartTime = Date()
}

func getAppRunningTime() -> TimeInterval {
    guard let startTime = appStartTime else { return 0 }
    return Date().timeIntervalSince(startTime)
}