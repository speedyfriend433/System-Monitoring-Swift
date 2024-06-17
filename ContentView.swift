import SwiftUI

struct ContentView: View {
    @State private var cpuUsage: Double = 0.0
    @State private var memoryUsage: (used: UInt64, total: UInt64) = (0, 0)
    @State private var batteryStatus: (level: Float, state: UIDevice.BatteryState) = (0, .unknown)
    @State private var networkStatus: String = "Unknown"
    @State private var diskUsage: (used: UInt64, total: UInt64) = (0, 0)
    @State private var appRunningTime: TimeInterval = 0.0
    @State private var processes: [String] = []
    @State private var coreUsage: [Double] = []
    @State private var cleanStatus: String = ""
    @State private var userDefaults: [String: Any] = [:]

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("System Monitoring")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 20) {
                InfoRow(title: "CPU Usage", value: String(format: "%.2f", cpuUsage) + "%")
                InfoRow(title: "Memory Usage", value: "\(memoryUsage.used / (1024 * 1024))MB / \(memoryUsage.total / (1024 * 1024))MB")
                InfoRow(title: "Battery Level", value: String(format: "%.0f", batteryStatus.level * 100) + "%")
                InfoRow(title: "Battery State", value: batteryStateToString(batteryStatus.state))
                InfoRow(title: "App Running Time", value: String(format: "%.0f", appRunningTime) + " seconds")
                InfoRow(title: "Running Processes", value: processes.joined(separator: ", "))
                InfoRow(title: "Core Usage", value: coreUsage.map { String(format: "%.2f", $0) }.joined(separator: ", "))
                InfoRow(title: "Clean Status", value: cleanStatus)
            }
            .padding()
            .background(Color(UIColor.systemBackground).opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 10)

            Spacer()

            HStack(spacing: 20) {
                ActionButton(title: "Toggle Dark Mode", color: .orange, action: toggleDarkMode)
                ActionButton(title: "Clear Temp Files", color: .green, action: clearTemporaryFilesAction)
                ActionButton(title: "Clear Disk Usage", color: .red, action: clearDiskUsageAction)
            }
            .padding(.top, 20)
        }
        .padding()
        .onAppear {
            markAppStartTime()
            updateSystemInfo()
        }
        .onReceive(timer) { _ in
            updateSystemInfo()
        }
    }

    func updateSystemInfo() {
        cpuUsage = getCPUUsage()
        memoryUsage = getMemoryUsage()
        batteryStatus = getBatteryStatus()
        appRunningTime = getAppRunningTime()
        coreUsage = getCoreUsage()
    }

    func clearTemporaryFilesAction() {
        cleanStatus = clearTemporaryFiles()
    }

    func clearDiskUsageAction() {
        cleanStatus = clearDiskUsage()
    }

    func batteryStateToString(_ state: UIDevice.BatteryState) -> String {
        switch state {
        case .unknown: return "Unknown"
        case .unplugged: return "Unplugged"
        case .charging: return "Charging"
        case .full: return "Full"
        @unknown default: return "Unknown"
        }
    }
}

struct InfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text("\(title):")
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}

struct ActionButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

func formatUserDefaults(_ dictionary: [String: Any]) -> String {
    return dictionary.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
}

