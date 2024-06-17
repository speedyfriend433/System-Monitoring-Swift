import UIKit

func getBatteryStatus() -> (level: Float, state: UIDevice.BatteryState) {
    UIDevice.current.isBatteryMonitoringEnabled = true
    return (UIDevice.current.batteryLevel, UIDevice.current.batteryState)
}